---@diagnostic disable: undefined-global
-- EasterClientManager is loaded from client/module/easter/class.lua
-- and made available globally

CreateThread(function()
  while not ESX or not ESX.IsPlayerLoaded() do
    Wait(250)
  end

  TriggerServerEvent("esx_easter:server:requestSync")
end)

RegisterNetEvent("esx_easter:client:setLocations", function(locations)
  EasterClientManager:ClearAll()

  for _, locationData in ipairs(locations) do
    EasterClientManager:SpawnLocation(locationData)
  end
end)

RegisterNetEvent("esx_easter:client:removeLocation", function(locationId)
  EasterClientManager:RemoveLocation(locationId)
end)

RegisterNetEvent("esx_easter:client:clearLocations", function()
  EasterClientManager:ClearAll()
end)

RegisterNetEvent("esx_easter:client:despawnEgg", function(locationId, eggIndex)
  EasterClientManager:DespawnEgg(locationId, eggIndex)
end)

RegisterNetEvent("esx_easter:client:onClaim", function(locationId, eggIndex, claimCount, maxClaims, tierName)
  local tierLabel = tierName or Config.DefaultTierName
  ESX.ShowNotification(TranslateCap('easter_egg_claimed', tierLabel, claimCount, maxClaims))
end)

RegisterNetEvent("esx_easter:client:notify", function(messageKey, ...)
  ESX.ShowNotification(TranslateCap(messageKey, ...))
end)

RegisterNetEvent("esx_easter:client:eggAlreadyClaimed", function(locationId, eggIndex)
  EasterClientManager:DisableEgg(locationId, eggIndex)
  ESX.ShowNotification(TranslateCap('easter_egg_already_collected'))
end)

RegisterNetEvent("esx_easter:client:cannotClaim", function(messageKey)
  ESX.ShowNotification(TranslateCap(messageKey))
end)
