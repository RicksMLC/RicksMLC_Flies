-- RicksMLC_Flies.lua
-- Put flies on the player location.
-- TODO: Animate the flies sprite so it follows the player. This first version just "teleports" them.

require "ISBaseObject"
local FliesInfo = ISBaseObject:derive("FliesInfo")

function FliesInfo:new(square)
	local o = {}
	setmetatable(o, self)
	self.__index = self

    o.square = square
    o.hasFlies = false

    return o
end

function FliesInfo:HasFlies() return self.hasFlies end

function FliesInfo:SetFliesOn(fliesOn)
    self.hasFlies = fliesOn
    if self.square then
        self:SetHasFliesSafely(fliesOn)
    end
end

function FliesInfo:SetHasFliesSafely(hasFlies)
    local square = self:GetSquareIfValid()
    if square then
        square:setHasFlies(hasFlies)
    end
end

function FliesInfo:ChangeSquare(newSquare)
    if self.hasFlies then
        self:SetHasFliesSafely(false)
    end
    self.square = newSquare
    if self.hasFlies then
        self:SetHasFliesSafely(true)
    end
end

function FliesInfo:ShowFlies()
    self:SetHasFliesSafely(true)
end

function FliesInfo:HideFlies()
    self:SetHasFliesSafely(false)
end

function FliesInfo:GetSquare()
    return self.square 
end

-- Returns nil if the self.square is not in the getPlayer() cell.
function FliesInfo:GetSquareIfValid()
    if not self.square then return nil end
    return getPlayer():getCell():getGridSquare(self.square:getX(), self.square:getY(), self.square:getZ())
end

-------------------------------------------------

RicksMLC_Flies = {}

RicksMLC_Flies.Enabled = true
RicksMLC_Flies.currentFliesSquareList = {}
RicksMLC_Flies.TriggerDirtBloodLevel = SandboxVars.RicksMLC_Flies.DirtyLevel -- This a sandbox option for those axe-wielders out there.

RicksMLC_Flies.FliesOn = false
RicksMLC_Flies.isSeatedInVehicle = false

function RicksMLC_Flies.IsEnabled() return RicksMLC_Flies.Enabled end

function RicksMLC_Flies.Enable()
	RicksMLC_Flies.Enabled = true
end

function RicksMLC_Flies.Disable()
	RicksMLC_Flies.Enabled = false
end

function RicksMLC_Flies.GetCurrentFliesSquare(playerID)
    -- Gets the flies square for the given playerID inside the getPlayer() cell.
    local fliesInfo = RicksMLC_Flies.currentFliesSquareList[playerID]
    if not fliesInfo then
        return nil
    end
    return fliesInfo:GetSquareIfValid()
end

function RicksMLC_Flies.HideFlies(playerId)
    if not RicksMLC_Flies.currentFliesSquareList[playerId] then return end

    local playerSquare = RicksMLC_Flies.currentFliesSquareList[playerId]:GetSquareIfValid()
    if isClient() then
        -- Check if another player has flies on this square before removing them.
        for checkPlayerId, fliesInfo in pairs(RicksMLC_Flies.currentFliesSquareList) do
            DebugLog.log(DebugType.Mod, "RicksMLC_Flies.ClearFliesFromList() checkPlayerId: " .. tostring(checkPlayerId) .. " playeId: " .. tostring(playerId))
            if checkPlayerId ~= playerId and fliesInfo then
                local square = fliesInfo:GetSquareIfValid()
                if square and square == playerSquare then
                    -- Another player has flies on this square, so don't remove them.
                    return
                end 
            end
        end
    end
    if playerSquare then
        RicksMLC_Flies.currentFliesSquareList[playerId]:HideFlies()
    end
end

function RicksMLC_Flies.ClearFliesFromList(playerId)
    if not RicksMLC_Flies.currentFliesSquareList[playerId] then return end

    if isClient() then
        -- Check if another player has flies on this square before removing them.
        local playerClearSquare = RicksMLC_Flies.currentFliesSquareList[playerId]:GetSquare()
        for checkPlayerId, playerSquare in pairs(RicksMLC_Flies.currentFliesSquareList) do
            DebugLog.log(DebugType.Mod, "RicksMLC_Flies.ClearFliesFromList() checkPlayerId: " .. tostring(checkPlayerId) .. " playeId: " .. tostring(playerId))
            if checkPlayerId ~= playerId and playerSquare then
                square = RicksMLC_Flies.GetCurrentFliesSquare(checkPlayerId)
                if square and square == playerClearSquare then
                    -- Another player has flies on this square, so don't remove them.
                    return
                end 
            end
        end
    end
    if RicksMLC_Flies.currentFliesSquareList[playerId] then
        if RicksMLC_Flies.GetCurrentFliesSquare(playerId) then
            RicksMLC_Flies.currentFliesSquareList[playerId]:SetFliesOn(false)
        end
    end
end

function RicksMLC_Flies.ClearAllFliesFromList()
    RicksMLC_Flies.ClearFliesFromList(0)
    if isClient() then
        local players = getOnlinePlayers()
        for playerNum=0, players:size()-1 do
            local player = players:get(playerNum)
            RicksMLC_Flies.ClearFliesFromList(player:getOnlineID())
        end
    end
end

function RicksMLC_Flies.SetEnabled(isEnabled)
    RicksMLC_Flies.Enabled = isEnabled
    Events.EveryOneMinute.Remove(RicksMLC_Flies.EveryOneMinute)
    if RicksMLC_Flies.Enabled then
        Events.EveryOneMinute.Add(RicksMLC_Flies.EveryOneMinute)
    else
        RicksMLC_Flies.ClearAllFliesFromList()
    end
end

function RicksMLC_Flies.ToggleFlies()
    RicksMLC_Flies.SetEnabled(not RicksMLC_Flies.Enabled)
end

function RicksMLC_Flies.CalcClothingSmell(player)
    local wornItems = player:getWornItems()
    local totalDirtyness = 0
    local totalBloodyness = 0
    for i=0, wornItems:size() - 1 do
        local item = wornItems:getItemByIndex(i)
        if instanceof(item, "Clothing") then
            totalDirtyness = totalDirtyness + item:getDirtyness()
        end
        totalBloodyness = totalBloodyness + item:getBloodLevel()
    end
    return totalDirtyness + totalBloodyness
end

function RicksMLC_Flies.CalcBodySmell(player)
    -- from ISWashYourself
    local totalBlood = 0
    local totalDirt = 0
    local visual = player:getHumanVisual()
	for i=1,BloodBodyPartType.MAX:index() do
		local part = BloodBodyPartType.FromIndex(i-1)
        totalBlood = totalBlood + visual:getBlood(part)
        totalDirt = totalDirt + visual:getDirt(part)
	end
    return totalBlood + totalDirt
end

RicksMLC_Flies.soundHandle = 0
RicksMLC_Flies.soundEmitter = nil
RicksMLC_Flies.volumeAdjustment = 0.5
function RicksMLC_Flies.SetVolumeAdjustment(volume)
    RicksMLC_Flies.volumeAdjustment = volume / 10

    RicksMLC_Flies.soundEmitter:setVolume(RicksMLC_Flies.soundHandle, RicksMLC_Flies.volumeAdjustment)
end

function RicksMLC_Flies.PlaySound(sound, soundSource)
    RicksMLC_Flies.soundEmitter = RicksMLC_Flies.soundEmitter or getPlayer():getEmitter()
    RicksMLC_Flies.soundEmitter:setPos(soundSource:getX(), soundSource:getY(), soundSource:getZ())

    --if RicksMLC_Flies.soundEmitter:isPlaying(RicksMLC_Flies.soundHandle) then return end
    
    RicksMLC_Flies.soundHandle = RicksMLC_Flies.soundEmitter:playSound(sound)
    handle = RicksMLC_Flies.soundHandle
    RicksMLC_Flies.soundEmitter:setVolume(RicksMLC_Flies.soundHandle, RicksMLC_Flies.volumeAdjustment) 

    -- DebugLog.log(DebugType.Mod, "PlaySound() " .. sound .. " " .. tostring(handle) )
end

function RicksMLC_Flies.UpdateFlies(player, playerID, fliesOn)
    if not fliesOn then
        RicksMLC_Flies.ClearFliesFromList(playerID)
        return
    end
    -- playSound sends the play to all clients, so only update for the getPlayer()
    if player:isSeatedInVehicle() then
        if player == getPlayer() then
            RicksMLC_Flies.PlaySound("RicksMLC_FliesInCar-lower", player)
        end
        RicksMLC_Flies.HideFlies(playerID)
        return
    end
    local square = player:getCell():getGridSquare(player:getX(), player:getY(), player:getZ())
    if not square then
        -- Just in case the player teleported and the square is not available yet.
        -- Or the player is not in the getPlayer() cell so the flies are not visible anyway.
        RicksMLC_Flies.HideFlies(playerID)
        return
    end 
    if not RicksMLC_Flies.currentFliesSquareList[playerID] then
        RicksMLC_Flies.currentFliesSquareList[playerID] = FliesInfo:new(player:getCurrentSquare())
    end
    RicksMLC_Flies.currentFliesSquareList[playerID]:SetFliesOn(fliesOn)
    if RicksMLC_Flies.currentFliesSquareList[playerID]:GetSquare() ~= square then
        RicksMLC_Flies.currentFliesSquareList[playerID]:ChangeSquare(square)
    end
    -- playSound sends the play to all clients, so only update for the getPlayer()
    if player == getPlayer() then
        --RicksMLC_Flies.currentFliesSquareList[playerID].square:playSound("RicksMLC_Flies02-lower")
        RicksMLC_Flies.PlaySound("RicksMLC_Flies02-lower", RicksMLC_Flies.currentFliesSquareList[playerID].square)
    end
end

function RicksMLC_Flies.SendUpdateSmellToServer()
    DebugLog.log(DebugType.Mod, "RicksMLC_Flies.SendUpdateSmellToServer() FliesOn: " .. tostring(RicksMLC_Flies.FliesOn))
    local args = {FliesOn = RicksMLC_Flies.FliesOn, OnlineId = getPlayer():getOnlineID()}
    sendClientCommand("RicksMLC_FliesServer", "UpdateSmell", args)
end

function RicksMLC_Flies.HandleServerSmellUpdate(module, command, args)
    if module == "RicksMLC_Flies" and command == "UpdateSmellFromServer" then
        DebugLog.log(DebugType.Mod, "RicksMLC_Flies.HandleClientSmellUpdate()")
        RicksMLC_SharedUtils.DumpArgs(args, 0, "Server smell args")
        for onlineId, playerFliesOn in pairs(args.PlayerFliesList) do
            -- Only process other player's flies
            if getPlayer():getOnlineID() ~= onlineId then
                local player = getPlayerByOnlineID(onlineId)
                if player then
                    if not RicksMLC_Flies.currentFliesSquareList[onlineId] then
                        RicksMLC_Flies.currentFliesSquareList[onlineId] = FliesInfo:new(player:getCurrentSquare())
                    end
                    RicksMLC_Flies.UpdateFlies(player, onlineId, playerFliesOn)
                end
            end
        end
    end
end

function RicksMLC_Flies.UpdateFliesOnStatus()
    local clothingSmell = RicksMLC_Flies.CalcClothingSmell(getPlayer())
    local bodySmell = RicksMLC_Flies.CalcBodySmell(getPlayer())
    local newFliesOnStatus = clothingSmell >= RicksMLC_Flies.TriggerDirtBloodLevel or bodySmell >= RicksMLC_Flies.TriggerDirtBloodLevel
    if RicksMLC_Flies.FliesOn ~= newFliesOnStatus then
        RicksMLC_Flies.FliesOn = newFliesOnStatus
        return true
    end
    if getPlayer():isSeatedInVehicle() ~= RicksMLC_Flies.isSeatedInVehicle then
        RicksMLC_Flies.isSeatedInVehicle = getPlayer():isSeatedInVehicle()
        return true
    end
    return false
end

function RicksMLC_Flies.UpdateMyFlies()
    local newStatusDetected = RicksMLC_Flies.UpdateFliesOnStatus()
    if isClient() and newStatusDetected then
        RicksMLC_Flies.SendUpdateSmellToServer()
    end
    local playerId = 0
    if isClient() then
        playerId = getPlayer():getOnlineID() 
    end
    RicksMLC_Flies.UpdateFlies(getPlayer(), playerId, RicksMLC_Flies.FliesOn)
end

function RicksMLC_Flies.ShowOtherPlayersFlies()
    if isClient() then
        local requestFliesStatusFromServer = false
        local players = getOnlinePlayers()
        local droppedPlayerList = {}
        for k, _ in pairs(RicksMLC_Flies.currentFliesSquareList) do
            droppedPlayerList[k] = true
        end
        for playerNum=0, players:size()-1 do
            local player = players:get(playerNum)
            -- Remove each found player from the droppedPlayerList.  Any remaining are dropped.
            if droppedPlayerList[player:getOnlineID()] then droppedPlayerList[player:getOnlineID()] = nil end
            if player ~= getPlayer() then
                if RicksMLC_Flies.currentFliesSquareList[player:getOnlineID()] == nil then
                    DebugLog.log(DebugType.Mod, "RicksMLC_Flies.ShowOtherPlayersFlies() New player detected - request flies from server")
                    requestFliesStatusFromServer = true
                else
                    RicksMLC_Flies.UpdateFlies(player, player:getOnlineID(), RicksMLC_Flies.currentFliesSquareList[player:getOnlineID()]:HasFlies())
                end
            end
        end
        for k, remove in pairs(droppedPlayerList) do
            if RicksMLC_Flies.currentFliesSquareList[k] then
                RicksMLC_Flies.currentFliesSquareList[k]:SetHasFliesSafely(false)
            end
            RicksMLC_Flies.currentFliesSquareList[k] = nil
        end
        if requestFliesStatusFromServer then
            sendClientCommand("RicksMLC_FliesServer", "CurrentPlayersFlies", args)
        end
    end
end

-- Use the first minute in-game to get the flies status of all other players.
function RicksMLC_Flies.FirstEveryOneMinute()
    if isClient() or not isServer() then -- ie: is a MP client or stand-alone
        RicksMLC_Flies.currentFliesSquareList[getPlayer():getOnlineID()] = FliesInfo:new(getPlayer():getCurrentSquare())
        RicksMLC_Flies.UpdateMyFlies()
    end
    if isClient() then
        sendClientCommand("RicksMLC_FliesServer", "CurrentPlayersFlies", args)
    end
    Events.EveryOneMinute.Remove(RicksMLC_Flies.FirstEveryOneMinute)
    Events.EveryOneMinute.Add(RicksMLC_Flies.EveryOneMinute)
end

-- Note: I tried making every other minute, but it looked wrong with the delay of the flies moving tiles
function RicksMLC_Flies.EveryOneMinute()
    if getPlayer():isAsleep() then return end

    if isClient() or not isServer() then -- ie: is a MP client or stand-alone
        RicksMLC_Flies.UpdateMyFlies()
        RicksMLC_Flies.ShowOtherPlayersFlies()
    end
end

function RicksMLC_Flies.OnCreatePlayer(playerIndex, player)
    RicksMLC_Flies.ClearAllFliesFromList()
    local onlineId = player:getOnlineID()
    DebugLog.log(DebugType.Mod, "RicksMLC_Flies.OnCreatePlayer OnlineId: '" .. tostring(onlineId) .. "'")
    RicksMLC_Flies.currentFliesSquareList[player:getOnlineID()] = FliesInfo:new(player:getCurrentSquare())
end

function RicksMLC_Flies.OnConnected()
	-- Request the flies status of all existing players.
    sendClientCommand("RicksMLC_FliesServer", "CurrentPlayersFlies", args)    
end

function RicksMLC_Flies.OnKeyPressed(key)
    if key == Keyboard.KEY_F10 then
        RicksMLC_Flies.ToggleVolumeAdjustment()
    end
end

Events.OnCreatePlayer.Add(RicksMLC_Flies.OnCreatePlayer)
Events.EveryOneMinute.Add(RicksMLC_Flies.FirstEveryOneMinute)
Events.OnServerCommand.Add(RicksMLC_Flies.HandleServerSmellUpdate)
--Events.OnKeyPressed.Add(RicksMLC_Flies.OnKeyPressed)