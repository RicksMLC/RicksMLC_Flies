-- RicksMLC_Distributions.lua
-- Distributions for the Annotated Map custom loot tables.

require "Items/Distributions"

local distributionTable = {
    RicksMLC_spiffoloot = {
        Bag_DuffelBagTINT = {
            rolls=8,
            items = {
                "BorisBadger", 20,
                "FluffyfootBunny", 20,
                "FreddyFox", 20,
                "FurbertSquirrel", 20,
                "JacquesBeaver", 20,
                "MoleyMole", 20,
                "PancakeHedgehog", 20,
                "Spiffo", 20,
            },
            junk = {
                rolls = 1,
                items = {
                    
                }
            },
        },
        counter = {
            procedural = true,
            procList = {
                {name="CrateSpiffoMerch", min=1, max=6, weightChance=100},
            }
        },
    }
}

local function preDistributionMerge()
    -- Always insert at the 2nd entry - the vanilla distributions are always first.
    --DebugLog.log(DebugType.Mod, "RicksMLC_Distributions preDistributionMerge()")

    table.insert(Distributions, 2, distributionTable);
end

Events.OnPreDistributionMerge.Add(preDistributionMerge)
