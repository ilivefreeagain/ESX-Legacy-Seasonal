# ESX Seasonal Events - Complete Setup Guide

## Overview

This guide covers installation, configuration, and customization of the ESX Seasonal Events framework with **automatic date-based activation** and **ox_inventory compatibility**.

## ✅ Completed Resources

**Production Ready (Fully Functional):**

1. **esx_christmas** - Christmas Present Hunt (15 min cycles) ✅ **WORKING**
2. **esx_halloween** - Halloween Trick or Treat (15 min cycles) ✅ **WORKING**
3. **esx_easter** - Easter Egg Hunt (12 min cycles) ✅ **WORKING**

**Partial (Configuration Only - Safe to Load):**

4. **esx_newyear** - New Year Celebration (20 min cycles) ⚠️ **Needs class files** (Code commented out)
5. **esx_valentine** - Valentine's Love Letters (18 min cycles) ⚠️ **Needs class files** (Code commented out)
6. **esx_independence** - Independence Day Fireworks (15 min cycles) ⚠️ **Needs class files** (Code commented out)

> **Note:** Incomplete events are safe to load - they print helpful messages and won't cause errors.

## 📁 File Structure Status

**NEW: Seasonal Manager + ox_inventory Support!**
- ✅ `esx_seasonal_manager/` - Master controller with auto-activation
- ✅ **ox_inventory compatibility** - Auto-detected, zero configuration
- ✅ **Global variable loading** - Uses traditional FiveM script loading (not ox_lib require)

**Working Events (Christmas, Halloween, Easter):**
- ✅ `fxmanifest.lua` - Uses `client_scripts` and `server_scripts` for class loading
- ✅ `config/main.lua` - Full configuration with locations, tiers, and settings
- ✅ `locales/en.lua` - English translations (emojis replaced with text prefixes)
- ✅ `client/main.lua` - Event handlers using global class references
- ✅ `client/module/[event]/class.lua` - Client manager class (global variable)
- ✅ `server/main.lua` - Server handlers with ox_inventory integration
- ✅ `server/module/[event]/class.lua` - Server event class (global variable)

**Incomplete Events (New Year, Valentine, Independence):**
- ✅ `fxmanifest.lua` - Safe configuration (no missing file references)
- ✅ `config/main.lua` - Complete configuration ready to use
- ✅ `locales/en.lua` - Complete translations
- ✅ `client/main.lua` - Template code commented out with TODO notes
- ✅ `server/main.lua` - Template code commented out with TODO notes
- ⚠️ `client/module/[event]/class.lua` - **TO BE CREATED** (copy from Easter)
- ⚠️ `server/module/[event]/class.lua` - **TO BE CREATED** (copy from Easter)

### Missing Class Files (Use Christmas/Easter/Halloween as Templates)

The following class files need to be created by copying and adapting from existing events:

**For New Year:**
- `client/module/newyear/class.lua` - Copy from `esx_easter/client/module/easter/class.lua`, replace "egg" with "gift"
- `server/module/newyear/class.lua` - Copy from `esx_easter/server/module/easter/class.lua`, replace "egg" with "gift"

**For Valentine:**
- `client/module/valentine/class.lua` - Copy from `esx_easter/client/module/easter/class.lua`, replace "egg" with "letter"
- `server/module/valentine/class.lua` - Copy from `esx_easter/server/module/easter/class.lua`, replace "egg" with "letter"

**For Independence:**
- `client/module/independence/class.lua` - Copy from `esx_easter/client/module/easter/class.lua`, replace "egg" with "firework"
- `server/module/independence/class.lua` - Copy from `esx_easter/server/module/easter/class.lua`, replace "egg" with "firework"

## 🔄 Quick Template Adaptation Guide

### Important: Global Variable Pattern

All class files use **global variables** (not require/exports). The pattern is:

**Server Class:**
```lua
-- At the end of server/module/[event]/class.lua:
_G.[Event]Event = [Event]Event  -- e.g., _G.NewYearEvent = NewYearEvent
```

**Client Class:**
```lua
-- At the end of client/module/[event]/class.lua:
_G.[Event]ClientManager = [Event]ClientManager  -- e.g., _G.NewYearClientManager = NewYearClientManager
```

**Main Files Reference:**
```lua
-- In server/main.lua and client/main.lua, use the global directly:
NewYearEvent:StartCycle()  -- Not: local Event = require(...)
NewYearClientManager:SpawnLocation(...)  -- Not: local Manager = require(...)
```

### Client Class Template Replacements:
```lua
-- Copy esx_easter/client/module/easter/class.lua
-- Find and replace:
"esx_easter" → "esx_[event]"
"Easter" → "[Event]"  (NewYear/Valentine/Independence)
"easter" → "[event]"  (newyear/valentine/independence)
"Egg" → "[Item]"  (Gift/Letter/Firework)
"egg" → "[item]"  (gift/letter/firework)

-- At the end, change:
return EasterClientManager
-- To:
_G.[Event]ClientManager = [Event]ClientManager
```

### Server Class Template Replacements:
```lua
-- Copy esx_easter/server/module/easter/class.lua
-- Find and replace:
"esx_easter" → "esx_[event]"
"Easter" → "[Event]"
"easter" → "[event]"
"Egg" → "[Item]"  (Gift/Letter/Firework)
"egg" → "[item]"  (gift/letter/firework)
"EggCoords" → "[Item]Coords"  (GiftCoords/LetterCoords/FireworkCoords)

-- At the end, change:
return EasterEvent
-- To:
_G.[Event]Event = [Event]Event
```

### After Creating Class Files:

1. **Uncomment main.lua files** - Remove the `--[[` and `--]]` comment blocks
2. **Update fxmanifest.lua** - Uncomment the `client_scripts` and `server_scripts` sections
3. **Test the event** - Restart the resource and verify it works

## 🚀 Quick Start Installation

### Step 1: Install Dependencies

**Required:**
```cfg
ensure ox_lib
ensure es_extended
```

**Optional (Recommended):**
```cfg
ensure ox_inventory  # Enhanced inventory with weight/slot validation
```

### Step 2: Install Seasonal Events

1. Extract all `esx_*` folders to your resources directory

2. **Add to server.cfg in this EXACT order:**
```cfg
# Core Dependencies
ensure ox_lib
ensure es_extended
ensure ox_inventory  # Optional - auto-detected if present

# Seasonal Event Manager (MUST BE FIRST)
ensure esx_seasonal_manager

# Seasonal Events - WORKING (Ready for Production)
ensure esx_christmas
ensure esx_halloween
ensure esx_easter

# Seasonal Events - INCOMPLETE (Safe to load, won't run until class files created)
ensure esx_newyear      # Will print TODO message
ensure esx_valentine    # Will print TODO message  
ensure esx_independence # Will print TODO message
```

⚠️ **IMPORTANT:** 
- `esx_seasonal_manager` MUST start before individual events!
- Incomplete events are safe to load - they just print helpful messages
- You can comment out incomplete events if you prefer

### Step 3: Configure Timezone

Edit `esx_seasonal_manager/config.lua`:

```lua
-- Set your server timezone offset from UTC
Config.TimezoneOffset = -5  -- Examples:
                            -- -5 = EST (New York)
                            -- -8 = PST (Los Angeles)
                            -- 0 = UTC (London)
                            -- +1 = CET (Paris)
                            -- +8 = CST (Beijing)
```

### Step 4: Restart Server

```bash
restart esx_seasonal_manager
restart esx_christmas
restart esx_halloween
restart esx_easter
```

Events will now automatically activate based on the current date!

### Step 5: Verify Installation

In server console:
```bash
seasonal:status
```

You should see:
```
[Seasonal Manager] Christmas: Active (Dec 1-31)  # If currently December
[Seasonal Manager] Halloween: Inactive
[Seasonal Manager] Easter: Inactive
# etc.
```

---

## 🎯 ox_inventory Integration

### Automatic Detection

The system automatically detects ox_inventory:
- ✅ **If ox_inventory is running:** Uses exports for inventory validation
- ✅ **If ox_inventory is NOT running:** Falls back to ESX default inventory
- ✅ **Zero configuration needed!**

### Features When Using ox_inventory

1. **Pre-Validation:** Checks if player can carry items BEFORE giving rewards
2. **Weight Checking:** Respects ox_inventory weight limits
3. **Slot Checking:** Respects ox_inventory slot limits
4. **User Feedback:** Shows "Your inventory is full!" notification
5. **Prevents Item Loss:** Won't give rewards if inventory can't hold them

### Testing ox_inventory Detection

```lua
-- In server console
GetResourceState('ox_inventory')  -- Should return 'started'
```

If it returns `'started'`, all seasonal events will use ox_inventory automatically!

### Troubleshooting ox_inventory

**Issue:** "Inventory full" showing when it's not
- Check ox_inventory weight configuration
- Verify item weights in `ox_inventory/data/items.lua`

**Issue:** Items not being added  
- Ensure ox_inventory starts BEFORE seasonal events
- Check item names match ox_inventory items.lua

**Issue:** Console errors about exports
- Verify resource start order (ox_inventory → seasonal events)

> 📖 **Detailed Guide:** See [OX_INVENTORY_COMPATIBILITY.md](OX_INVENTORY_COMPATIBILITY.md)

---

## 🎛️ Seasonal Manager Control

### Server Commands

### Server Commands

```bash
# Check which events are currently active
seasonal:status

# Manually enable an event
seasonal:set christmas on

# Manually disable an event
seasonal:set halloween off

# Force check all events
seasonal:check
```

### **Manual Control (Optional)**

If you prefer manual control instead of automatic:

1. Edit `esx_seasonal_manager/config.lua`:
```lua
Config.AutoActivate = false  -- Disable automatic activation

-- Or use manual overrides
Config.ManualOverrides = {
  christmas = true,   -- Force always on
  halloween = false,  -- Force always off
  easter = nil,       -- Use auto (date-based)
}
```

## ⚙️ Configuration Examples

### Seasonal Manager Configuration
```lua
-- Enable automatic activation based on dates
Config.AutoActivate = true

-- Set your server timezone
Config.TimezoneOffset = -5  -- EST (-5), PST (-8), UTC (0), CET (+1)

-- Check events every hour
Config.CheckInterval = 60

-- Manual overrides (optional)
Config.ManualOverrides = {
  christmas = nil,      -- nil = auto based on dates
  halloween = true,     -- force always on
  easter = false,       -- force always off
}
```

### Enable Only Active Season:
```lua
-- esx_christmas/config/main.lua (December only)
Config.Enabled = true

-- esx_halloween/config/main.lua (October only)
Config.Enabled = false

-- etc.
```

### Adjust Rewards:
```lua
Config.Tiers = {
  {
    Name = "Legendary",
    ClaimOrder = { 1 },
    Rewards = {
      { Type = "cash", Amount = 15000 },  -- Adjust amount
      { Type = "item", Name = "bread", Amount = 5 },
      { Type = "item", Name = "water", Amount = 5 }
    }
  }
}
```

### Add Custom Locations:
```lua
Config.Locations = {
  {
    Name = "Your Custom Location",
    LandmarkCoords = vec3(x, y, z),
    [Item]Coords = {  -- PresentCoords, EggCoords, etc.
      vec3(x1, y1, z1),
      vec3(x2, y2, z2),
      vec3(x3, y3, z3),
    }
  }
}
```

### Automatic Scheduling (Default)

The seasonal manager automatically activates events on these dates:

| Event | Active Period | Auto-Start | Auto-End |
|-------|--------------|------------|----------|
| Christmas | Dec 1 - Dec 31 | Dec 1 00:00 | Dec 31 23:59 |
| Halloween | Oct 1 - Oct 31 | Oct 1 00:00 | Oct 31 23:59 |
| Easter | Mar 15 - Apr 30 | Mar 15 00:00 | Apr 30 23:59 |
| New Year | Dec 28 - Jan 5 | Dec 28 00:00 | Jan 5 23:59 |
| Valentine | Feb 7 - Feb 14 | Feb 7 00:00 | Feb 14 23:59 |
| Independence | July 1 - July 7 | July 1 00:00 | July 7 23:59 |

**Note:** All times respect your configured timezone offset in `esx_seasonal_manager/config.lua`

### Manual Scheduling

To manually control when events run, use server commands or manual overrides in the manager config.

---

## 🛠️ Customization Tips

## 🛠️ Customization Tips

### Change Claim Limits:
```lua
Config.GlobalMaxClaims = 30  -- Total claims per cycle
Config.PerPlayerMaxClaimsPerCycle = 5  -- Per player limit
```

### Adjust Anti-Cheat:
```lua
Config.MinClaimInterval = 2  -- Seconds between claims
Config.MaxClaimDistance = 5.0  -- Max distance in units
Config.MaxViolations = 5  -- Violations before kick
Config.KickOnMaxViolations = true  -- Auto-kick cheaters
```

### Multiple Locations:
```lua
Config.MaxLocationsPerCycle = 3  -- Active locations at once
Config.UseRandomLocation = true  -- Randomize which locations
```

## 📊 Reward Tier System

Each event uses a 4-tier reward system:

**Tier 1 (1st claim):** Highest rewards (15k-30k cash + items)  
**Tier 2 (2nd claim):** High rewards (7.5k-15k cash + items)  
**Tier 3 (3rd claim):** Medium rewards (3k-8k cash + items)  
**Tier 4 (4th+ claims):** Base rewards (1.5k-4k cash only)

## 🎮 Player Commands

No commands needed - events run automatically!

Players simply:
1. Get notification when event starts
2. Go to locations
3. Press `E` to collect items
4. Receive rewards

## 🔍 Troubleshooting

### Common Issues

**"Undefined global lib":**
- Ensure `@ox_lib/init.lua` is in shared_scripts
- Verify ox_lib is started before events
- Check fxmanifest.lua has correct shared_scripts

**"Undefined global TranslateCap":**
- ✅ Already fixed with diagnostic suppressions
- Ensure `@es_extended/locale.lua` is loaded in shared_scripts

**Events not spawning:**
- Check `seasonal:status` to see if event is active
- Verify current date is within event date range
- Check `Config.Enabled = true` in event config
- Verify `Config.Locations` has entries
- Check `Config.EventInterval > 0`
- Use `seasonal:check` to force refresh

**Items not given:**
- If using ox_inventory: Check `ox_inventory/data/items.lua` for item names
- If using ESX default: Check items table in database
- Verify item names in `Config.Tiers` match your inventory system
- Check `Config.Account` setting ("bank" or "money")
- Look for console errors about inventory

**"Inventory full" message appearing:**
- ✅ **This is intended behavior with ox_inventory!**
- Player's inventory genuinely can't hold the items
- Check player weight/slots in ox_inventory
- Ask player to free up space and try again

**ox_inventory not being detected:**
- Verify ox_inventory starts BEFORE seasonal events in server.cfg
- Check resource name is exactly `ox_inventory`
- Restart seasonal events after ox_inventory is running
- Check console: `GetResourceState('ox_inventory')` should return `'started'`

**Events not auto-activating:**
- Check `Config.AutoActivate = true` in seasonal_manager/config.lua
- Verify `Config.TimezoneOffset` is correct for your location
- Check current date is within event date range
- Look for seasonal manager errors in console
- Use `seasonal:check` to force immediate check

### Debug Mode

Enable debug logging in any event:
```lua
-- config/main.lua
Config.Debug = true
```

This will show detailed logs about:
- Event cycles starting
- Location spawning
- Player claims
- Reward distribution
- ox_inventory operations

## 📝 Development Notes

All events follow identical architecture:
- Shared config system
- Client-side point management (ox_lib)
- Server-side validation & rewards
- Anti-cheat with violation tracking
- Tier-based reward scaling
- Automatic cycle management

## 🎨 Customization Ideas

1. **Add Weather Effects** (requires external script)
2. **Custom Props** (add models to stream folder)
3. **Sound Effects** (trigger on claim)
4. **Particle Effects** (on collection)
5. **Blips** (show locations on map)
6. **Discord Logs** (log all claims)

## 📦 What's Included

✅ 6 Complete Holiday Events  
✅ **Automatic Date-Based Activation**  
✅ **ox_inventory Compatibility** (auto-detected)  
✅ **Inventory Validation** (prevents item loss)  
✅ Configurable Locations  
✅ Tier Reward System  
✅ Anti-Cheat Protection  
✅ Multi-language Support  
✅ Automatic Cycle Management  
✅ Player Notifications  
✅ Distance Verification  
✅ Cooldown System  
✅ Server Commands for Control  
✅ Manual Override Options  
✅ Timezone Support  
✅ Export Functions for Integration  

## 📚 Additional Documentation

- **[README.md](README.md)** - Quick overview and features
- **[OX_INVENTORY_COMPATIBILITY.md](OX_INVENTORY_COMPATIBILITY.md)** - Complete ox_inventory integration guide
- **[OPTIMIZATION_REPORT.md](OPTIMIZATION_REPORT.md)** - Performance analysis and testing
- **[IMPROVEMENTS.md](IMPROVEMENTS.md)** - Changelog and version history  

## 🎉 You're Ready!

**For Complete Events (Christmas, Halloween, Easter):**
- ✅ Install and configure as described above
- ✅ Events will run automatically based on dates
- ✅ ox_inventory works automatically if installed
- ✅ No emojis in notifications - uses text prefixes like [CHRISTMAS], [HALLOWEEN], [EASTER]

**For Incomplete Events (New Year, Valentine, Independence):**
- ⚠️ Currently safe to load but won't run (code commented out)
- ⚠️ Print helpful TODO messages on startup
- 📋 To complete: Copy class files from esx_easter as templates
- 📋 Follow the **Global Variable Pattern** in template adaptation guide above
- 📋 Uncomment main.lua and fxmanifest.lua after creating class files
- ✅ Test thoroughly before production use

**Current Status (December 13, 2025):**
- 3 events fully working and production-ready
- 3 events waiting for class files (configs ready)
- All events use global variables (traditional FiveM pattern)
- All emojis replaced with text to prevent parsing errors

---

**Version:** 1.1.0  
**Last Updated:** December 13, 2025  
**Status:** ✅ 3/6 Events Production Ready - ox_inventory Compatible  
**Framework:** ESX Legacy  
**Dependencies:** ox_lib (required), ox_inventory (optional)  
**Dependencies:** ox_lib (required), ox_inventory (optional)
