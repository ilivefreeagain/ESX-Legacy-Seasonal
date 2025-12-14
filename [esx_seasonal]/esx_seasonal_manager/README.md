# ESX Seasonal Manager

Central management system for all ESX seasonal events with automatic date-based activation.

## Features

✅ **Automatic Event Activation** - Events start/stop based on configured date ranges  
✅ **Manual Override System** - Force enable/disable any event  
✅ **Cross-Year Support** - Handles events that span year boundaries (New Year)  
✅ **Timezone Support** - Configure your server's timezone offset  
✅ **Server Commands** - Full control via console commands  
✅ **Export Functions** - Integrate with other resources  
✅ **Player Notifications** - Announce when events start/end  

## Installation

1. Ensure all seasonal event resources are installed
2. Add to your `server.cfg`:
```cfg
# Seasonal Events
ensure esx_seasonal_manager  # MUST be first
ensure esx_christmas
ensure esx_halloween
ensure esx_easter
ensure esx_newyear
ensure esx_valentine
ensure esx_independence
```

## Configuration

Edit `config.lua` to customize:

### Date Ranges
```lua
Config.EventSchedule = {
  christmas = {
    startMonth = 12,
    startDay = 1,
    endMonth = 12,
    endDay = 31
  },
  -- Add custom date ranges for each event
}
```

### Manual Overrides
```lua
Config.ManualOverrides = {
  christmas = nil,   -- nil = auto, true = force on, false = force off
  halloween = true,  -- Force halloween to always be active
  easter = false,    -- Force easter to always be inactive
}
```

### Timezone
```lua
Config.TimezoneOffset = -5  -- EST
Config.TimezoneOffset = 0   -- UTC
Config.TimezoneOffset = 1   -- CET
```

## Server Commands

### Check Event Status
```
seasonal:status
```
Shows current status of all events

### Manual Event Check
```
seasonal:check
```
Forces immediate check of all event schedules

### Enable/Disable Event
```
seasonal:set christmas on
seasonal:set halloween off
```

Available events: `christmas`, `halloween`, `easter`, `newyear`, `valentine`, `independence`

## Export Functions

Use these in other resources:

```lua
-- Get all active events
local activeEvents = exports['esx_seasonal_manager']:GetActiveEvents()

-- Check if specific event is active
local isActive = exports['esx_seasonal_manager']:IsEventActive('christmas')

-- Manually enable an event
exports['esx_seasonal_manager']:EnableEvent('halloween')

-- Manually disable an event
exports['esx_seasonal_manager']:DisableEvent('easter')
```

## Default Schedule

| Event | Start Date | End Date |
|-------|-----------|----------|
| Christmas | Dec 1 | Dec 31 |
| Halloween | Oct 1 | Oct 31 |
| Easter | Mar 15 | Apr 30 |
| New Year | Dec 28 | Jan 5 |
| Valentine's Day | Feb 7 | Feb 14 |
| Independence Day | Jul 1 | Jul 7 |

## How It Works

1. Manager checks current date every hour (configurable)
2. Compares with configured date ranges
3. Automatically enables/disables events
4. Respects manual overrides
5. Notifies players when events change

## Advanced Usage

### Disable Auto-Activation
```lua
Config.AutoActivate = false
```
Only manual commands will control events

### Custom Check Interval
```lua
Config.CheckInterval = 30  -- Check every 30 minutes
```

### Disable Notifications
```lua
Config.Notifications = {
  enabled = false,
  announceEventStart = false,
  announceEventEnd = false
}
```

## Troubleshooting

**Events not activating:**
- Check `Config.AutoActivate = true`
- Verify date ranges in config
- Run `seasonal:status` to see current state
- Check timezone offset is correct

**Events stuck active:**
- Check manual overrides aren't forcing them on
- Run `seasonal:set <event> off` to manually disable
- Restart the resource

**Date boundary issues:**
- For events spanning years (New Year), ensure start month > end month
- Check logs for any date parsing errors

## Notes

- The manager must start BEFORE the seasonal event resources
- Events maintain their own configs - manager just enables/disables them
- Manual overrides persist until server restart
- Player notifications use in-game chat

---

**Version**: 1.0.0  
**Compatible with**: All ESX seasonal events
