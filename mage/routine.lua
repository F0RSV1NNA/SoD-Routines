local Unlocker, awful, project = ...
local mage = project.mage.aoe
local player = awful.player
local settings = project.settings
local player, target = awful.player, awful.target

print("[|cffFF6B33Zmizet|r AoE |cff3FC7EBMage|r]")

mage:Init(function()
    if player.mounted then return end 
    if player.casting or player.channeling then return end

    --beneficial
    Intellect()
    FrostShield()
    Evocation()



    --PvP Scenerio

    if target.player then
        FrostNova()
        Polymorph()
        Pyroblast()
        Scorch()
        livingbomb()
    end


    -- AoE Rotation

    if settings.AoE then
        if target.enemy then
            livingbomb()
            LivingFlame()
        end
    end


    -- Single target Rotation

    if not settings.AoE then
        if target.enemy then
            Pyroblast()
            Scorch()
            --Combustion()
            Shoot()
        end
    end

end)
