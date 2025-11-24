---@class ChristmasTierReward
---@field Type "cash"|"item"
---@field Name string|nil
---@field Amount number

---@class ChristmasTier
---@field Name string
---@field ClaimOrder integer[]
---@field Rewards ChristmasTierReward[]

---@class ChristmasLocation
---@field Name string
---@field LandmarkCoords vector3
---@field LandmarkModel string|nil
---@field PresentCoords vector3[]
---@field HintModel string|nil

---@class ChristmasPropsConfig
---@field LandmarkModels string[]
---@field PresentModels string[]
---@field HintModels string[]
---@field ExtraDecorModels string[]

---@class ChristmasHintTexts
---@field [string] string

---@class ChristmasEventConfig
---@field Enabled boolean
---@field Debug boolean
---@field EventInterval integer
---@field MaxLocationsPerCycle integer
---@field UseRandomLocation boolean
---@field GlobalMaxClaims integer|nil
---@field PerPlayerMaxClaimsPerCycle integer|nil
---@field UseTierScaling boolean
---@field DefaultTierName string
---@field DespawnPresentOnClaim boolean
---@field DespawnLocationWhenAllClaimed boolean
---@field DespawnLocationOnCycleEnd boolean
---@field UseHints boolean
---@field Account string|nil
---@field MinClaimInterval integer
---@field MaxViolations integer
---@field KickOnMaxViolations boolean
---@field MaxClaimDistance number
---@field Locale string
---@field Locations ChristmasLocation[]
---@field Props ChristmasPropsConfig
---@field Tiers ChristmasTier[]
---@field Hints ChristmasHintTexts

---@type ChristmasEventConfig
---@diagnostic disable-next-line: missing-fields
Config = {}

Config.Enabled = true
Config.Debug = true

Config.EventInterval = 10 * 60

Config.MaxLocationsPerCycle = 1
Config.UseRandomLocation = true

Config.GlobalMaxClaims = 20
Config.PerPlayerMaxClaimsPerCycle = 3

Config.UseTierScaling = true
Config.DefaultTierName = "Common"

Config.DespawnPresentOnClaim = true
Config.DespawnLocationWhenAllClaimed = true
Config.DespawnLocationOnCycleEnd = true

Config.UseHints = true

Config.Account = "bank"

Config.MinClaimInterval = 2
Config.MaxViolations = 5
Config.KickOnMaxViolations = true
Config.MaxClaimDistance = 5.0

Config.Locale = GetConvar("esx:locale", "en")

Config.Locations = {
  {
    Name = "Legion Square",
    LandmarkCoords = vec3(203.525284, -941.169250, 29.678345),
    LandmarkModel = nil,
    PresentCoords = {
      vec3(199.437363, -935.485718, 29.678345),
      vec3(199.318680, -953.432983, 29.088623),
      vec3(175.002197, -950.268127, 29.088623),
    },
    HintModel = "sp_christmas_snowman"
  }
}

Config.Props = {
  LandmarkModels = {
    "sp_large_christmas_santa",
    "sp_medium_christmas_santa",
    "prop_xmas_tree_int",
    "sp_candycane"
  },
  PresentModels = {
    "sp_snow_gifts",
    "sp_snow_candy",
    "sp_christmas_star",
    "sp_light_tree_1"
  },
  HintModels = {
    "sp_christmas_snowman",
    "sp_christmas_deer"
  },
  ExtraDecorModels = {
    "sp_merry_christmas",
    "sp_light_strip",
    "sp_pillar_light",
    "sp_stars_03",
    "prop_prlg_snowpile"
  }
}

Config.Tiers = {
  {
    Name = "Legendary",
    ClaimOrder = { 1 },
    Rewards = {
      { Type = "cash", Amount = 10000 },
      { Type = "item", Name = "armor",            Amount = 1 },
      { Type = "item", Name = "christmas_ticket", Amount = 1 }
    }
  },
  {
    Name = "Epic",
    ClaimOrder = { 2 },
    Rewards = {
      { Type = "cash", Amount = 5000 },
      { Type = "item", Name = "steel",            Amount = 1 },
      { Type = "item", Name = "christmas_cookie", Amount = 2 }
    }
  },
  {
    Name = "Common",
    ClaimOrder = { 3 },
    Rewards = {
      { Type = "cash", Amount = 1000 },
      { Type = "item", Name = "hot_chocolate", Amount = 1 }
    }
  }
}

Config.Hints = {
  ["sp_christmas_snowman"] = "xmas_hint_snowman",
  ["sp_christmas_deer"] = "xmas_hint_deer"
}
