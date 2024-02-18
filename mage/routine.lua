local Unlocker, awful, project = ...
local mage = project.mage.aoe
local player = awful.player
local settings = project.settings

print("Zmizet AoE Dungeon Mage")

mage:Init(function()


--Just anytime.
    Intellect(player)
    FrostShield(player)
    Evocation(player)


    --Polymorph player
    if target.player then
        if player.mana > 30 then
            Polymorph()
        end
    end

-- AoE Rotation    
    if settings.AoE then
        if target.enemy then
            if player.mana > 30 then
                livingbomb()
            end
            if player.mana > 50 then
                LivingFlame()
            end
        end
    end



-- Single target Rotation
    if settings.Single then
        if target.enemy then
            if player.mana > 30 then
                Pyroblast()
            end
            if player.mana > 50 then
                Scorch()
            end
            if player.mana > 50 then
                Combustion()
            end
            if player.mana > 50 then
                Shoot()
            end
        end
    end

end)
