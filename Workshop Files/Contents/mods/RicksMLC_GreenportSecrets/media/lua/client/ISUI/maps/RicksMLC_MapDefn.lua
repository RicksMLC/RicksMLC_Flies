-- RicksMLC_MapDefn.lua
-- Map definitions while the NoMiS Greenport mod does not have this.

require "ISUI/Maps/ISMapDefinitions"
require "RicksMLC_GreenportSecretsUtils"
----------------------------------
-- Copied from client/ISUI/Maps/ISMapDefinitions.lua
local MINZ = 0
local MAXZ = 24

local WATER_TEXTURE = false

local function replaceWaterStyle(mapUI)
	if not WATER_TEXTURE then return end
	local mapAPI = mapUI.javaObject:getAPIv1()
	local styleAPI = mapAPI:getStyleAPI()
	local layer = styleAPI:getLayerByName("water")
	if not layer then return end
	layer:setMinZoom(MINZ)
	layer:setFilter("water", "river")
	layer:removeAllFill()
	layer:removeAllTexture()
	layer:addFill(MINZ, 59, 141, 149, 255)
	layer:addFill(MAXZ, 59, 141, 149, 255)
end
local function overlayPNG(mapUI, x, y, scale, layerName, tex, alpha)
	local texture = getTexture(tex)
	if not texture then return end
	local mapAPI = mapUI.javaObject:getAPIv1()
	local styleAPI = mapAPI:getStyleAPI()
	local layer = styleAPI:newTextureLayer(layerName)
	layer:setMinZoom(MINZ)
	layer:addFill(MINZ, 255, 255, 255, (alpha or 1.0) * 255)
	layer:addTexture(MINZ, tex)
	layer:setBoundsInSquares(x, y, x + texture:getWidth() * scale, y + texture:getHeight() * scale)
end
--------------------------------------

LootMaps.Init.RicksMLCGreenportMap = function(mapUI)
    local mapAPI = mapUI.javaObject:getAPIv1()
	MapUtils.initDirectoryMapData(mapUI, 'media/maps/Greenport')
	MapUtils.initDefaultStyleV1(mapUI)
	replaceWaterStyle(mapUI)
    -- Get from the Debug Map Editor -> Bounds -> Draw New Bounds -> Lua to Clipboard
    mapAPI:setBoundsInSquares(8100, 7310, 8699, 7799)
	--overlayPNG(mapUI, 10868, 7314, 0.666, "badge", "media/textures/worldMap/WestPointBadge.png")
    overlayPNG(mapUI, 8500, 7320, 0.333, "legend", "media/textures/worldMap/Legend.png")
	MapUtils.overlayPaper(mapUI)
end

