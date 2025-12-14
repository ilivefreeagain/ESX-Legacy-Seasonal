---@class EasterTierReward
---@field Type "cash"|"item"
---@field Name string|nil
---@field Amount number

---@class EasterTier
---@field Name string
---@field ClaimOrder integer[]
---@field Rewards EasterTierReward[]

---@class EasterLocation
---@field Name string
---@field LandmarkCoords vector3
---@field EggCoords vector3[]

---@class EasterEventConfig
---@field Enabled boolean
---@field Debug boolean
---@field EventInterval integer
---@field MaxLocationsPerCycle integer
---@field UseRandomLocation boolean
---@field GlobalMaxClaims integer|nil
---@field PerPlayerMaxClaimsPerCycle integer|nil
---@field UseTierScaling boolean
---@field DefaultTierName string
---@field DespawnEggOnClaim boolean
---@field DespawnLocationWhenAllClaimed boolean
---@field DespawnLocationOnCycleEnd boolean
---@field Account string|nil
---@field MinClaimInterval integer
---@field MaxViolations integer
---@field KickOnMaxViolations boolean
---@field MaxClaimDistance number
---@field Locale string
---@field Locations EasterLocation[]
---@field Tiers EasterTier[]

---@type EasterEventConfig
---@diagnostic disable-next-line: missing-fields
Config = {}

Config.Enabled = true
Config.Debug = false

Config.EventInterval = 12 * 60 -- 12 minutes

Config.MaxLocationsPerCycle = 3
Config.UseRandomLocation = true

Config.GlobalMaxClaims = 30
Config.PerPlayerMaxClaimsPerCycle = 4

Config.UseTierScaling = true
Config.DefaultTierName = "Common"

Config.DespawnEggOnClaim = true
Config.DespawnLocationWhenAllClaimed = true
Config.DespawnLocationOnCycleEnd = true

Config.Account = "bank"

Config.MinClaimInterval = 2
Config.MaxViolations = 5
Config.KickOnMaxViolations = true
Config.MaxClaimDistance = 5.0

Config.Locale = GetConvar("esx:locale", "en")

Config.Locations = {
  {
    Name = "Vinewood Hills Park",
    LandmarkCoords = vec3(216.50, 365.23, 105.60),
    EggCoords = {
      vec3(214.34, 362.90, 105.60),
      vec3(218.67, 367.45, 105.60),
      vec3(220.12, 363.78, 105.60),
      vec3(213.45, 368.23, 105.60),
    }
  },
  {
    Name = "Legion Square Garden",
    LandmarkCoords = vec3(203.52, -941.16, 29.67),
    EggCoords = {
      vec3(199.43, -935.48, 29.67),
      vec3(199.31, -953.43, 29.08),
      vec3(175.00, -950.26, 29.08),
      vec3(180.12, -938.45, 29.67),
    }
  },
  {
    Name = "Del Perro Beach",
    LandmarkCoords = vec3(-1686.30, -1072.50, 13.15),
    EggCoords = {
      vec3(-1682.45, -1070.23, 13.15),
      vec3(-1690.12, -1075.67, 13.15),
      vec3(-1688.89, -1068.34, 13.15),
      vec3(-1684.23, -1073.90, 13.15),
    }
  },
  {
    Name = "Mirror Park",
    LandmarkCoords = vec3(1205.67, -598.34, 68.45),
    EggCoords = {
      vec3(1202.34, -595.90, 68.45),
      vec3(1208.90, -600.12, 68.45),
      vec3(1207.45, -596.78, 68.45),
      vec3(1203.12, -601.23, 68.45),
    }
  },
  {
    Name = "Chumash Beach",
    LandmarkCoords = vec3(-3085.45, 1384.67, 20.34),
    EggCoords = {
      vec3(-3082.12, 1382.34, 20.34),
      vec3(-3088.67, 1386.90, 20.34),
      vec3(-3087.23, 1383.45, 20.34),
      vec3(-3083.90, 1387.12, 20.34),
    }
  },
  {
    Name = "Paleto Forest",
    LandmarkCoords = vec3(-545.67, 5326.89, 73.23),
    EggCoords = {
      vec3(-542.34, 5324.12, 73.23),
      vec3(-548.90, 5329.45, 73.23),
      vec3(-547.12, 5325.67, 73.23),
      vec3(-543.45, 5328.90, 73.23),
    }
  }
}

Config.Tiers = {
  {
    Name = "Golden Egg",
    ClaimOrder = { 1 },
    Rewards = {
      { Type = "cash", Amount = 25000 },
      { Type = "item", Name = "bread", Amount = 8 },
      { Type = "item", Name = "water", Amount = 8 }
    }
  },
  {
    Name = "Silver Egg",
    ClaimOrder = { 2 },
    Rewards = {
      { Type = "cash", Amount = 12000 },
      { Type = "item", Name = "bread", Amount = 5 },
      { Type = "item", Name = "water", Amount = 5 }
    }
  },
  {
    Name = "Bronze Egg",
    ClaimOrder = { 3 },
    Rewards = {
      { Type = "cash", Amount = 6000 },
      { Type = "item", Name = "bread", Amount = 3 },
      { Type = "item", Name = "water", Amount = 3 }
    }
  },
  {
    Name = "Common Egg",
    ClaimOrder = { 4, 5, 6, 7, 8, 9, 10 },
    Rewards = {
      { Type = "cash", Amount = 3000 }
    }
  }
}
