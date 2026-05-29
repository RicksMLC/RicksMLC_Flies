
--------------------------------------------------------------------------------
if getActivatedMods():contains("\\LifestyleHobbies") then
    require "Hygiene/HygieneNeed"

    local PlayerHygineStatus = {}
    PlayerHygineStatus.isDirty = false

    require "RicksMLC_Flies"

    function RicksMLC_Flies.CalculateFliesOnStatus()
        return PlayerHygineStatus.isDirty
    end

    local originalAdjustHygieneNeed = AdjustHygieneNeed
    function AdjustHygieneNeed(thisPlayer, playerData, bodyDamage, stats, currentBoredom, currentUnhappiness, currentStress)
        originalAdjustHygieneNeed(thisPlayer, playerData, bodyDamage, stats, currentBoredom, currentUnhappiness, currentStress)
        if playerData.LSMoodles["HygieneGood"].Value > 0 then 
            PlayerHygineStatus.isDirty = false
        end
        if playerData.LSMoodles["HygieneBad"].Value > 0 then 
            PlayerHygineStatus.isDirty = true
        end
    end
end