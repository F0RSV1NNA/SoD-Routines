local Unlocker, awful, project = ...
local mage = project.mage.aoe
local player = awful.player
local settings = project.settings
local target = awful.target

print("Zmizet AoE Dungeon Mage")

mage:Init(function()
   

--Just anytime.
    Intellect()
    FrostShield()
    Evocation()


 --Polymorph player & Frost nova players in melee range
    if target.player then
        if player.channeling then return end
        FrostNova()
        Polymorph()
        --Pyroblast()
        Scorch()
        livingbomb()
    end

-- AoE Rotation    
    if settings.AoE then
        if player.channeling then return end
        if target.enemy then
            if player.channeling then return end
            livingbomb()
            LivingFlame()
        end
    end



-- Single target Rotation
    if not settings.AoE then
        if player.channeling then return end
        if target.enemy then
            --Pyroblast()
            Scorch()
            --Combustion()
            --Shoot()
        end
    end

end)
