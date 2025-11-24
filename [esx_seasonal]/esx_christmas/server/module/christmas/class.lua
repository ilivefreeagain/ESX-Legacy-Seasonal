---@module 'esx_christmas.server.module.christmas.class'

---@class ChristmasPresentState
---@field coords vector3
---@field claimed boolean

---@class ChristmasActiveLocation
---@field id integer
---@field config ChristmasLocation
---@field claimCount integer
---@field maxClaims integer
---@field presents ChristmasPresentState[]

---@class ChristmasEventState
---@field locations table<integer, ChristmasActiveLocation>
---@field globalClaimCount integer
---@field perPlayerClaims table<string, integer>

---@class ChristmasAnticheatState
---@field lastClaimTime table<string, number>
---@field lastSyncTime table<string, number>
---@field violationCount table<string, integer>

---@class ChristmasEvent
---@field private _state ChristmasEventState
---@field private _ac ChristmasAnticheatState
local ChristmasEvent = {}
ChristmasEvent.__index = ChristmasEvent

---@return ChristmasEvent
function ChristmasEvent:new()
  ---@type ChristmasEvent
  local instance = setmetatable({}, self)

  ---@type ChristmasEventState
  instance._state = {
    locations = {},
    globalClaimCount = 0,
    perPlayerClaims = {}
  }

  instance._ac = {
    lastClaimTime = {},
    lastSyncTime = {},
    violationCount = {}
  }

  return instance
end

---@private
---@param message string
function ChristmasEvent:_logDebug(message)
  if not Config.Debug then
    return
  end

  print(("[ESX_Christmas] %s"):format(message))
end

---@private
---@param identifier string
function ChristmasEvent:_resetPlayerState(identifier)
  self._ac.lastClaimTime[identifier] = 0
  self._ac.lastSyncTime[identifier] = 0
  self._ac.violationCount[identifier] = 0
  self._state.perPlayerClaims[identifier] = 0
end

---@private
---@param source integer
---@param identifier string
---@param reason string
function ChristmasEvent:_registerViolation(source, identifier, reason)
  self:_logDebug(("AC violation by %d (%s): %s"):format(source, identifier, reason))

  local count = (self._ac.violationCount[identifier] or 0) + 1
  self._ac.violationCount[identifier] = count

  if Config.KickOnMaxViolations and Config.MaxViolations > 0 and count >= Config.MaxViolations then
    DropPlayer(source, "[esx_christmas] Kicked: suspicious behaviour in Christmas event.")
  end
end

---@private
---@param locationConfig ChristmasLocation
---@return string|nil
function ChristmasEvent:_getLandmarkModel(locationConfig)
  if locationConfig.LandmarkModel and locationConfig.LandmarkModel ~= "" then
    return locationConfig.LandmarkModel
  end

  local models = Config.Props.LandmarkModels
  if not models or #models == 0 then
    return nil
  end

  local index = math.random(1, #models)
  return models[index]
end

---@private
---@param claimOrder integer
---@return ChristmasTier|nil
function ChristmasEvent:_getTierForClaim(claimOrder)
  if not Config.UseTierScaling then
    return nil
  end

  for _, tier in ipairs(Config.Tiers) do
    for _, order in ipairs(tier.ClaimOrder) do
      if order == claimOrder then
        return tier
      end
    end
  end

  return nil
end

---@private
---@param playerId integer
---@param rewards ChristmasTierReward[]
function ChristmasEvent:_giveRewards(playerId, rewards)
  if not rewards or #rewards == 0 then
    return
  end

  if not ESX or not ESX.GetPlayerFromId then
    self:_logDebug("ESX or ESX.GetPlayerFromId not available, cannot give rewards")
    return
  end

  local xPlayer = ESX.GetPlayerFromId(playerId)
  if not xPlayer then
    self:_logDebug(("xPlayer not found for id %d"):format(playerId))
    return
  end

  for _, reward in ipairs(rewards) do
    if reward.Type == "cash" then
      if Config.Account then
        xPlayer.addAccountMoney(Config.Account, reward.Amount)
      else
        xPlayer.addMoney(reward.Amount)
      end
    elseif reward.Type == "item" and reward.Name then
      xPlayer.addInventoryItem(reward.Name, reward.Amount)
    end
  end
end

---@private
---@param source integer
---@return string
function ChristmasEvent:_getPlayerIdentifier(source)
  ---@diagnostic disable-next-line: undefined-field
  local identifier = ESX.GetIdentifier(source)
  if identifier then
    return identifier
  end

  local identifiers = GetPlayerIdentifiers(source)
  return identifiers[1] or ("unknown:%d"):format(source)
end

---@private
function ChristmasEvent:_clearAllLocations()
  self._state.locations = {}
  self._state.globalClaimCount = 0
  self._state.perPlayerClaims = {}

  TriggerClientEvent("esx_christmas:client:clearLocations", -1)
end

---@private
---@param id integer
---@param locationConfig ChristmasLocation
---@return ChristmasActiveLocation
function ChristmasEvent:_buildActiveLocation(id, locationConfig)
  ---@type ChristmasActiveLocation
  local activeLocation = {
    id = id,
    config = locationConfig,
    claimCount = 0,
    maxClaims = 0,
    presents = {}
  }

  activeLocation.maxClaims = #locationConfig.PresentCoords

  for _, coords in ipairs(locationConfig.PresentCoords) do
    ---@type ChristmasPresentState
    local presentState = {
      coords = coords,
      claimed = false
    }
    activeLocation.presents[#activeLocation.presents + 1] = presentState
  end

  return activeLocation
end

---@private
---@return table
function ChristmasEvent:_buildPayload()
  local payload = {}

  for _, activeLocation in pairs(self._state.locations) do
    local locationConfig = activeLocation.config

    local data = {
      id = activeLocation.id,
      name = locationConfig.Name,
      landmarkCoords = locationConfig.LandmarkCoords,
      landmarkModel = self:_getLandmarkModel(locationConfig),
      presents = {},
      hintModel = locationConfig.HintModel
    }

    for index, presentState in ipairs(activeLocation.presents) do
      data.presents[#data.presents + 1] = {
        index = index,
        coords = presentState.coords,
        claimed = presentState.claimed
      }
    end

    payload[#payload + 1] = data
  end

  return payload
end

---@private
function ChristmasEvent:_broadcastLocations()
  local payload = self:_buildPayload()
  if #payload == 0 then
    return
  end

  TriggerClientEvent("esx_christmas:client:setLocations", -1, payload)
end

function ChristmasEvent:StartCycle()
  if not Config.Enabled then
    self:_logDebug("Event disabled in config (xmas_event_disabled)")
    return
  end

  if Config.DespawnLocationOnCycleEnd then
    self:_clearAllLocations()
  end

  if #Config.Locations == 0 then
    self:_logDebug("No locations configured (xmas_no_locations)")
    return
  end

  local chosenIndices = {}

  if Config.MaxLocationsPerCycle <= 1 or #Config.Locations == 1 then
    local chosenIndex = 1
    if Config.UseRandomLocation then
      chosenIndex = math.random(1, #Config.Locations)
    end
    table.insert(chosenIndices, chosenIndex)
  else
    local available = {}
    for i = 1, #Config.Locations do
      table.insert(available, i)
    end

    local toPick = math.min(Config.MaxLocationsPerCycle, #available)
    for _ = 1, toPick do
      local idx = Config.UseRandomLocation and math.random(1, #available) or 1
      table.insert(chosenIndices, available[idx])
      table.remove(available, idx)
    end
  end

  self._state.locations = {}

  for _, index in ipairs(chosenIndices) do
    local chosenConfig = Config.Locations[index]
    local activeLocation = self:_buildActiveLocation(index, chosenConfig)
    self._state.locations[activeLocation.id] = activeLocation
    self:_logDebug(("New event cycle started at location '%s'"):format(chosenConfig.Name))
  end

  self:_broadcastLocations()
end

---@param source integer
---@param locationId integer
---@param presentIndex integer
function ChristmasEvent:HandleClaim(source, locationId, presentIndex)
  local activeLocation = self._state.locations[locationId]
  if not activeLocation then
    self:_logDebug(("Player %d tried to claim invalid location %s"):format(source, tostring(locationId)))
    TriggerClientEvent("esx_christmas:client:cannotClaim", source, 'xmas_location_inactive')
    return
  end

  if presentIndex < 1 or presentIndex > #activeLocation.presents then
    self:_logDebug(("Player %d sent invalid presentIndex %d"):format(source, presentIndex))
    TriggerClientEvent("esx_christmas:client:cannotClaim", source, 'xmas_present_invalid')
    return
  end

  local presentState = activeLocation.presents[presentIndex]
  local identifier = self:_getPlayerIdentifier(source)

  if Config.MinClaimInterval and Config.MinClaimInterval > 0 then
    local now = os.time()
    local last = self._ac.lastClaimTime[identifier] or 0
    if now - last < Config.MinClaimInterval then
      self:_registerViolation(source, identifier, "claim cooldown violated")
      TriggerClientEvent("esx_christmas:client:cannotClaim", source, 'xmas_too_fast')
      return
    end
    self._ac.lastClaimTime[identifier] = now
  end

  local ped = GetPlayerPed(source)
  if ped ~= 0 and Config.MaxClaimDistance and Config.MaxClaimDistance > 0 then
    local pCoords = GetEntityCoords(ped)
    local dist = #(pCoords - presentState.coords)
    if dist > Config.MaxClaimDistance then
      self:_registerViolation(source, identifier, ("too far from present (%.2f)"):format(dist))
      return
    end
  end

  if presentState.claimed then
    TriggerClientEvent("esx_christmas:client:presentAlreadyClaimed", source, locationId, presentIndex)
    return
  end

  if Config.GlobalMaxClaims and Config.GlobalMaxClaims > 0 then
    if self._state.globalClaimCount >= Config.GlobalMaxClaims then
      TriggerClientEvent("esx_christmas:client:cannotClaim", source, 'xmas_all_presents_claimed')
      return
    end
  end

  if Config.PerPlayerMaxClaimsPerCycle and Config.PerPlayerMaxClaimsPerCycle > 0 then
    local playerGlobalClaims = self._state.perPlayerClaims[identifier] or 0
    if playerGlobalClaims >= Config.PerPlayerMaxClaimsPerCycle then
      TriggerClientEvent("esx_christmas:client:cannotClaim", source, 'xmas_max_claims_reached')
      return
    end
  end

  if activeLocation.claimCount >= activeLocation.maxClaims then
    TriggerClientEvent("esx_christmas:client:cannotClaim", source, 'xmas_location_empty')
    return
  end

  presentState.claimed = true
  activeLocation.claimCount = activeLocation.claimCount + 1
  self._state.globalClaimCount = self._state.globalClaimCount + 1
  self._state.perPlayerClaims[identifier] = (self._state.perPlayerClaims[identifier] or 0) + 1

  local tier = self:_getTierForClaim(activeLocation.claimCount)
  local rewards

  if tier then
    rewards = tier.Rewards
  else
    for _, t in ipairs(Config.Tiers) do
      if t.Name == Config.DefaultTierName then
        rewards = t.Rewards
        break
      end
    end
  end

  self:_giveRewards(source, rewards or {})

  TriggerClientEvent(
    "esx_christmas:client:onClaim",
    -1,
    locationId,
    presentIndex,
    activeLocation.claimCount,
    activeLocation.maxClaims,
    tier and tier.Name or Config.DefaultTierName
  )

  local allClaimed = activeLocation.claimCount >= activeLocation.maxClaims

  if Config.DespawnPresentOnClaim then
    TriggerClientEvent("esx_christmas:client:despawnPresent", -1, locationId, presentIndex)
  end

  if allClaimed and Config.DespawnLocationWhenAllClaimed then
    self._state.locations[locationId] = nil
    TriggerClientEvent("esx_christmas:client:removeLocation", -1, locationId)
  end
end

function ChristmasEvent:Clear()
  self:_clearAllLocations()
end

---@param target integer
function ChristmasEvent:SyncToPlayer(target)
  local identifier = self:_getPlayerIdentifier(target)

  if Config.MinClaimInterval and Config.MinClaimInterval > 0 then
    local now = os.time()
    local last = self._ac.lastSyncTime[identifier] or 0
    if now - last < Config.MinClaimInterval then
      self:_registerViolation(target, identifier, "sync spam")
      return
    end
    self._ac.lastSyncTime[identifier] = now
  end

  local payload = self:_buildPayload()
  if #payload == 0 then
    return
  end

  TriggerClientEvent("esx_christmas:client:setLocations", target, payload)
end

return ChristmasEvent
