-- TODO: Create server/module/newyear/class.lua from template
-- local NewYearEvent = require("esx_newyear.server.module.newyear.class")

local isEnabled = true

print('[esx_newyear] Resource loaded - waiting for class files to be created')
print('[esx_newyear] Copy server/module/easter/class.lua and adapt for New Year')

--[[ TODO: Uncomment when class files are created
CreateThread(function()
  if Config.EventInterval <= 0 then return end
  while true do
    Wait(Config.EventInterval * 1000)
    if Config.Enabled and isEnabled then
      NewYearEvent:StartCycle()
    end
  end
end)

RegisterNetEvent("esx_newyear:server:claim", function(locationId, giftIndex)
  NewYearEvent:HandleClaim(source, locationId, giftIndex)
end)

RegisterNetEvent("esx_newyear:server:requestSync", function()
  NewYearEvent:SyncToPlayer(source)
end)

exports('SetEnabled', function(enabled)
  isEnabled = enabled
end)
--]]

exports('IsEnabled', function()
  return isEnabled and Config.Enabled
end)
