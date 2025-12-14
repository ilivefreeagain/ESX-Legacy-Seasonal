---@class HalloweenTierReward
---@field Type "cash"|"item"
---@field Name string|nil
---@field Amount number

---@class HalloweenTier
---@field Name string
---@field ClaimOrder integer[]
---@field Rewards HalloweenTierReward[]

---@class HalloweenLocation
---@field Name string
---@field LandmarkCoords vector3
---@field TreatCoords vector3[]

---@class HalloweenEventConfig
---@field Enabled boolean
---@field Debug boolean
---@field EventInterval integer
---@field MaxLocationsPerCycle integer
---@field UseRandomLocation boolean
---@field GlobalMaxClaims integer|nil
---@field PerPlayerMaxClaimsPerCycle integer|nil
---@field UseTierScaling boolean
---@field DefaultTierName string
---@field DespawnTreatOnClaim boolean
---@field DespawnLocationWhenAllClaimed boolean
---@field DespawnLocationOnCycleEnd boolean
---@field Account string|nil
---@field MinClaimInterval integer
---@field MaxViolations integer
---@field KickOnMaxViolations boolean
---@field MaxClaimDistance number
---@field Locale string
---@field Locations HalloweenLocation[]
---@field Tiers HalloweenTier[]

---@type HalloweenEventConfig
---@diagnostic disable-next-line: missing-fields
Config = {}

Config.Enabled = true
Config.Debug = false

Config.EventInterval = 15 * 60 -- 15 minutes

Config.MaxLocationsPerCycle = 2
Config.UseRandomLocation = true

Config.GlobalMaxClaims = 25
Config.PerPlayerMaxClaimsPerCycle = 5

Config.UseTierScaling = true
Config.DefaultTierName = "Common"

Config.DespawnTreatOnClaim = true
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
    Name = "Graveyard - Vinewood Hills",
    LandmarkCoords = vec3(-1285.50, 471.23, 97.60),
    TreatCoords = {
      vec3(-1282.34, 468.90, 97.60),
      vec3(-1288.67, 473.45, 97.60),
      vec3(-1286.12, 469.78, 97.60),
    }
  },
  {
    Name = "Legion Square",
    LandmarkCoords = vec3(203.52, -941.16, 29.67),
    TreatCoords = {
      vec3(199.43, -935.48, 29.67),
      vec3(199.31, -953.43, 29.08),
      vec3(175.00, -950.26, 29.08),
    }
  },
  {
    Name = "Del Perro Pier",
    LandmarkCoords = vec3(-1686.30, -1072.50, 13.15),
    TreatCoords = {
      vec3(-1682.45, -1070.23, 13.15),
      vec3(-1690.12, -1075.67, 13.15),
      vec3(-1688.89, -1068.34, 13.15),
    }
  },
  {
    Name = "Sandy Shores Motel",
    LandmarkCoords = vec3(1961.23, 3740.45, 32.34),
    TreatCoords = {
      vec3(1958.67, 3738.12, 32.34),
      vec3(1963.45, 3742.89, 32.34),
      vec3(1959.89, 3743.56, 32.34),
    }
  },
  {
    Name = "Paleto Bay",
    LandmarkCoords = vec3(-278.45, 6230.12, 31.70),
    TreatCoords = {
      vec3(-275.23, 6227.89, 31.70),
      vec3(-281.67, 6232.45, 31.70),
      vec3(-280.12, 6228.34, 31.70),
    }
  },
  {
    Name = "Vinewood Sign",
    LandmarkCoords = vec3(725.50, 1198.30, 326.35),
    TreatCoords = {
      vec3(722.34, 1196.12, 326.35),
      vec3(728.67, 1200.45, 326.35),
      vec3(726.12, 1197.89, 326.35),
    }
  }
}

Config.Tiers = {
  {
    Name = "Legendary",
    ClaimOrder = { 1 },
    Rewards = {
      { Type = "cash", Amount = 20000 },
      { Type = "item", Name = "bread", Amount = 10 },
      { Type = "item", Name = "water", Amount = 10 }
    }
  },
  {
    Name = "Epic",
    ClaimOrder = { 2 },
    Rewards = {
      { Type = "cash", Amount = 10000 },
      { Type = "item", Name = "bread", Amount = 5 },
      { Type = "item", Name = "water", Amount = 5 }
    }
  },
  {
    Name = "Rare",
    ClaimOrder = { 3 },
    Rewards = {
      { Type = "cash", Amount = 5000 },
      { Type = "item", Name = "bread", Amount = 3 },
      { Type = "item", Name = "water", Amount = 3 }
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
