---@class NewYearLocation
---@field Name string
---@field LandmarkCoords vector3
---@field GiftCoords vector3[]

---@class NewYearTier
---@field Name string
---@field ClaimOrder integer[]
---@field Rewards table[]

---@diagnostic disable: missing-fields
---@type table
Config = {}

Config.Enabled = true
Config.Debug = false
Config.EventInterval = 20 * 60 -- 20 minutes
Config.MaxLocationsPerCycle = 2
Config.UseRandomLocation = true
Config.GlobalMaxClaims = 20
Config.PerPlayerMaxClaimsPerCycle = 3
Config.UseTierScaling = true
Config.DefaultTierName = "Common"
Config.DespawnGiftOnClaim = true
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
    Name = "Legion Square - New Year Party",
    LandmarkCoords = vec3(203.52, -941.16, 29.67),
    GiftCoords = {
      vec3(199.43, -935.48, 29.67),
      vec3(199.31, -953.43, 29.08),
      vec3(175.00, -950.26, 29.08),
    }
  },
  {
    Name = "Del Perro Pier Celebration",
    LandmarkCoords = vec3(-1686.30, -1072.50, 13.15),
    GiftCoords = {
      vec3(-1682.45, -1070.23, 13.15),
      vec3(-1690.12, -1075.67, 13.15),
      vec3(-1688.89, -1068.34, 13.15),
    }
  },
  {
    Name = "Vinewood Hills Party",
    LandmarkCoords = vec3(216.50, 365.23, 105.60),
    GiftCoords = {
      vec3(214.34, 362.90, 105.60),
      vec3(218.67, 367.45, 105.60),
      vec3(220.12, 363.78, 105.60),
    }
  },
  {
    Name = "Sandy Shores Countdown",
    LandmarkCoords = vec3(1961.23, 3740.45, 32.34),
    GiftCoords = {
      vec3(1958.67, 3738.12, 32.34),
      vec3(1963.45, 3742.89, 32.34),
      vec3(1959.89, 3743.56, 32.34),
    }
  },
  {
    Name = "Paleto Bay Fireworks",
    LandmarkCoords = vec3(-278.45, 6230.12, 31.70),
    GiftCoords = {
      vec3(-275.23, 6227.89, 31.70),
      vec3(-281.67, 6232.45, 31.70),
      vec3(-280.12, 6228.34, 31.70),
    }
  }
}

Config.Tiers = {
  {
    Name = "Champagne",
    ClaimOrder = { 1 },
    Rewards = {
      { Type = "cash", Amount = 30000 },
      { Type = "item", Name = "bread", Amount = 10 },
      { Type = "item", Name = "water", Amount = 10 }
    }
  },
  {
    Name = "Premium",
    ClaimOrder = { 2 },
    Rewards = {
      { Type = "cash", Amount = 15000 },
      { Type = "item", Name = "bread", Amount = 6 },
      { Type = "item", Name = "water", Amount = 6 }
    }
  },
  {
    Name = "Standard",
    ClaimOrder = { 3 },
    Rewards = {
      { Type = "cash", Amount = 8000 },
      { Type = "item", Name = "bread", Amount = 4 },
      { Type = "item", Name = "water", Amount = 4 }
    }
  },
  {
    Name = "Common",
    ClaimOrder = { 4, 5, 6, 7, 8, 9, 10 },
    Rewards = {
      { Type = "cash", Amount = 4000 }
    }
  }
}
