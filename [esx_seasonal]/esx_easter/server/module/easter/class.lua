---@module "esx_easter.server.module.easter.class"
---@diagnostic disable: return-type-mismatch, param-type-mismatch

---@class EasterEggState
---@field coords vector3
---@field claimed boolean

---@class EasterActiveLocation
---@field id integer
---@field config EasterLocation
---@field claimCount integer
---@field maxClaims integer
---@field eggs EasterEggState[]

---@class EasterEventState
---@field locations table<integer, EasterActiveLocation>
---@field globalClaimCount integer
---@field perPlayerClaims table<string, integer>

---@class EasterAnticheatState
---@field lastClaimTime table<string, number>
---@field lastSyncTime table<string, number>
---@field violationCount table<string, integer>

---@class EasterEvent
---@field private _state EasterEventState
---@field private _ac EasterAnticheatState
local EasterEvent = {
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
function EasterEvent:_logDebug(message)
  if not Config.Debug then
    return
  end

  print(("[ESX_Easter] %s"):format(message))
end

---@private
---@param source integer
---@param identifier string
---@param reason string
function EasterEvent:_registerViolation(source, identifier, reason)
  self:_logDebug(("AC violation by %d (%s): %s"):format(source, identifier, reason))

  local count = (self._ac.violationCount[identifier] or 0) + 1
  self._ac.violationCount[identifier] = count

  if Config.KickOnMaxViolations and Config.MaxViolations > 0 and count >= Config.MaxViolations then
    DropPlayer(tostring(source), "[esx_easter] Kicked: suspicious behaviour in Easter event.")
  end
end

---@private
---@param claimOrder integer
---@return EasterTier|nil
function EasterEvent:_getTierForClaim(claimOrder)
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
---@param rewards EasterTierReward[]
---@return boolean success
function EasterEvent:_giveRewards(playerId, rewards)
  if not rewards or #rewards == 0 then
    return true
  end

  local xPlayer = ESX.GetPlayerFromId(playerId)
  if not xPlayer then
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
          TriggerClientEvent('esx:showNotification', playerId, TranslateCap('easter_inventory_full'))
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
function EasterEvent:_getPlayerIdentifier(source)
  ---@diagnostic disable-next-line: undefined-field
  local identifier = ESX.GetIdentifier(source)
  if identifier then
    return identifier
  end

  local identifiers = GetPlayerIdentifiers(source)
  return identifiers[1] or ("unknown:%d"):format(source)
end

---@private
function EasterEvent:_clearAllLocations()
  self._state.locations = {}
  self._state.globalClaimCount = 0
  self._state.perPlayerClaims = {}

  TriggerClientEvent("esx_easter:client:clearLocations", -1)
end

---@private
---@param id integer
---@param locationConfig EasterLocation
---@return EasterActiveLocation
function EasterEvent:_buildActiveLocation(id, locationConfig)
  ---@type EasterActiveLocation
  local activeLocation = {
    id = id,
    config = locationConfig,
    claimCount = 0,
    maxClaims = #locationConfig.EggCoords,
    eggs = {}
  }

  for _, coords in ipairs(locationConfig.EggCoords) do
    ---@type EasterEggState
    local eggState = {
      coords = coords,
      claimed = false
    }
    activeLocation.eggs[#activeLocation.eggs + 1] = eggState
  end

  return activeLocation
end

---@private
---@return table
function EasterEvent:_buildPayload()
  local payload = {}

  for _, activeLocation in pairs(self._state.locations) do
    local locationConfig = activeLocation.config

    local data = {
      id = activeLocation.id,
      name = locationConfig.Name,
      landmarkCoords = locationConfig.LandmarkCoords,
      eggs = {}
    }

    for index, eggState in ipairs(activeLocation.eggs) do
      data.eggs[#data.eggs + 1] = {
        index = index,
        coords = eggState.coords,
        claimed = eggState.claimed
      }
    end

    payload[#payload + 1] = data
  end

  return payload
end

---@private
function EasterEvent:_broadcastLocations()
  local payload = self:_buildPayload()
  if #payload == 0 then
    return
  end

  TriggerClientEvent("esx_easter:client:setLocations", -1, payload)
end

function EasterEvent:StartCycle()
  if not Config.Enabled then
    return
  end

  if Config.DespawnLocationOnCycleEnd then
    self:_clearAllLocations()
  end

  if #Config.Locations == 0 then
    return
  end

  local chosenIndices = {}

  if Config.MaxLocationsPerCycle <= 1 or #Config.Locations == 1 then
    local chosenIndex = Config.UseRandomLocation and math.random(1, #Config.Locations) or 1
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
  end

  self:_broadcastLocations()
  TriggerClientEvent("esx_easter:client:notify", -1, 'easter_event_started')
end

---@param source integer
---@param locationId integer
---@param eggIndex integer
function EasterEvent:HandleClaim(source, locationId, eggIndex)
  local activeLocation = self._state.locations[locationId]
  if not activeLocation then
    TriggerClientEvent("esx_easter:client:cannotClaim", source, 'easter_location_inactive')
    return
  end

  if eggIndex < 1 or eggIndex > #activeLocation.eggs then
    TriggerClientEvent("esx_easter:client:cannotClaim", source, 'easter_egg_invalid')
    return
  end

  local eggState = activeLocation.eggs[eggIndex]
  local identifier = self:_getPlayerIdentifier(source)

  if Config.MinClaimInterval > 0 then
    local now = os.time()
    local last = self._ac.lastClaimTime[identifier] or 0
    if now - last < Config.MinClaimInterval then
      self:_registerViolation(source, identifier, "claim cooldown violated")
      TriggerClientEvent("esx_easter:client:cannotClaim", source, 'easter_too_fast')
      return
    end
    self._ac.lastClaimTime[identifier] = now
  end

  local ped = GetPlayerPed(source)
  if ped ~= 0 and Config.MaxClaimDistance > 0 then
    local pCoords = GetEntityCoords(ped)
    local dist = #(pCoords - eggState.coords)
    if dist > Config.MaxClaimDistance then
      self:_registerViolation(source, identifier, ("too far from egg (%.2f)"):format(dist))
      return
    end
  end

  if eggState.claimed then
    TriggerClientEvent("esx_easter:client:eggAlreadyClaimed", source, locationId, eggIndex)
    return
  end

  if Config.GlobalMaxClaims > 0 and self._state.globalClaimCount >= Config.GlobalMaxClaims then
    TriggerClientEvent("esx_easter:client:cannotClaim", source, 'easter_all_eggs_claimed')
    return
  end

  if Config.PerPlayerMaxClaimsPerCycle > 0 then
    local playerClaims = self._state.perPlayerClaims[identifier] or 0
    if playerClaims >= Config.PerPlayerMaxClaimsPerCycle then
      TriggerClientEvent("esx_easter:client:cannotClaim", source, 'easter_max_claims_reached')
      return
    end
  end

  eggState.claimed = true
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
    "esx_easter:client:onClaim",
    -1,
    locationId,
    eggIndex,
    activeLocation.claimCount,
    activeLocation.maxClaims,
    tier and tier.Name or Config.DefaultTierName
  )

  if Config.DespawnEggOnClaim then
    TriggerClientEvent("esx_easter:client:despawnEgg", -1, locationId, eggIndex)
  end

  if activeLocation.claimCount >= activeLocation.maxClaims and Config.DespawnLocationWhenAllClaimed then
    self._state.locations[locationId] = nil
    TriggerClientEvent("esx_easter:client:removeLocation", -1, locationId)
  end
end

function EasterEvent:SyncToPlayer(target)
  local identifier = self:_getPlayerIdentifier(target)

  if Config.MinClaimInterval > 0 then
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

  TriggerClientEvent("esx_easter:client:setLocations", target, payload)
end

---Public method to clear all locations (for seasonal manager)
function EasterEvent:Clear()
  self:_clearAllLocations()
  TriggerClientEvent("esx_easter:client:setLocations", -1, {})
end

-- Make EasterEvent globally available
_G.EasterEvent = EasterEvent
