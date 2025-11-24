local ChristmasClientManager = require("client.module.christmas.class")

---@type ChristmasClientManager
local Manager = ChristmasClientManager:new()

CreateThread(function()
  while not ESX or not ESX.IsPlayerLoaded() do
    Wait(250)
  end

  TriggerServerEvent("esx_christmas:server:requestSync")
end)

RegisterNetEvent("esx_christmas:client:setLocations", function(locations)
  Manager:ClearAll()

  for _, locationData in ipairs(locations) do
    Manager:SpawnLocation(locationData)
  end
end)

RegisterNetEvent("esx_christmas:client:removeLocation", function(locationId)
  Manager:RemoveLocation(locationId)
end)

RegisterNetEvent("esx_christmas:client:clearLocations", function()
  Manager:ClearAll()
end)

RegisterNetEvent("esx_christmas:client:despawnPresent", function(locationId, presentIndex)
  Manager:DespawnPresent(locationId, presentIndex)
end)

RegisterNetEvent("esx_christmas:client:onClaim", function(locationId, presentIndex, claimCount, maxClaims, tierName)
  local tierLabel = tierName or Config.DefaultTierName
  ESX.ShowNotification(TranslateCap('xmas_present_claimed', tierLabel, claimCount, maxClaims))
end)

RegisterNetEvent("esx_christmas:client:notify", function(messageKey, ...)
  ESX.ShowNotification(TranslateCap(messageKey, ...))
end)

RegisterNetEvent("esx_christmas:client:presentAlreadyClaimed", function(locationId, presentIndex)
  Manager:DisablePresent(locationId, presentIndex)
  ESX.ShowNotification(TranslateCap('xmas_present_already_opened'))
end)

RegisterNetEvent("esx_christmas:client:cannotClaim", function(messageKey)
  ESX.ShowNotification(TranslateCap(messageKey))
end)
