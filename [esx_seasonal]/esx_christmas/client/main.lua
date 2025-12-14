---@diagnostic disable: undefined-global
-- ChristmasClientManager is loaded from client/module/christmas/class.lua
-- and made available globally

CreateThread(function()
  while not ESX or not ESX.IsPlayerLoaded() do
    Wait(250)
  end

  TriggerServerEvent("esx_christmas:server:requestSync")
end)

RegisterNetEvent("esx_christmas:client:setLocations", function(locations)
  ChristmasClientManager:ClearAll()

  for _, locationData in ipairs(locations) do
    ChristmasClientManager:SpawnLocation(locationData)
  end
end)

RegisterNetEvent("esx_christmas:client:removeLocation", function(locationId)
  ChristmasClientManager:RemoveLocation(locationId)
end)

RegisterNetEvent("esx_christmas:client:clearLocations", function()
  ChristmasClientManager:ClearAll()
end)

RegisterNetEvent("esx_christmas:client:despawnPresent", function(locationId, presentIndex)
  ChristmasClientManager:DespawnPresent(locationId, presentIndex)
end)

RegisterNetEvent("esx_christmas:client:onClaim", function(locationId, presentIndex, claimCount, maxClaims, tierName)
  local tierLabel = tierName or Config.DefaultTierName
  ESX.ShowNotification(TranslateCap('xmas_present_claimed', tierLabel, claimCount, maxClaims))
end)

RegisterNetEvent("esx_christmas:client:notify", function(messageKey, ...)
  ESX.ShowNotification(TranslateCap(messageKey, ...))
end)

RegisterNetEvent("esx_christmas:client:presentAlreadyClaimed", function(locationId, presentIndex)
  ChristmasClientManager:DisablePresent(locationId, presentIndex)
  ESX.ShowNotification(TranslateCap('xmas_present_already_opened'))
end)

RegisterNetEvent("esx_christmas:client:cannotClaim", function(messageKey)
  ESX.ShowNotification(TranslateCap(messageKey))
end)
