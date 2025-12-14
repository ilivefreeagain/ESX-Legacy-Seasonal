---@module "esx_christmas.client.module.christmas.class"
---@diagnostic disable: undefined-global

---@class EsxPoint
---@field currDistance number
---@field delete fun(self: EsxPoint)
---@field toggle fun(self: EsxPoint, hidden: boolean)

---@class ChristmasClientPresent
---@field index integer
---@field coords vector3
---@field claimed boolean
---@field canClaim boolean
---@field entity integer|nil
---@field point EsxPoint|nil

---@class ChristmasClientLocation
---@field id integer
---@field name string
---@field landmarkCoords vector3
---@field landmarkModel string|nil
---@field landmarkEntity integer|nil
---@field presents ChristmasClientPresent[]
---@field hintModel string|nil
---@field hintEntity integer|nil
---@field hintTextKey string|nil

---@class ChristmasClientManager
---@field private _locations table<integer, ChristmasClientLocation>
local ChristmasClientManager = {
  _locations = {}
}

ChristmasClientManager.__index = ChristmasClientManager

---@private
---@param message string
function ChristmasClientManager:_logDebug(message)
  if not Config.Debug then
    return
  end

  print(("[ESX_Christmas:Client] %s"):format(message))
end

---@private
---@param entity integer|nil
local function safeDeleteEntity(entity)
  if entity and entity ~= 0 and DoesEntityExist(entity) then
    DeleteEntity(entity)
  end
end

---@private
---@return string|nil
local function getRandomPresentModel()
  local models = Config.Props.PresentModels
  if not models or #models == 0 then
    return nil
  end

  local index = math.random(1, #models)
  return models[index]
end

---@private
---@param locationId integer
function ChristmasClientManager:_clearLocation(locationId)
  local location = self._locations[locationId]
  if not location then
    return
  end

  safeDeleteEntity(location.landmarkEntity)
  safeDeleteEntity(location.hintEntity)

  for _, present in ipairs(location.presents) do
    safeDeleteEntity(present.entity)
    if present.point then
      present.point:delete()
    end
  end

  self._locations[locationId] = nil
end

function ChristmasClientManager:ClearAll()
  for locationId, _ in pairs(self._locations) do
    self:_clearLocation(locationId)
  end
end

---@param locationData table
function ChristmasClientManager:SpawnLocation(locationData)
  local id = locationData.id

  self:_clearLocation(id)

  ---@type ChristmasClientLocation
  local location = {
    id = id,
    name = locationData.name,
    landmarkCoords = locationData.landmarkCoords,
    landmarkModel = locationData.landmarkModel,
    landmarkEntity = nil,
    presents = {},
    hintModel = locationData.hintModel,
    hintEntity = nil,
    hintTextKey = nil
  }

  if location.hintModel then
    location.hintTextKey = Config.Hints[location.hintModel]
  end

  if location.landmarkCoords and location.landmarkModel and location.landmarkModel ~= "" then
    local modelHash = GetHashKey(location.landmarkModel)

    lib.requestModel(modelHash, 5000)

    local coords = location.landmarkCoords
    local entity = CreateObject(modelHash, coords.x, coords.y, coords.z, false, false, false)
    FreezeEntityPosition(entity, true)
    location.landmarkEntity = entity

    SetModelAsNoLongerNeeded(modelHash)
  end

  if Config.UseHints and location.hintModel and location.landmarkCoords then
    local hintModelHash = GetHashKey(location.hintModel)

    lib.requestModel(hintModelHash, 5000)

    local coords = location.landmarkCoords
    local hintEntity = CreateObject(hintModelHash, coords.x + 2.0, coords.y, coords.z, false, false, false)
    FreezeEntityPosition(hintEntity, true)
    location.hintEntity = hintEntity

    SetModelAsNoLongerNeeded(hintModelHash)

    if location.hintTextKey then
      local hintCoords = vector3(coords.x + 2.0, coords.y, coords.z + 1.0)

      lib.points.new({
        coords = hintCoords,
        distance = 10.0,
        onEnter = function() end,
        onExit = function() end,
        nearby = function(self)
          local distance = self.currentDistance or 0.0
          if distance <= 5.0 then
            ESX.ShowFloatingHelpNotification(TranslateCap(location.hintTextKey), hintCoords)
          end
        end
      })
    end
  end

  for _, present in ipairs(locationData.presents) do
    local coords = present.coords

    local modelName = getRandomPresentModel()
    local modelHash = modelName and GetHashKey(modelName) or 0
    local entity = 0

    if modelHash ~= 0 then
      lib.requestModel(modelHash, 5000)
      
      entity = CreateObject(modelHash, coords.x, coords.y, coords.z, false, false, false)
      FreezeEntityPosition(entity, true)
      SetModelAsNoLongerNeeded(modelHash)
    end

    ---@type ChristmasClientPresent
    local presentState = {
      index = present.index,
      coords = coords,
      claimed = present.claimed,
      canClaim = not present.claimed,
      entity = entity,
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

        if presentState.claimed or not presentState.canClaim then
          return
        end

        if distance <= 2.0 then
          ESX.ShowHelpNotification(TranslateCap('xmas_open_present_help'), true, false, 0)

          if IsControlJustReleased(0, 38) then
            presentState.canClaim = false
            TriggerServerEvent("esx_christmas:server:claim", id, presentState.index)
          end
        end
      end
    })

    presentState.point = point
    location.presents[#location.presents + 1] = presentState
  end

  self._locations[id] = location
end

---@param locationId integer
---@param presentIndex integer
function ChristmasClientManager:DespawnPresent(locationId, presentIndex)
  local location = self._locations[locationId]
  if not location then
    return
  end

  for _, present in ipairs(location.presents) do
    if present.index == presentIndex then
      present.claimed = true
      present.canClaim = false
      if present.point then
        present.point:delete()
        present.point = nil
      end
      safeDeleteEntity(present.entity)
      present.entity = nil
      break
    end
  end
end

---@param locationId integer
function ChristmasClientManager:RemoveLocation(locationId)
  self:_clearLocation(locationId)
end

---@param locationId integer
---@param presentIndex integer
function ChristmasClientManager:DisablePresent(locationId, presentIndex)
  local location = self._locations[locationId]
  if not location then
    return
  end

  for _, present in ipairs(location.presents) do
    if present.index == presentIndex then
      present.canClaim = false
      break
    end
  end
end

-- Make ChristmasClientManager globally available
_G.ChristmasClientManager = ChristmasClientManager
