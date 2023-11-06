-- RicksMLC_StashDebug.lua

require "DebugUIs/StashDebug.lua"

local overrideStashDebugOnClick = StashDebug.onClick

StashDebug.onClick = function(self, button)
    if button.internal ~= "SPAWN" then
        overrideStashDebugOnClick(self, button)
        return
    end
    if self.selectedStash then
        local map = InventoryItemFactory.CreateItem(self.selectedStash:getItem());
        StashSystem.doStashItem(self.selectedStash, map);
        getPlayer():getInventory():AddItem(map);
        local mapUI = ISMap:new(0, 0, 0, 0, map, 0);
        map:doBuildingStash();
        -- Removed to disable teleportation to the map location.
        -- getPlayer():setX(self.selectedStash:getBuildingX() + 20);
        -- getPlayer():setY(self.selectedStash:getBuildingY() + 20);
        -- getPlayer():setLx(self.selectedStash:getBuildingX() + 20);
        -- getPlayer():setLy(self.selectedStash:getBuildingY() + 20);
        self:populateList();
    end
end

