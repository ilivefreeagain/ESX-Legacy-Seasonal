---@class SeasonalManagerConfig
Config = {}

-- Enable/Disable automatic date-based activation
Config.AutoActivate = true

-- Manual overrides (set to true to force enable, false to force disable, nil for auto)
Config.ManualOverrides = {
  christmas = nil,      -- nil = auto, true = force on, false = force off
  halloween = nil,
  easter = nil,
  newyear = nil,
  valentine = nil,
  independence = nil
}

-- Date ranges for each event (month/day format)
-- Events will be active during these date ranges
Config.EventSchedule = {
  christmas = {
    name = "Christmas",
    resource = "esx_christmas",
    startMonth = 12,
    startDay = 1,
    endMonth = 12,
    endDay = 31
  },
  
  halloween = {
    name = "Halloween",
    resource = "esx_halloween",
    startMonth = 10,
    startDay = 1,
    endMonth = 10,
    endDay = 31
  },
  
  easter = {
    name = "Easter",
    resource = "esx_easter",
    -- Easter varies by year, so we use a broader spring range
    startMonth = 3,
    startDay = 15,
    endMonth = 4,
    endDay = 30
  },
  
  newyear = {
    name = "New Year",
    resource = "esx_newyear",
    startMonth = 12,
    startDay = 28,
    endMonth = 1,
    endDay = 5  -- Spans across year boundary
  },
  
  valentine = {
    name = "Valentine's Day",
    resource = "esx_valentine",
    startMonth = 2,
    startDay = 7,
    endMonth = 2,
    endDay = 14
  },
  
  independence = {
    name = "Independence Day",
    resource = "esx_independence",
    startMonth = 7,
    startDay = 1,
    endMonth = 7,
    endDay = 7
  }
}

-- Timezone offset from UTC (e.g., -5 for EST, 0 for UTC, +1 for CET)
Config.TimezoneOffset = 0

-- Check interval in minutes (how often to check if events should change)
Config.CheckInterval = 60

-- Debug mode
Config.Debug = false

-- Notification settings
Config.Notifications = {
  enabled = true,
  announceEventStart = true,
  announceEventEnd = true
}
