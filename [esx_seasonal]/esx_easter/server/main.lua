-- EasterEvent is loaded from server/module/easter/class.lua
-- and made available globally

local isEnabled = true

CreateThread(function()
  if Config.EventInterval <= 0 then
    return
  end

  while true do
    Wait(Config.EventInterval * 1000)
    if Config.Enabled and isEnabled then
      EasterEvent:StartCycle()
    end
  end
end)

RegisterNetEvent("esx_easter:server:claim", function(locationId, eggIndex)
  local sourcePlayer = source
  EasterEvent:HandleClaim(sourcePlayer, locationId, eggIndex)
end)

RegisterNetEvent("esx_easter:server:requestSync", function()
  local sourcePlayer = source
  EasterEvent:SyncToPlayer(sourcePlayer)
end)

exports('SetEnabled', function(enabled)
  isEnabled = enabled
  if not enabled then
    EasterEvent:Clear()
  end
end)

exports('IsEnabled', function()
  return isEnabled and Config.Enabled
end)

exports('StartCycle', function()
  if isEnabled and Config.Enabled then
    EasterEvent:StartCycle()
  end
end)
