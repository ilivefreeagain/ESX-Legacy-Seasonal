---@module "esx_easter.client.module.easter.class"
---@diagnostic disable: undefined-global

---@class EasterClientEgg
---@field index integer
---@field coords vector3
---@field claimed boolean
---@field canClaim boolean
---@field point table|nil

---@class EasterClientLocation
---@field id integer
---@field name string
---@field landmarkCoords vector3
---@field eggs EasterClientEgg[]

---@class EasterClientManager
---@field private _locations table<integer, EasterClientLocation>
local EasterClientManager = {
  _locations = {}
}

EasterClientManager.__index = EasterClientManager

---@private
---@param message string
function EasterClientManager:_logDebug(message)
  if not Config.Debug then
    return
  end

  print(("[ESX_Easter:Client] %s"):format(message))
end

---@private
---@param locationId integer
function EasterClientManager:_clearLocation(locationId)
  local location = self._locations[locationId]
  if not location then
    return
  end

  for _, egg in ipairs(location.eggs) do
    if egg.point then
      egg.point:remove()
    end
  end

  self._locations[locationId] = nil
end

function EasterClientManager:ClearAll()
  for locationId, _ in pairs(self._locations) do
    self:_clearLocation(locationId)
  end
end

---@param locationData table
function EasterClientManager:SpawnLocation(locationData)
  local id = locationData.id

  self:_clearLocation(id)

  ---@type EasterClientLocation
  local location = {
    id = id,
    name = locationData.name,
    landmarkCoords = locationData.landmarkCoords,
    eggs = {}
  }

  for _, egg in ipairs(locationData.eggs) do
    local coords = egg.coords

    ---@type EasterClientEgg
    local eggState = {
      index = egg.index,
      coords = coords,
      claimed = egg.claimed,
      canClaim = not egg.claimed,
      point = nil
    }

    ---@type table
    local point = lib.points.new({
      coords = coords,
      distance = 5.0,
      onEnter = function() end,
      onExit = function()
        ESX.ShowHelpNotification(" ", false, false, 1)
      end,
      nearby = function(self)
        local distance = self.currentDistance or 0.0

        if eggState.claimed or not eggState.canClaim then
          return
        end

        if distance <= 2.0 then
          ESX.ShowHelpNotification(TranslateCap('easter_collect_egg_help'), true, false, 0)

          if IsControlJustReleased(0, 38) then
            eggState.canClaim = false
            TriggerServerEvent("esx_easter:server:claim", id, eggState.index)
          end
        end
      end
    })

    eggState.point = point
    location.eggs[#location.eggs + 1] = eggState
  end

  self._locations[id] = location
end

---@param locationId integer
---@param eggIndex integer
function EasterClientManager:DespawnEgg(locationId, eggIndex)
  local location = self._locations[locationId]
  if not location then
    return
  end

  for _, egg in ipairs(location.eggs) do
    if egg.index == eggIndex then
      egg.claimed = true
      egg.canClaim = false
      if egg.point then
        egg.point:remove()
        egg.point = nil
      end
      break
    end
  end
end

---@param locationId integer
function EasterClientManager:RemoveLocation(locationId)
  self:_clearLocation(locationId)
end

---@param locationId integer
---@param eggIndex integer
function EasterClientManager:DisableEgg(locationId, eggIndex)
  local location = self._locations[locationId]
  if not location then
    return
  end

  for _, egg in ipairs(location.eggs) do
    if egg.index == eggIndex then
      egg.canClaim = false
      break
    end
  end
end

-- Make EasterClientManager globally available
_G.EasterClientManager = EasterClientManager
