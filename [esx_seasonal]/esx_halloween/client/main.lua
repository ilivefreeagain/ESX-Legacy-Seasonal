---@diagnostic disable: undefined-global
-- HalloweenClientManager is loaded from client/module/halloween/class.lua
-- and made available globally

CreateThread(function()
  while not ESX or not ESX.IsPlayerLoaded() do
    Wait(250)
  end

  TriggerServerEvent("esx_halloween:server:requestSync")
end)

RegisterNetEvent("esx_halloween:client:setLocations", function(locations)
  HalloweenClientManager:ClearAll()

  for _, locationData in ipairs(locations) do
    HalloweenClientManager:SpawnLocation(locationData)
  end
end)

RegisterNetEvent("esx_halloween:client:removeLocation", function(locationId)
  HalloweenClientManager:RemoveLocation(locationId)
end)

RegisterNetEvent("esx_halloween:client:clearLocations", function()
  HalloweenClientManager:ClearAll()
end)

RegisterNetEvent("esx_halloween:client:despawnTreat", function(locationId, treatIndex)
  HalloweenClientManager:DespawnTreat(locationId, treatIndex)
end)

RegisterNetEvent("esx_halloween:client:onClaim", function(locationId, treatIndex, claimCount, maxClaims, tierName)
  local tierLabel = tierName or Config.DefaultTierName
  ESX.ShowNotification(TranslateCap('halloween_treat_claimed', tierLabel, claimCount, maxClaims))
end)

RegisterNetEvent("esx_halloween:client:notify", function(messageKey, ...)
  ESX.ShowNotification(TranslateCap(messageKey, ...))
end)

RegisterNetEvent("esx_halloween:client:treatAlreadyClaimed", function(locationId, treatIndex)
  HalloweenClientManager:DisableTreat(locationId, treatIndex)
  ESX.ShowNotification(TranslateCap('halloween_treat_already_collected'))
end)

RegisterNetEvent("esx_halloween:client:cannotClaim", function(messageKey)
  ESX.ShowNotification(TranslateCap(messageKey))
end)
