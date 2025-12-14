-- HalloweenEvent is loaded from server/module/halloween/class.lua
-- and made available globally

local isEnabled = true

CreateThread(function()
  if Config.EventInterval <= 0 then
    return
  end

  while true do
    Wait(Config.EventInterval * 1000)
    if Config.Enabled and isEnabled then
      HalloweenEvent:StartCycle()
    end
  end
end)

RegisterNetEvent("esx_halloween:server:claim", function(locationId, treatIndex)
  local sourcePlayer = source
  HalloweenEvent:HandleClaim(sourcePlayer, locationId, treatIndex)
end)

RegisterNetEvent("esx_halloween:server:requestSync", function()
  local sourcePlayer = source
  HalloweenEvent:SyncToPlayer(sourcePlayer)
end)

exports('SetEnabled', function(enabled)
  isEnabled = enabled
  if not enabled then
    HalloweenEvent:Clear()
  end
end)

exports('IsEnabled', function()
  return isEnabled and Config.Enabled
end)

exports('StartCycle', function()
  if isEnabled and Config.Enabled then
    HalloweenEvent:StartCycle()
  end
end)
