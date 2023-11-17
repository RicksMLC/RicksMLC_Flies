-- RicksMLC_FliesTest.lua

RicksMLC_FliesTest = {}

function RicksMLC_FliesTest.HandleServerSmellUpdate(module, command, args)
    if module == "RicksMLC_Flies" and command == "UpdateSmellFromServer" then
        RicksMLC_SharedUtils.DumpArgs(args, 1, "RicksMLC Test Flies server smell args")
    end
end

local testList = {}
function RicksMLC_FliesTest.OnKeyPressed(key)
	if key == Keyboard.KEY_F10 then
        testList[0] = true
        testList[1] = false
        testList[4] = true
        RicksMLC_SharedUtils.DumpArgs(testList, 1, "Test List")
        local playerFliesList = {}
        for onlineId, status in pairs(testList) do
            playerFliesList[#playerFliesList+1] = {FliesOn = status, OnlineId = onlineId}
        end
        RicksMLC_SharedUtils.DumpArgs(playerFliesList, 1, "playerFliesList List")
    end
end

Events.OnKeyPressed.Add(RicksMLC_FliesTest.OnKeyPressed)
Events.OnServerCommand.Add(RicksMLC_FliesTest.HandleServerSmellUpdate)