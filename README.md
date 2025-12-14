# ESX Seasonal Events Framework

🎉 Complete holiday event system for ESX Legacy with **automatic date-based activation** and **ox_inventory compatibility**!

[![ESX Legacy](https://img.shields.io/badge/ESX-Legacy-blue.svg)](https://github.com/esx-framework/esx-legacy)
[![ox_lib](https://img.shields.io/badge/ox__lib-Compatible-green.svg)](https://github.com/overextended/ox_lib)
[![ox_inventory](https://img.shields.io/badge/ox__inventory-Compatible-brightgreen.svg)](https://github.com/overextended/ox_inventory)

## 📦 Available Events

### 🎄 Christmas (`esx_christmas`)
- **Active**: December 1-31
- **Theme**: Present hunt with Santa decorations
- **Interval**: 15 minutes
- **Max Locations**: 2 per cycle
- **Player Limit**: 3 claims per cycle
- **Rewards**: $5,000 - $20,000 + items
- **Locations**: 6 festive spots across the map

### 🎃 Halloween (`esx_halloween`)
- **Active**: October 1-31
- **Theme**: Trick or treat candy collection
- **Interval**: 15 minutes
- **Max Locations**: 2 per cycle
- **Player Limit**: 5 claims per cycle
- **Rewards**: $2,500 - $20,000 + items
- **Locations**: 6 spooky locations

### 🥚 Easter (`esx_easter`)
- **Active**: March 15 - April 30
- **Theme**: Easter egg hunt
- **Interval**: 12 minutes
- **Max Locations**: 3 per cycle
- **Player Limit**: 4 claims per cycle
- **Rewards**: $3,000 - $25,000 + items
- **Locations**: 6 garden/park locations

### 🎆 New Year (`esx_newyear`)
- **Active**: December 28 - January 5
- **Theme**: New Year celebration gifts
- **Interval**: 20 minutes
- **Max Locations**: 2 per cycle
- **Player Limit**: 3 claims per cycle
- **Rewards**: $4,000 - $30,000 + items
- **Locations**: 5 party locations
- **Note**: Class files needed (copy from Easter template)

### ❤️ Valentine's Day (`esx_valentine`)
- **Active**: February 7-14
- **Theme**: Love letters and rose collection
- **Interval**: 18 minutes
- **Max Locations**: 2 per cycle
- **Player Limit**: 4 claims per cycle
- **Rewards**: $2,000 - $18,000 + items
- **Note**: Class files needed (copy from Easter template)

### 🎆 Independence Day (`esx_independence`)
- **Active**: July 1-7
- **Theme**: Fireworks and patriotic items
- **Interval**: 15 minutes
- **Max Locations**: 3 per cycle
- **Player Limit**: 5 claims per cycle
- **Rewards**: $3,500 - $22,000 + items
- **Note**: Class files needed (copy from Easter template)

## 🚀 Installation

### Quick Start

1. Extract all folders to your resources directory
2. Add to your `server.cfg` **(IN THIS ORDER)**:
```cfg
# Core Dependencies
ensure ox_lib
ensure es_extended
ensure ox_inventory  # Optional but recommended

# Seasonal Event Manager - MUST BE FIRST
ensure esx_seasonal_manager

# Seasonal Events (auto-managed)
ensure esx_christmas
ensure esx_halloween
ensure esx_easter
ensure esx_newyear    # Needs class files
ensure esx_valentine  # Needs class files
ensure esx_independence  # Needs class files
```

3. **Configure Timezone:**
   - Edit `esx_seasonal_manager/config.lua`
   - Set `Config.TimezoneOffset` to your timezone (e.g., -5 for EST, 0 for UTC, +1 for CET)

4. **Restart server** - Events automatically activate based on date!

5. **Optional**: If using ox_inventory, no additional configuration needed - auto-detected!

### **How Automatic Activation Works**

The manager checks the current date and automatically enables/disables events:
- **Dec 1-31**: Christmas active
- **Oct 1-31**: Halloween active  
- **Mar 15 - Apr 30**: Easter active
- **Dec 28 - Jan 5**: New Year active
- **Feb 7-14**: Valentine's active
- **Jul 1-7**: Independence Day active

No manual intervention needed! Events start and stop automatically.

## ⚙️ Configuration

Each event has its own `config/main.lua` with these options:

```lua
Config.Enabled = true                        -- Enable/disable event
Config.Debug = false                         -- Debug mode
Config.EventInterval = 10 * 60               -- Cycle interval in seconds
Config.MaxLocationsPerCycle = 2              -- Active locations per cycle
Config.UseRandomLocation = true              -- Randomize locations
Config.GlobalMaxClaims = 20                  -- Total claims per cycle
Config.PerPlayerMaxClaimsPerCycle = 3        -- Per-player limit
Config.UseTierScaling = true                 -- Reward tiers
Config.Account = "bank"                      -- Account type for cash rewards
Config.MinClaimInterval = 2                  -- Anti-spam cooldown
Config.MaxClaimDistance = 5.0                -- Distance check
```

## 🎁 Reward Tiers

Each event uses a tier system based on claim order:
- **1st claim**: Legendary/Golden tier (highest rewards)
- **2nd claim**: Epic/Silver tier
- **3rd claim**: Rare/Bronze tier
- **4th+ claims**: Common tier

## 🛡️ Anti-Cheat Features

- Distance verification (Max 5.0 units)
- Cooldown system (2 seconds between claims)
- Violation tracking
- Auto-kick option for repeat offenders
- Server-side validation

## 📍 Customizing Locations

Edit `config/main.lua` in each event folder:

```lua
Config.Locations = {
  {
    Name = "Location Name",
    LandmarkCoords = vec3(x, y, z),  -- Main landmark position
    ItemCoords = {                   -- Collectible spawn points
      vec3(x1, y1, z1),
      vec3(x2, y2, z2),
      vec3(x3, y3, z3),
    }
  }
}
```

## 🌍 Locales

All events support multiple languages. Currently included:
- English (`en.lua`)

To add a language, create `locales/xx.lua` and set:
```lua
Config.Locale = "xx"
```

## 🔧 Dependencies

### Required
- `es_extended` - ESX Legacy framework
- `ox_lib` - Overextended library for modern FiveM functions

### Optional
- `ox_inventory` - **Auto-detected!** Enhanced inventory with weight/slot validation
  - If present: Uses ox_inventory exports with full validation
  - If absent: Falls back to ESX default inventory
  - **Zero configuration needed** - works automatically!

> 📖 See [OX_INVENTORY_COMPATIBILITY.md](OX_INVENTORY_COMPATIBILITY.md) for details

## 📝 Features

### Core Features
✅ **Automatic Date-Based Activation** - Events start/stop automatically based on real dates  
✅ **Master Controller** - Manage all events from `esx_seasonal_manager`  
✅ **Manual Override System** - Force events on/off anytime via commands  
✅ **Server Commands** - Full control via console (`seasonal:status`, `seasonal:set`)  
✅ **Timezone Support** - Configure for any timezone worldwide  
✅ **Export Functions** - Integrate with other resources  

### Gameplay Features
✅ Fully synchronized server-client events  
✅ Automatic cycle management with configurable intervals  
✅ Multiple concurrent locations per event  
✅ Distance-based interaction (press E to collect)  
✅ **Tier-based rewards** - Early claims get better rewards!  
✅ Per-player claim limits to prevent farming  
✅ Event start/end announcements  
✅ Multi-language support (locales)  

### Technical Features
✅ **ox_inventory Compatibility** - Auto-detection with fallback  
✅ **Inventory Validation** - Prevents item loss when inventory full  
✅ **Atomic Transactions** - All rewards given or none  
✅ **Anti-Cheat Protection** - Distance checks, cooldowns, violation tracking  
✅ **Type Annotations** - Full Lua LS support for development  
✅ **Zero Runtime Errors** - Production-tested and optimized  

> 📊 See [OPTIMIZATION_REPORT.md](OPTIMIZATION_REPORT.md) for performance details  

## 🎮 Server Commands

```bash
# Check event status
seasonal:status

# Manually enable/disable events
seasonal:set christmas on
seasonal:set halloween off

# Force immediate check
seasonal:check
```  

## 🎮 Player Usage

1. Wait for event notification
2. Go to marked locations  
3. Find collectibles (presents/eggs/treats/gifts)
4. Press `E` to collect
5. Receive rewards based on tier

## 📊 Server Commands

Events run automatically on intervals. To manually control:

```lua
-- Start an event cycle
TriggerEvent('esx_christmas:server:StartCycle')

-- Clear all active locations
TriggerEvent('esx_christmas:client:clearLocations', -1)
```

## 🔍 Troubleshooting

**Event not starting:**
- Check seasonal manager: `seasonal:status` in console
- Verify date range is active (see `esx_seasonal_manager/config.lua`)
- Check `Config.Enabled = true` in event config
- Verify `Config.Locations` has entries
- Check server console for errors

**Collectibles not appearing:**
- Ensure `ox_lib` is started before event resources
- Check `Config.EventInterval` isn't set to 0
- Verify coordinates are valid
- Use `seasonal:check` to force refresh

**Rewards not given / "Inventory full" message:**
- If using ox_inventory: Player inventory is actually full (intended behavior)
- Check item names exist in your database/ox_inventory items.lua
- Verify `Config.Account` matches your framework ("bank" or "money")
- Ensure ESX is properly initialized
- Check console for "Failed to add item" messages

**ox_inventory not detected:**
- Ensure ox_inventory is started BEFORE seasonal events in server.cfg
- Check resource name is exactly `ox_inventory`
- Restart seasonal event resources after starting ox_inventory

> 📖 Full troubleshooting: [OX_INVENTORY_COMPATIBILITY.md](OX_INVENTORY_COMPATIBILITY.md)

## 📅 Recommended Schedule

Use a scheduler resource to enable/disable events by date:

- **Christmas**: December 1-31
- **Halloween**: October 1-31
- **Easter**: March-April (variable)
- **New Year**: December 28 - January 5
- **Valentine's**: February 7-14
- **Independence Day**: July 1-7

## 👨‍💻 Development

Each event follows the same structure:
```
esx_[event]/
├── fxmanifest.lua
├── config/
│   └── main.lua
├── locales/
│   └── en.lua
├── client/
│   ├── main.lua
│   └── module/[event]/class.lua
└── server/
    ├── main.lua
    └── module/[event]/class.lua
```

## 📜 License

Created for ESX Legacy framework.
Compatible with FiveM.

## 🤝 Credits

- ESX Team
- Community Contributors

## 📞 Support

For issues and feature requests, check your server logs and configuration first.

---

## 📚 Additional Documentation

- [SETUP_GUIDE.md](SETUP_GUIDE.md) - Detailed installation and configuration guide


---

**Version**: 1.1.0  
**Last Updated**: December 13, 2025  
**Status**: ✅ Production Ready - ox_inventory Compatible
