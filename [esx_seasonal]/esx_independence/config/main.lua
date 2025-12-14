---@class IndependenceLocation
---@field Name string
---@field LandmarkCoords vector3
---@field FireworkCoords vector3[]

---@class IndependenceTier
---@field Name string
---@field ClaimOrder integer[]
---@field Rewards table[]

---@diagnostic disable: missing-fields
---@type table
Config = {}

Config.Enabled = true
Config.Debug = false
Config.EventInterval = 15 * 60 -- 15 minutes
Config.MaxLocationsPerCycle = 3
Config.UseRandomLocation = true
Config.GlobalMaxClaims = 28
Config.PerPlayerMaxClaimsPerCycle = 5
Config.UseTierScaling = true
Config.DefaultTierName = "Common"
Config.DespawnFireworkOnClaim = true
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
    Name = "Vespucci Beach - Fireworks Show",
    LandmarkCoords = vec3(-1686.30, -1072.50, 13.15),
    FireworkCoords = {
      vec3(-1682.45, -1070.23, 13.15),
      vec3(-1690.12, -1075.67, 13.15),
      vec3(-1688.89, -1068.34, 13.15),
      vec3(-1684.23, -1073.90, 13.15),
    }
  },
  {
    Name = "Fort Zancudo Parade",
    LandmarkCoords = vec3(-2320.45, 3283.12, 32.81),
    FireworkCoords = {
      vec3(-2317.23, 3280.67, 32.81),
      vec3(-2323.67, 3285.45, 32.81),
      vec3(-2322.12, 3281.89, 32.81),
      vec3(-2318.45, 3284.23, 32.81),
    }
  },
  {
    Name = "Sandy Shores Celebration",
    LandmarkCoords = vec3(1961.23, 3740.45, 32.34),
    FireworkCoords = {
      vec3(1958.67, 3738.12, 32.34),
      vec3(1963.45, 3742.89, 32.34),
      vec3(1959.89, 3743.56, 32.34),
      vec3(1962.12, 3739.23, 32.34),
    }
  },
  {
    Name = "Paleto Bay Festival",
    LandmarkCoords = vec3(-278.45, 6230.12, 31.70),
    FireworkCoords = {
      vec3(-275.23, 6227.89, 31.70),
      vec3(-281.67, 6232.45, 31.70),
      vec3(-280.12, 6228.34, 31.70),
      vec3(-276.89, 6231.67, 31.70),
    }
  },
  {
    Name = "Legion Square Patriotic Event",
    LandmarkCoords = vec3(203.52, -941.16, 29.67),
    FireworkCoords = {
      vec3(199.43, -935.48, 29.67),
      vec3(199.31, -953.43, 29.08),
      vec3(175.00, -950.26, 29.08),
      vec3(180.12, -938.45, 29.67),
    }
  },
  {
    Name = "Vinewood Bowl Show",
    LandmarkCoords = vec3(686.23, 577.89, 130.46),
    FireworkCoords = {
      vec3(683.12, 575.34, 130.46),
      vec3(689.45, 580.12, 130.46),
      vec3(687.89, 576.67, 130.46),
      vec3(684.67, 579.23, 130.46),
    }
  }
}

Config.Tiers = {
  {
    Name = "Grand Finale",
    ClaimOrder = { 1 },
    Rewards = {
      { Type = "cash", Amount = 22000 },
      { Type = "item", Name = "bread", Amount = 8 },
      { Type = "item", Name = "water", Amount = 8 }
    }
  },
  {
    Name = "Premium Fireworks",
    ClaimOrder = { 2 },
    Rewards = {
      { Type = "cash", Amount = 11000 },
      { Type = "item", Name = "bread", Amount = 6 },
      { Type = "item", Name = "water", Amount = 6 }
    }
  },
  {
    Name = "Standard Fireworks",
    ClaimOrder = { 3 },
    Rewards = {
      { Type = "cash", Amount = 6500 },
      { Type = "item", Name = "bread", Amount = 4 },
      { Type = "item", Name = "water", Amount = 4 }
    }
  },
  {
    Name = "Common",
    ClaimOrder = { 4, 5, 6, 7, 8, 9, 10 },
    Rewards = {
      { Type = "cash", Amount = 3500 }
    }
  }
}
