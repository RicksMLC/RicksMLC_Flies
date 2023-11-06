-- RicksMLC_Flies.lua
-- Put flies on the player location.
-- TODO: Animate the flies sprite so it follows the player. This first version just "teleports" them.

RicksMLC_Flies = {}

RicksMLC_Flies.Enabled = true
RicksMLC_Flies.currentFliesSquare = nil
RicksMLC_Flies.TriggerDirtBloodLevel = SandboxVars.RicksMLC_Flies.DirtyLevel -- TODO: Make this a sandbox option for those axe-wielders out there.

function RicksMLC_Flies.Enable()
	RicksMLC_Flies.Enabled = true
end

function RicksMLC_Flies.Disable()
	RicksMLC_Flies.Enabled = false
end

function RicksMLC_Flies.ClearFlies()
    if RicksMLC_Flies.currentFliesSquare then
        RicksMLC_Flies.currentFliesSquare:setHasFlies(false)
        RicksMLC_Flies.currentFliesSquare = nil
    end
end

function RicksMLC_Flies.ToggleFlies()
    RicksMLC_Flies.Enabled = not RicksMLC_Flies.Enabled
    Events.EveryOneMinute.Remove(RicksMLC_Flies.EveryOneMinute)
    RicksMLC_Flies.ClearFlies()
    if RicksMLC_Flies.Enabled then
        Events.EveryOneMinute.Add(RicksMLC_Flies.EveryOneMinute)
    end
end

function RicksMLC_Flies.CalcClothingSmell()
    local clothing = {}
    clothing.back = getPlayer():getClothingItem_Back()
    clothing.feet = getPlayer():getClothingItem_Feet()
    clothing.hands = getPlayer():getClothingItem_Hands()
    clothing.head = getPlayer():getClothingItem_Head()
    clothing.legs = getPlayer():getClothingItem_Legs()
    clothing.torso = getPlayer():getClothingItem_Torso()

    local totalDirtyness = 0
    local totalBloodyness = 0
    for name, item in pairs(clothing) do
        if instanceof(item, "Clothing") then
            totalDirtyness = totalDirtyness + item:getDirtyness()
        end
        totalBloodyness = totalBloodyness + item:getBloodLevel()
    end
    return totalDirtyness + totalBloodyness
end

function RicksMLC_Flies.CalcBodySmell()
    -- from ISWashYourself
    local totalBlood = 0
    local totalDirt = 0
    local visual = getPlayer():getHumanVisual()
	for i=1,BloodBodyPartType.MAX:index() do
		local part = BloodBodyPartType.FromIndex(i-1)
        totalBlood = totalBlood + visual:getBlood(part)
        totalDirt = totalDirt + visual:getDirt(part)
	end
    return totalBlood + totalDirt
end

-- Note: I tried making every other minute, but it looked wrong with the delay of the flies moving tiles
function RicksMLC_Flies.EveryOneMinute()

    if getPlayer():isAsleep() then return end

	if not RicksMLC_Flies.Enabled then
        RicksMLC_Flies.ClearFlies()
		return
	end

    if RicksMLC_Flies.CalcClothingSmell() < RicksMLC_Flies.TriggerDirtBloodLevel
       and RicksMLC_Flies.CalcBodySmell() < RicksMLC_Flies.TriggerDirtBloodLevel then

        RicksMLC_Flies.ClearFlies()
        return
    end

    if getPlayer():isSeatedInVehicle() then
        getPlayer():playSound("RicksMLC_FliesInCar-lower")
        return
    end

    local square = getPlayer():getCell():getGridSquare(getPlayer():getX(), getPlayer():getY(), getPlayer():getZ())
    if not square then return end -- Just in case the player teleported and the square is not available yet
    if RicksMLC_Flies.currentFliesSquare ~= square then
        RicksMLC_Flies.ClearFlies()
        RicksMLC_Flies.currentFliesSquare = square
        RicksMLC_Flies.currentFliesSquare:setHasFlies(true)
    end
    RicksMLC_Flies.currentFliesSquare:playSound("RicksMLC_Flies02-lower")
end

function RicksMLC_Flies.OnCreatePlayer(player)
    RicksMLC_Flies.ClearFlies()
end

Events.OnCreatePlayer.Add(RicksMLC_Flies.OnCreatePlayer)
Events.EveryOneMinute.Add(RicksMLC_Flies.EveryOneMinute)

