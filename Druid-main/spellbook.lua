local Unlocker, awful, project = ...
local resto = project.druid.resto
local player, target = awful.player, awful.target
local Spell = awful.Spell

awful.Populate({
    --buffs
    MarkOfWild = Spell(1126,{beneficial = true, castByID = true}),
    --AoE
    WildGrowth = Spell(48438, {heal = true, AoE = true, castByID = true}),
    --heals
    Lifebloom  = Spell(33763, {heal = true, castByID = true}),
    Regrowth = Spell(8936, {heal = true, castByID = true}),
    Swiftmend = Spell(18562, {heal = true, castByID = true}),
    Rejuvenation = Spell(774, {heal = true, castByID = true}),

}, resto, getfenv(1))

Rejuvenation:Callback(function(spell)
    if project.Lowest.hp < 95 then
    if not player.buff(spell.name) then
        if not spell:Castable(player) then return end
        if spell:Cast(project.Lowest) then
             return true
            end
        end
    end
end)

Lifebloom:Callback(function(spell)
    if project.Lowest.hp < 80 then
        if not player.buff(spell.name) then
            if not spell:Castable(player) then return end
            if spell:Cast(project.Lowest) then
                return true
            end
        end
    end
end)

Swiftmend:Callback(function(spell)
    if project.Lowest.hp < 80 then
        if player.buff(774) then
            if not spell:Castable(player) then return end
            if spell:Cast(project.Lowest) then
                return true
            end
        end
    end
end)

Regrowth:Callback(function(spell)
    if project.Lowest.hp < 70 then
        return spell:Cast(project.Lowest)
    end
end)



MarkOfWild:Callback(function(spell)
    if not player.Buff(1126) then
        return spell:Cast(player)
    end
end)

