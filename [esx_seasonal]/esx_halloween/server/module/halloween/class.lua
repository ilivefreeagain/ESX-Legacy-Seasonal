---@module "esx_halloween.server.module.halloween.class"
---@diagnostic disable: return-type-mismatch, param-type-mismatch

---@class HalloweenTreatState
---@field coords vector3
---@field claimed boolean

---@class HalloweenActiveLocation
---@field id integer
---@field config HalloweenLocation
---@field claimCount integer
---@field maxClaims integer
---@field treats HalloweenTreatState[]

---@class HalloweenEventState
---@field locations table<integer, HalloweenActiveLocation>
---@field globalClaimCount integer
---@field perPlayerClaims table<string, integer>

---@class HalloweenAnticheatState
---@field lastClaimTime table<string, number>
---@field lastSyncTime table<string, number>
---@field violationCount table<string, integer>

---@class HalloweenEvent
---@field private _state HalloweenEventState
---@field private _ac HalloweenAnticheatState
local HalloweenEvent = {
  _state = {
    locations = {},
    globalClaimCount = 0,
    perPlayerClaims = {}
  },
  _ac = {
    lastClaimTime = {},
    lastSyncTime = {},
    violationCount = {}
  }
}

---@private
---@param message string
function HalloweenEvent:_logDebug(message)
  if not Config.Debug then
    return
  end

  print(("[ESX_Halloween] %s"):format(message))
end

---@private
---@param identifier string
function HalloweenEvent:_resetPlayerState(identifier)
  self._ac.lastClaimTime[identifier] = 0
  self._ac.lastSyncTime[identifier] = 0
  self._ac.violationCount[identifier] = 0
  self._state.perPlayerClaims[identifier] = 0
end

---@private
---@param source integer
---@param identifier string
---@param reason string
function HalloweenEvent:_registerViolation(source, identifier, reason)
  self:_logDebug(("AC violation by %d (%s): %s"):format(source, identifier, reason))

  local count = (self._ac.violationCount[identifier] or 0) + 1
  self._ac.violationCount[identifier] = count

  if Config.KickOnMaxViolations and Config.MaxViolations > 0 and count >= Config.MaxViolations then
    DropPlayer(tostring(source), "[esx_halloween] Kicked: suspicious behaviour in Halloween event.")
  end
end

---@private
---@param claimOrder integer
---@return HalloweenTier|nil
function HalloweenEvent:_getTierForClaim(claimOrder)
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
---@param rewards HalloweenTierReward[]
---@return boolean success
function HalloweenEvent:_giveRewards(playerId, rewards)
  if not rewards or #rewards == 0 then
    return true
  end

  if not ESX or not ESX.GetPlayerFromId then
    self:_logDebug("ESX or ESX.GetPlayerFromId not available, cannot give rewards")
    return false
  end

  local xPlayer = ESX.GetPlayerFromId(playerId)
  if not xPlayer then
    self:_logDebug(("xPlayer not found for id %d"):format(playerId))
    return false
  end

  -- Check if using ox_inventory
  local useOxInventory = GetResourceState('ox_inventory') == 'started'
  
  -- Pre-check inventory space for items
  if useOxInventory then
    for _, reward in ipairs(rewards) do
      if reward.Type == "item" and reward.Name then
        local canCarry = exports.ox_inventory:CanCarryItem(playerId, reward.Name, reward.Amount)
        if not canCarry then
          ---@diagnostic disable-next-line: undefined-global
          TriggerClientEvent('esx:showNotification', playerId, TranslateCap('halloween_inventory_full'))
          return false
        end
      end
    end
  end

  -- Give rewards
  for _, reward in ipairs(rewards) do
    if reward.Type == "cash" then
      if Config.Account then
        xPlayer.addAccountMoney(Config.Account, reward.Amount)
      else
        xPlayer.addMoney(reward.Amount)
      end
    elseif reward.Type == "item" and reward.Name then
      if useOxInventory then
        local success = exports.ox_inventory:AddItem(playerId, reward.Name, reward.Amount)
        if not success then
          self:_logDebug(("Failed to add item %s to player %d"):format(reward.Name, playerId))
          return false
        end
      else
        xPlayer.addInventoryItem(reward.Name, reward.Amount)
      end
    end
  end
  
  return true
end

---@private
---@param source integer
---@return string
function HalloweenEvent:_getPlayerIdentifier(source)
  ---@diagnostic disable-next-line: undefined-field
  local identifier = ESX.GetIdentifier(source)
  if identifier then
    return identifier
  end

  local identifiers = GetPlayerIdentifiers(source)
  return identifiers[1] or ("unknown:%d"):format(source)
end

---@private
function HalloweenEvent:_clearAllLocations()
  self._state.locations = {}
  self._state.globalClaimCount = 0
  self._state.perPlayerClaims = {}

  TriggerClientEvent("esx_halloween:client:clearLocations", -1)
end

---@private
---@param id integer
---@param locationConfig HalloweenLocation
---@return HalloweenActiveLocation
function HalloweenEvent:_buildActiveLocation(id, locationConfig)
  ---@type HalloweenActiveLocation
  local activeLocation = {
    id = id,
    config = locationConfig,
    claimCount = 0,
    maxClaims = 0,
    treats = {}
  }

  activeLocation.maxClaims = #locationConfig.TreatCoords

  for _, coords in ipairs(locationConfig.TreatCoords) do
    ---@type HalloweenTreatState
    local treatState = {
      coords = coords,
      claimed = false
    }
    activeLocation.treats[#activeLocation.treats + 1] = treatState
  end

  return activeLocation
end

---@private
---@return table
function HalloweenEvent:_buildPayload()
  local payload = {}

  for _, activeLocation in pairs(self._state.locations) do
    local locationConfig = activeLocation.config

    local data = {
      id = activeLocation.id,
      name = locationConfig.Name,
      landmarkCoords = locationConfig.LandmarkCoords,
      treats = {}
    }

    for index, treatState in ipairs(activeLocation.treats) do
      data.treats[#data.treats + 1] = {
        index = index,
        coords = treatState.coords,
        claimed = treatState.claimed
      }
    end

    payload[#payload + 1] = data
  end

  return payload
end

---@private
function HalloweenEvent:_broadcastLocations()
  local payload = self:_buildPayload()
  if #payload == 0 then
    return
  end

  TriggerClientEvent("esx_halloween:client:setLocations", -1, payload)
end

function HalloweenEvent:StartCycle()
  if not Config.Enabled then
    self:_logDebug("Event disabled in config (halloween_event_disabled)")
    return
  end

  if Config.DespawnLocationOnCycleEnd then
    self:_clearAllLocations()
  end

  if #Config.Locations == 0 then
    self:_logDebug("No locations configured (halloween_no_locations)")
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
  
  -- Notify all players that event started
  TriggerClientEvent("esx_halloween:client:notify", -1, 'halloween_event_started')
end

---@param source integer
---@param locationId integer
---@param treatIndex integer
function HalloweenEvent:HandleClaim(source, locationId, treatIndex)
  local activeLocation = self._state.locations[locationId]
  if not activeLocation then
    self:_logDebug(("Player %d tried to claim invalid location %s"):format(source, tostring(locationId)))
    TriggerClientEvent("esx_halloween:client:cannotClaim", source, 'halloween_location_inactive')
    return
  end

  if treatIndex < 1 or treatIndex > #activeLocation.treats then
    self:_logDebug(("Player %d sent invalid treatIndex %d"):format(source, treatIndex))
    TriggerClientEvent("esx_halloween:client:cannotClaim", source, 'halloween_treat_invalid')
    return
  end

  local treatState = activeLocation.treats[treatIndex]
  local identifier = self:_getPlayerIdentifier(source)

  if Config.MinClaimInterval and Config.MinClaimInterval > 0 then
    local now = os.time()
    local last = self._ac.lastClaimTime[identifier] or 0
    if now - last < Config.MinClaimInterval then
      self:_registerViolation(source, identifier, "claim cooldown violated")
      TriggerClientEvent("esx_halloween:client:cannotClaim", source, 'halloween_too_fast')
      return
    end
    self._ac.lastClaimTime[identifier] = now
  end

  local ped = GetPlayerPed(source)
  if ped ~= 0 and Config.MaxClaimDistance and Config.MaxClaimDistance > 0 then
    local pCoords = GetEntityCoords(ped)
    local dist = #(pCoords - treatState.coords)
    if dist > Config.MaxClaimDistance then
      self:_registerViolation(source, identifier, ("too far from treat (%.2f)"):format(dist))
      return
    end
  end

  if treatState.claimed then
    TriggerClientEvent("esx_halloween:client:treatAlreadyClaimed", source, locationId, treatIndex)
    return
  end

  if Config.GlobalMaxClaims and Config.GlobalMaxClaims > 0 then
    if self._state.globalClaimCount >= Config.GlobalMaxClaims then
      TriggerClientEvent("esx_halloween:client:cannotClaim", source, 'halloween_all_treats_claimed')
      return
    end
  end

  if Config.PerPlayerMaxClaimsPerCycle and Config.PerPlayerMaxClaimsPerCycle > 0 then
    local playerGlobalClaims = self._state.perPlayerClaims[identifier] or 0
    if playerGlobalClaims >= Config.PerPlayerMaxClaimsPerCycle then
      TriggerClientEvent("esx_halloween:client:cannotClaim", source, 'halloween_max_claims_reached')
      return
    end
  end

  if activeLocation.claimCount >= activeLocation.maxClaims then
    TriggerClientEvent("esx_halloween:client:cannotClaim", source, 'halloween_location_empty')
    return
  end

  treatState.claimed = true
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
    "esx_halloween:client:onClaim",
    -1,
    locationId,
    treatIndex,
    activeLocation.claimCount,
    activeLocation.maxClaims,
    tier and tier.Name or Config.DefaultTierName
  )

  local allClaimed = activeLocation.claimCount >= activeLocation.maxClaims

  if Config.DespawnTreatOnClaim then
    TriggerClientEvent("esx_halloween:client:despawnTreat", -1, locationId, treatIndex)
  end

  if allClaimed and Config.DespawnLocationWhenAllClaimed then
    self._state.locations[locationId] = nil
    TriggerClientEvent("esx_halloween:client:removeLocation", -1, locationId)
  end
end

function HalloweenEvent:Clear()
  self:_clearAllLocations()
end

---@param target integer
function HalloweenEvent:SyncToPlayer(target)
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

  TriggerClientEvent("esx_halloween:client:setLocations", target, payload)
end

-- Make HalloweenEvent globally available
_G.HalloweenEvent = HalloweenEvent
