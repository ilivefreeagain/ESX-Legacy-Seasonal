local ChristmasEvent = require("server.module.christmas.class")

---@type ChristmasEvent
local Event = ChristmasEvent:new()

CreateThread(function()
  if Config.EventInterval <= 0 then
    return
  end

  while true do
    Event:StartCycle()
    Wait(Config.EventInterval * 1000)
  end
end)

RegisterNetEvent("esx_christmas:server:claim", function(locationId, presentIndex)
  local sourcePlayer = source
  Event:HandleClaim(sourcePlayer, locationId, presentIndex)
end)

RegisterNetEvent("esx_christmas:server:requestSync", function()
  local sourcePlayer = source
  Event:SyncToPlayer(sourcePlayer)
end)
