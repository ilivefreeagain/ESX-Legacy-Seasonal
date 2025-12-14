---@diagnostic disable: undefined-global
-- TODO: Create client/module/newyear/class.lua from template
-- local Manager = require("esx_newyear.client.module.newyear.class")

print('[esx_newyear] Client loaded - waiting for class files to be created')
print('[esx_newyear] Copy client/module/easter/class.lua and adapt for New Year')

--[[ TODO: Uncomment when class files are created
CreateThread(function()
  while not ESX or not ESX.IsPlayerLoaded() do Wait(250) end
  TriggerServerEvent("esx_newyear:server:requestSync")
end)

RegisterNetEvent("esx_newyear:client:setLocations", function(locations)
  Manager:ClearAll()
  for _, locationData in ipairs(locations) do Manager:SpawnLocation(locationData) end
end)

RegisterNetEvent("esx_newyear:client:removeLocation", function(locationId) Manager:RemoveLocation(locationId) end)
RegisterNetEvent("esx_newyear:client:clearLocations", function() Manager:ClearAll() end)
RegisterNetEvent("esx_newyear:client:despawnGift", function(locationId, giftIndex) Manager:DespawnGift(locationId, giftIndex) end)

RegisterNetEvent("esx_newyear:client:onClaim", function(locationId, giftIndex, claimCount, maxClaims, tierName)
  ESX.ShowNotification(TranslateCap('newyear_gift_claimed', tierName or Config.DefaultTierName, claimCount, maxClaims))
end)

RegisterNetEvent("esx_newyear:client:notify", function(messageKey, ...) ESX.ShowNotification(TranslateCap(messageKey, ...)) end)
RegisterNetEvent("esx_newyear:client:giftAlreadyClaimed", function(locationId, giftIndex)
  Manager:DisableGift(locationId, giftIndex)
  ESX.ShowNotification(TranslateCap('newyear_gift_already_collected'))
end)
RegisterNetEvent("esx_newyear:client:cannotClaim", function(messageKey) ESX.ShowNotification(TranslateCap(messageKey)) end)--]]