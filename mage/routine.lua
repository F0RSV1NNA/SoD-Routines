local Unlocker, awful, project = ...
local mage = project.mage.aoe
local player = awful.player

print("Zmizet AoE Dungeon Mage")

mage:Init(function()

    --buff's whenever you dont have them.
    Intellect(player)
    FrostShield(player)


    if target.enemy then
        if player.mana > 30 then
            livingbomb()
        end
        if player.mana > 50 then
            LivingFlame()
        end
        if player.mana > 20 then
            Evocation()
        end
        FrostNova()
        Shoot()
    end


end) -- Fixed the missing 'end' and removed the extra ')' symbol
