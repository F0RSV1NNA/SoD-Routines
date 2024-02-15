local Unlocker, awful, project = ...
local mage = project.mage.aoe
local player = awful.player

print("Zmizet AoE Dungeon Mage")

mage:Init(function()

    Intellect(player)
    FrostShield(player)
    Evocation(player)

    if target.enemy then
        if player.mana > 30 then
            livingbomb()
        end
        if player.mana > 50 then
            LivingFlame()
        end
        --FrostNova()
        --Shoot()
    end


end)
