-- RicksMLC_FliesModOptions.lua
-- Mod options for the Flies mod:
--  [+] Sound volme slider

RicksMLC_FliesModOptions = {
    options = nil,
    earDamageOption = nil
}

function RicksMLC_FliesModOptions:init()
    DebugLog.log(DebugType.Mod, "RicksMLC_FliesModOptions.init()")
    self.options = PZAPI.ModOptions:create("RicksMLC_FliesModOptions", "Rick's MLC Flies")
    self.volumeOption = self.options:addSlider("0", getText("UI_RicksMLCFlies_Options_Volume"), 0, 11, 0.1, 1.5, getText("UI_RicksMLCFlies_Options_Volume_Tooltip"))
end

function RicksMLC_FliesModOptions:GetFliesSoundVolume()
    return self.volumeOption:getValue()
end

RicksMLC_FliesModOptions:init()