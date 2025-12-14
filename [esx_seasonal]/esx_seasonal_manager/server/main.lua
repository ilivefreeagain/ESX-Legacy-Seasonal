---@diagnostic disable: undefined-global

local activeEvents = {}

---@param message string
local function debugPrint(message)
  if Config.Debug then
    print(('[ESX Seasonal Manager] %s'):format(message))
  end
end

---@param month number
---@param day number
---@return number
local function dateToOrdinal(month, day)
  -- Convert month/day to ordinal day of year for easier comparison
  local daysInMonth = {31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}
  local ordinal = day
  
  for i = 1, month - 1 do
    ordinal = ordinal + daysInMonth[i]
  end
  
  return ordinal
end

---@param eventKey string
---@param eventConfig table
---@return boolean
local function isEventActive(eventKey, eventConfig)
  -- Check manual override first
  local override = Config.ManualOverrides[eventKey]
  if override ~= nil then
    debugPrint(('Event "%s" has manual override: %s'):format(eventKey, tostring(override)))
    return override
  end
  
  -- If auto-activate is disabled, don't activate automatically
  if not Config.AutoActivate then
    return false
  end
  
  -- Get current date with timezone offset
  local timestamp = os.time() + (Config.TimezoneOffset * 3600)
  local currentDate = os.date('*t', timestamp)
  ---@diagnostic disable-next-line: assign-type-mismatch
  local currentMonth = currentDate.month
  ---@diagnostic disable-next-line: assign-type-mismatch
  local currentDay = currentDate.day
  
  local startMonth = eventConfig.startMonth
  local startDay = eventConfig.startDay
  local endMonth = eventConfig.endMonth
  local endDay = eventConfig.endDay
  
  -- Handle events that span year boundary (like New Year)
  if startMonth > endMonth or (startMonth == endMonth and startDay > endDay) then
    -- Event spans year boundary
    ---@diagnostic disable-next-line: param-type-mismatch
    local currentOrdinal = dateToOrdinal(currentMonth, currentDay)
    local startOrdinal = dateToOrdinal(startMonth, startDay)
    local endOrdinal = dateToOrdinal(endMonth, endDay)
    
    -- Active if after start OR before end
    return currentOrdinal >= startOrdinal or currentOrdinal <= endOrdinal
  else
    -- Normal date range within same year
    ---@diagnostic disable-next-line: param-type-mismatch
    local currentOrdinal = dateToOrdinal(currentMonth, currentDay)
    local startOrdinal = dateToOrdinal(startMonth, startDay)
    local endOrdinal = dateToOrdinal(endMonth, endDay)
    
    -- Active if between start and end
    return currentOrdinal >= startOrdinal and currentOrdinal <= endOrdinal
  end
end

---@param eventKey string
---@param eventConfig table
local function enableEvent(eventKey, eventConfig)
  if activeEvents[eventKey] then
    debugPrint(('Event "%s" is already active'):format(eventConfig.name))
    return
  end
  
  -- Set the event's config to enabled
  local resourceName = eventConfig.resource
  local configPath = ('resources/%s/config/main.lua'):format(resourceName)
  
  -- Trigger the event to start via exports if available
  local success = pcall(function()
    exports[resourceName]:SetEnabled(true)
  end)
  
  if not success then
    debugPrint(('Event "%s" does not have SetEnabled export, using alternative method'):format(eventConfig.name))
  end
  
  activeEvents[eventKey] = true
  
  print(('[ESX Seasonal Manager] ✅ Event "%s" has been ACTIVATED'):format(eventConfig.name))
  
  if Config.Notifications.enabled and Config.Notifications.announceEventStart then
    -- Notify all players
    TriggerClientEvent('chat:addMessage', -1, {
      color = {0, 255, 0},
      multiline = true,
      args = {'Seasonal Events', ('^2%s event has started!^0'):format(eventConfig.name)}
    })
  end
end

---@param eventKey string
---@param eventConfig table
local function disableEvent(eventKey, eventConfig)
  if not activeEvents[eventKey] then
    debugPrint(('Event "%s" is already inactive'):format(eventConfig.name))
    return
  end
  
  -- Set the event's config to disabled
  local resourceName = eventConfig.resource
  
  -- Trigger the event to stop via exports if available
  local success = pcall(function()
    exports[resourceName]:SetEnabled(false)
  end)
  
  if not success then
    debugPrint(('Event "%s" does not have SetEnabled export, using alternative method'):format(eventConfig.name))
  end
  
  activeEvents[eventKey] = false
  
  print(('[ESX Seasonal Manager] ⛔ Event "%s" has been DEACTIVATED'):format(eventConfig.name))
  
  if Config.Notifications.enabled and Config.Notifications.announceEventEnd then
    -- Notify all players
    TriggerClientEvent('chat:addMessage', -1, {
      color = {255, 165, 0},
      multiline = true,
      args = {'Seasonal Events', ('^3%s event has ended.^0'):format(eventConfig.name)}
    })
  end
end

---Check all events and update their status
local function checkAndUpdateEvents()
  debugPrint('Checking event schedules...')
  
  for eventKey, eventConfig in pairs(Config.EventSchedule) do
    local shouldBeActive = isEventActive(eventKey, eventConfig)
    local currentlyActive = activeEvents[eventKey] or false
    
    if shouldBeActive and not currentlyActive then
      enableEvent(eventKey, eventConfig)
    elseif not shouldBeActive and currentlyActive then
      disableEvent(eventKey, eventConfig)
    end
  end
end

-- Initialize on resource start
CreateThread(function()
  Wait(5000) -- Wait for other resources to load
  
  print('[ESX Seasonal Manager] Starting seasonal event manager...')
  print(('Auto-activation: %s'):format(Config.AutoActivate and 'ENABLED' or 'DISABLED'))
  
  -- Initial check
  checkAndUpdateEvents()
  
  -- Periodic check
  while true do
    Wait(Config.CheckInterval * 60 * 1000) -- Convert minutes to milliseconds
    checkAndUpdateEvents()
  end
end)

-- Command to manually check/update events
RegisterCommand('seasonal:check', function(source, args, rawCommand)
  if source == 0 then -- Server console only
    print('[ESX Seasonal Manager] Manual check triggered...')
    checkAndUpdateEvents()
  end
end, true)

-- Command to get status of all events
RegisterCommand('seasonal:status', function(source, args, rawCommand)
  if source == 0 then -- Server console only
    print('[ESX Seasonal Manager] Current Event Status:')
    print('-------------------------------------------')
    
    for eventKey, eventConfig in pairs(Config.EventSchedule) do
      local shouldBeActive = isEventActive(eventKey, eventConfig)
      local currentlyActive = activeEvents[eventKey] or false
      local override = Config.ManualOverrides[eventKey]
      
      local status = currentlyActive and '✅ ACTIVE' or '⛔ INACTIVE'
      local expected = shouldBeActive and '[Should be ON]' or '[Should be OFF]'
      local overrideText = override ~= nil and (' (Override: %s)'):format(tostring(override)) or ''
      
      print(('%-20s: %s %s%s'):format(eventConfig.name, status, expected, overrideText))
    end
    
    print('-------------------------------------------')
  end
end, true)

-- Command to manually enable/disable an event
RegisterCommand('seasonal:set', function(source, args, rawCommand)
  if source == 0 then -- Server console only
    if #args < 2 then
      print('Usage: seasonal:set <event> <on|off>')
      print('Events: christmas, halloween, easter, newyear, valentine, independence')
      return
    end
    
    local eventKey = args[1]:lower()
    local state = args[2]:lower()
    
    if not Config.EventSchedule[eventKey] then
      print(('Error: Unknown event "%s"'):format(eventKey))
      return
    end
    
    local eventConfig = Config.EventSchedule[eventKey]
    
    if state == 'on' or state == 'enable' or state == 'true' then
      enableEvent(eventKey, eventConfig)
    elseif state == 'off' or state == 'disable' or state == 'false' then
      disableEvent(eventKey, eventConfig)
    else
      print('Invalid state. Use: on, off, enable, disable, true, or false')
    end
  end
end, true)

-- Export functions for other resources
exports('GetActiveEvents', function()
  return activeEvents
end)

exports('IsEventActive', function(eventKey)
  return activeEvents[eventKey] or false
end)

exports('EnableEvent', function(eventKey)
  local eventConfig = Config.EventSchedule[eventKey]
  if eventConfig then
    enableEvent(eventKey, eventConfig)
    return true
  end
  return false
end)

exports('DisableEvent', function(eventKey)
  local eventConfig = Config.EventSchedule[eventKey]
  if eventConfig then
    disableEvent(eventKey, eventConfig)
    return true
  end
  return false
end)
