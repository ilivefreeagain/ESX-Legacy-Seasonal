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
Config.Debug = false

Config.EventInterval = 15 * 60

Config.MaxLocationsPerCycle = 2
Config.UseRandomLocation = true

Config.GlobalMaxClaims = 25
Config.PerPlayerMaxClaimsPerCycle = 3

Config.UseTierScaling = true
Config.DefaultTierName = "Common"

Config.DespawnPresentOnClaim = true
Config.DespawnLocationWhenAllClaimed = true
Config.DespawnLocationOnCycleEnd = true

Config.UseHints = true

Config.Account = "cash"

Config.MinClaimInterval = 2
Config.MaxViolations = 5
Config.KickOnMaxViolations = true
Config.MaxClaimDistance = 5.0

Config.Locale = GetConvar("esx:locale", "en")

Config.Locations = {
  {
    Name = "Legion Square",
    LandmarkCoords = vec3(203.525284, -941.169250, 29.678345),
    LandmarkModel = "sp_large_christmas_santa",
    PresentCoords = {
      vec3(199.437363, -935.485718, 29.678345),
      vec3(199.318680, -953.432983, 29.088623),
      vec3(175.002197, -950.268127, 29.088623),
      vec3(185.234567, -945.123456, 29.345678),
    },
    HintModel = "sp_christmas_snowman"
  },
  {
    Name = "Pillbox Hill Medical Center",
    LandmarkCoords = vec3(298.50, -584.50, 43.26),
    LandmarkModel = "prop_xmas_tree_int",
    PresentCoords = {
      vec3(295.12, -587.23, 43.18),
      vec3(301.45, -581.89, 43.18),
      vec3(302.78, -590.12, 43.18),
    },
    HintModel = "sp_christmas_deer"
  },
  {
    Name = "Del Perro Pier",
    LandmarkCoords = vec3(-1686.30, -1072.50, 13.15),
    LandmarkModel = "sp_medium_christmas_santa",
    PresentCoords = {
      vec3(-1682.45, -1070.23, 13.15),
      vec3(-1690.12, -1075.67, 13.15),
      vec3(-1688.89, -1068.34, 13.15),
    },
    HintModel = "sp_christmas_snowman"
  },
  {
    Name = "Vinewood Boulevard",
    LandmarkCoords = vec3(213.45, 123.67, 102.76),
    LandmarkModel = "sp_candycane",
    PresentCoords = {
      vec3(210.23, 125.34, 102.76),
      vec3(216.78, 121.45, 102.76),
      vec3(215.12, 126.89, 102.76),
    },
    HintModel = "sp_christmas_deer"
  },
  {
    Name = "Sandy Shores",
    LandmarkCoords = vec3(1961.23, 3740.45, 32.34),
    LandmarkModel = "prop_xmas_tree_int",
    PresentCoords = {
      vec3(1958.67, 3738.12, 32.34),
      vec3(1963.45, 3742.89, 32.34),
      vec3(1959.89, 3743.56, 32.34),
    },
    HintModel = "sp_christmas_snowman"
  },
  {
    Name = "Paleto Bay",
    LandmarkCoords = vec3(-278.45, 6230.12, 31.70),
    LandmarkModel = "sp_large_christmas_santa",
    PresentCoords = {
      vec3(-275.23, 6227.89, 31.70),
      vec3(-281.67, 6232.45, 31.70),
      vec3(-280.12, 6228.34, 31.70),
    },
    HintModel = "sp_christmas_deer"
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
      { Type = "cash", Amount = 20000 },
      { Type = "item", Name = "bread",            Amount = 8 },
      { Type = "item", Name = "water",            Amount = 8 }
    }
  },
  {
    Name = "Epic",
    ClaimOrder = { 2 },
    Rewards = {
      { Type = "cash", Amount = 10000 },
      { Type = "item", Name = "bread",            Amount = 5 },
      { Type = "item", Name = "water",            Amount = 5 }
    }
  },
  {
    Name = "Rare",
    ClaimOrder = { 3 },
    Rewards = {
      { Type = "cash", Amount = 5000 },
      { Type = "item", Name = "bread",            Amount = 3 },
      { Type = "item", Name = "water",            Amount = 3 }
    }
  },
  {
    Name = "Common",
    ClaimOrder = { 4, 5, 6, 7, 8, 9, 10 },
    Rewards = {
      { Type = "cash", Amount = 2500 }
    }
  }
}

Config.Hints = {
  ["sp_christmas_snowman"] = "xmas_hint_snowman",
  ["sp_christmas_deer"] = "xmas_hint_deer"
}
