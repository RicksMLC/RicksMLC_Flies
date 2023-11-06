--RicksMLC_DemoCustomTreasureMap.lua

require "RicksMLC_MapInfo"
require "RicksMLC_MapUtils"
require "RicksMLC_TreasureHuntMgr"

local function AddGreenportToTreasureHunt()
    DebugLog.log(DebugType.Mod, "AddGreenportToTreasureHunt()")
    local bounds = {8100, 7310, 8699, 7799, 'media/maps/Greenport'} -- Town bounds and map name
    RicksMLC_MapInfo.AddTown("Greenport", bounds)
end

local function InitTreasureHunt()
    if RicksMLC_TreasureHuntMgrInstance then
        local treasureHuntDefn = {
            Name = "Spiffo And Friends", Town = "Greenport", Barricades = {1, 100}, Zombies = {3, 15}, Treasures = {
            "BorisBadger",
            "FluffyfootBunny",
            "FreddyFox",
            "FurbertSquirrel",
            "JacquesBeaver",
            "MoleyMole",
            "PancakeHedgehog",
            "Spiffo"}
        }
        RicksMLC_TreasureHuntMgr.Instance():AddTreasureHunt(treasureHuntDefn, true) -- Force map onto first zombie
    end
end

-- Treasure Hunt Definitions: { Name = string, Town = nil | string Barricades = {min, max} | n, Zombies = {min, max} | n, Treasures = {string, string...}, ) }
local function OnKeyPressed(key)
    if key == Keyboard.KEY_F10 then
        -- FIXME: Remove when testing Init is complete
--        AddGreenportToTreasureHunt()
    end
end

Events.OnKeyPressed.Add(OnKeyPressed)
Events.RicksMLC_TreasureHuntMgr_InitDone.Add(InitTreasureHunt)
Events.OnGameStart.Add(AddGreenportToTreasureHunt)
