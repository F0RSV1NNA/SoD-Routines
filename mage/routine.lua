local Unlocker, awful, project = ...
local mage = project.mage.aoe
local player = awful.player
local settings = project.settings
local target = awful.target

print("Zmizet AoE Dungeon Mage")

mage:Init(function()
   
    if player.channeling or awful.time - project.EvoCasted < 0.5 then return end

    --beneficial
    Intellect()
    FrostShield()
    Evocation()



    --PvP Scenerio

    if target.player then
        FrostNova()
        Polymorph()
        --Pyroblast()
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
            --Pyroblast()
            Scorch()
            --Combustion()
            --Shoot()
        end
    end

end)
