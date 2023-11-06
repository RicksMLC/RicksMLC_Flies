-- RicksMLC_Stash.lua
-- Stash descriptions for the Greenport Secrets : Mwahahaha

require "StashDescriptions/StashUtil"

-- Stash 01: A simple shotgun cache in the fishing shack.
local stashMap = StashUtil.newStash("RicksMLCGPStashMap01", "Map", "Base.RicksMLCGreenportMap", "Stash_AnnotedMap")
stashMap.buildingX = 8237
stashMap.buildingY = 7434
stashMap:addStamp(nil, "Stash_RicksMLC_Map01_Text1", 8201, 7399, 0, 0, 0)
stashMap:addStamp("Circle", nil, 8237, 7434, 0, 0, 0)
stashMap:addStamp("ArrowSouthWest", nil, 8246, 7421, 0, 0, 0)
stashMap.spawnTable = "ShotgunCache1"
stashMap:addContainer(nil,nil,"Base.Bag_DuffelBagTINT",nil,nil,nil,nil)

-- Stash 02: Spiffo Merch and "Spiffo and Friends" in a custom distribution.
local stashMap = StashUtil.newStash("RicksMLCGPStashMap02", "Map", "Base.RicksMLCGreenportMap", "Stash_AnnotedMap")
stashMap.buildingX = 8562
stashMap.buildingY = 7636
stashMap:addStamp(nil, "Stash_RicksMLC_Map02_Text1", 8591, 7624, 0, 0, 0)
stashMap:addStamp(nil, "Stash_RicksMLC_Map02_Text2", 8592, 7643, 0, 0, 0)
stashMap:addStamp("Target", nil, 8561, 7636, 0, 0, 0)
stashMap:addStamp("ArrowWest", nil, 8581, 7636, 0, 0, 0)
stashMap:addStamp("Exclamation", nil, 8570, 7637, 0, 0, 0)
stashMap.spawnTable = "RicksMLC_spiffoloot"
stashMap:addContainer(nil,nil,"Base.Bag_DuffelBagTINT",nil,nil,nil,nil)

local stashMap = StashUtil.newStash("RicksMLCGPStashMap03", "Map", "Base.RicksMLCGreenportMap", "Stash_AnnotedMap")
stashMap.buildingX = 8598
stashMap.buildingY = 7610
stashMap:addStamp("FaceDead", nil, 8596, 7596, 0, 0, 0)
stashMap:addStamp(nil, "Heard noises here", 8609, 7582, 0, 0, 0)
stashMap:addStamp("ArrowSouthWest", nil, 8605, 7599, 0, 0, 0)
stashMap.spawnTable = "ShotgunCache2"
stashMap.barricades = 60
stashMap.zombies = 5
