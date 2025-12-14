---@class ValentineLocation
---@field Name string
---@field LandmarkCoords vector3
---@field LetterCoords vector3[]

---@class ValentineTier
---@field Name string
---@field ClaimOrder integer[]
---@field Rewards table[]

---@diagnostic disable: missing-fields
---@type table
Config = {}

Config.Enabled = true
Config.Debug = false
Config.EventInterval = 18 * 60 -- 18 minutes
Config.MaxLocationsPerCycle = 2
Config.UseRandomLocation = true
Config.GlobalMaxClaims = 22
Config.PerPlayerMaxClaimsPerCycle = 4
Config.UseTierScaling = true
Config.DefaultTierName = "Common"
Config.DespawnLetterOnClaim = true
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
    Name = "Vinewood Hills - Lovers Lane",
    LandmarkCoords = vec3(216.50, 365.23, 105.60),
    LetterCoords = {
      vec3(214.34, 362.90, 105.60),
      vec3(218.67, 367.45, 105.60),
      vec3(220.12, 363.78, 105.60),
    }
  },
  {
    Name = "Del Perro Pier - Romantic Sunset",
    LandmarkCoords = vec3(-1686.30, -1072.50, 13.15),
    LetterCoords = {
      vec3(-1682.45, -1070.23, 13.15),
      vec3(-1690.12, -1075.67, 13.15),
      vec3(-1688.89, -1068.34, 13.15),
    }
  },
  {
    Name = "Legion Square - Love Garden",
    LandmarkCoords = vec3(203.52, -941.16, 29.67),
    LetterCoords = {
      vec3(199.43, -935.48, 29.67),
      vec3(199.31, -953.43, 29.08),
      vec3(175.00, -950.26, 29.08),
    }
  },
  {
    Name = "Mirror Park - Couple's Retreat",
    LandmarkCoords = vec3(1205.67, -598.34, 68.45),
    LetterCoords = {
      vec3(1202.34, -595.90, 68.45),
      vec3(1208.90, -600.12, 68.45),
      vec3(1207.45, -596.78, 68.45),
    }
  },
  {
    Name = "Chumash Beach - Love Spot",
    LandmarkCoords = vec3(-3085.45, 1384.67, 20.34),
    LetterCoords = {
      vec3(-3082.12, 1382.34, 20.34),
      vec3(-3088.67, 1386.90, 20.34),
      vec3(-3087.23, 1383.45, 20.34),
    }
  }
}

Config.Tiers = {
  {
    Name = "Love Letter",
    ClaimOrder = { 1 },
    Rewards = {
      { Type = "cash", Amount = 18000 },
      { Type = "item", Name = "bread", Amount = 7 },
      { Type = "item", Name = "water", Amount = 7 }
    }
  },
  {
    Name = "Rose Bouquet",
    ClaimOrder = { 2 },
    Rewards = {
      { Type = "cash", Amount = 9000 },
      { Type = "item", Name = "bread", Amount = 5 },
      { Type = "item", Name = "water", Amount = 5 }
    }
  },
  {
    Name = "Chocolate Box",
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
      { Type = "cash", Amount = 2000 }
    }
  }
}
