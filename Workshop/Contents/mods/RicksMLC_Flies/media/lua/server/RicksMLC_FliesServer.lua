-- RicksMLC_FliesServer.lua
-- Handles the client smell update to forward to all clients.

if not isServer() then return end

RicksMLC_FliesServer = {}

RicksMLC_FliesServer.CurrentFliesStatus = {}

function RicksMLC_FliesServer.HandleClientSmellUpdate(module, command, player, args)
    if module == "RicksMLC_FliesServer" then
        if command == "UpdateSmell" then
            --DebugLog.log(DebugType.Mod, "RicksMLC_FliesServer.HandleClientSmellUpdate() Update Smell")
            RicksMLC_FliesServer.CurrentFliesStatus[args.OnlineId] = args.FliesOn    
            --RicksMLC_SharedUtils.DumpArgs(RicksMLC_FliesServer.CurrentFliesStatus, 0, "Server Current Flies Status")
        elseif command == "CurrentPlayersFlies" then
            --DebugLog.log(DebugType.Mod, "RicksMLC_FliesServer.HandleClientSmellUpdate() request CurrentPlayersFlies")
        end
        if RicksMLC_FliesServer.CurrentFliesStatus ~= {} then
            local retArgs = {PlayerFliesList = RicksMLC_FliesServer.CurrentFliesStatus}
            sendServerCommand("RicksMLC_Flies", "UpdateSmellFromServer", retArgs)
            RicksMLC_SharedUtils.DumpArgs(retArgs, 0, "RicksMLC_Flies: UpdateSmellFromServer retArgs")
        else
            --DebugLog.log(DebugType.Mod, "RicksMLC_FliesServer.HandleClientSmellUpdate: No current flies status - not sending reply")
        end
    end
end

Events.OnClientCommand.Add(RicksMLC_FliesServer.HandleClientSmellUpdate)