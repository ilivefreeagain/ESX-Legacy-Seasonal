---@module "esx_halloween.client.module.halloween.class"
---@diagnostic disable: undefined-global

---@class HalloweenClientTreat
---@field index integer
---@field coords vector3
---@field claimed boolean
---@field canClaim boolean
---@field point table|nil

---@class HalloweenClientLocation
---@field id integer
---@field name string
---@field landmarkCoords vector3
---@field treats HalloweenClientTreat[]

---@class HalloweenClientManager
---@field private _locations table<integer, HalloweenClientLocation>
local HalloweenClientManager = {
  _locations = {}
}

HalloweenClientManager.__index = HalloweenClientManager

---@private
---@param message string
function HalloweenClientManager:_logDebug(message)
  if not Config.Debug then
    return
  end

  print(("[ESX_Halloween:Client] %s"):format(message))
end

---@private
---@param locationId integer
function HalloweenClientManager:_clearLocation(locationId)
  local location = self._locations[locationId]
  if not location then
    return
  end

  for _, treat in ipairs(location.treats) do
    if treat.point then
      treat.point:remove()
    end
  end

  self._locations[locationId] = nil
end

function HalloweenClientManager:ClearAll()
  for locationId, _ in pairs(self._locations) do
    self:_clearLocation(locationId)
  end
end

---@param locationData table
function HalloweenClientManager:SpawnLocation(locationData)
  local id = locationData.id

  self:_clearLocation(id)

  ---@type HalloweenClientLocation
  local location = {
    id = id,
    name = locationData.name,
    landmarkCoords = locationData.landmarkCoords,
    treats = {}
  }

  for _, treat in ipairs(locationData.treats) do
    local coords = treat.coords

    ---@type HalloweenClientTreat
    local treatState = {
      index = treat.index,
      coords = coords,
      claimed = treat.claimed,
      canClaim = not treat.claimed,
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

        if treatState.claimed or not treatState.canClaim then
          return
        end

        if distance <= 2.0 then
          ESX.ShowHelpNotification(TranslateCap('halloween_collect_treat_help'), true, false, 0)

          if IsControlJustReleased(0, 38) then
            treatState.canClaim = false
            TriggerServerEvent("esx_halloween:server:claim", id, treatState.index)
          end
        end
      end
    })

    treatState.point = point
    location.treats[#location.treats + 1] = treatState
  end

  self._locations[id] = location
end

---@param locationId integer
---@param treatIndex integer
function HalloweenClientManager:DespawnTreat(locationId, treatIndex)
  local location = self._locations[locationId]
  if not location then
    return
  end

  for _, treat in ipairs(location.treats) do
    if treat.index == treatIndex then
      treat.claimed = true
      treat.canClaim = false
      if treat.point then
        treat.point:remove()
        treat.point = nil
      end
      break
    end
  end
end

---@param locationId integer
function HalloweenClientManager:RemoveLocation(locationId)
  self:_clearLocation(locationId)
end

---@param locationId integer
---@param treatIndex integer
function HalloweenClientManager:DisableTreat(locationId, treatIndex)
  local location = self._locations[locationId]
  if not location then
    return
  end

  for _, treat in ipairs(location.treats) do
    if treat.index == treatIndex then
      treat.canClaim = false
      break
    end
  end
end

-- Make HalloweenClientManager globally available
_G.HalloweenClientManager = HalloweenClientManager
