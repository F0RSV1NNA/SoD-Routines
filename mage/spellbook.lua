local Unlocker, awful, project = ...
local aoe = project.mage.aoe
local player = awful.player
local Spell = awful.Spell

awful.Populate({
    Intellect = Spell(1460,{beneficial = true, castByID = true, ignoreChanneling = false}),
    FrostShield = Spell(7301,{beneficial = true, castByID = true, ignoreChanneling = false}),
    Evocation = Spell(12051,{castByID = true, ignoreChanneling = false}),
    --cc
    FrostNova = Spell(865,{castByID = true, ranged = true, ignoreChanneling = false}),
    Polymorph = Spell(12824,{castByID = true, ranged = true, ignoreChanneling = false}),
    --AoE
    LivingFlame = Spell(401556,{castByID = true, ranged = true, ignoreChanneling = false}),
    livingbomb = Spell(400613,{castByID = true, ranged = true, ignoreChanneling = false}),
    --DMG
    Pyroblast = Spell(11366,{castByID = true, ranged = true, ignoreChanneling = false}),
    Scorch = Spell(2948,{castByID = true, ranged = true, ignoreChanneling = false}),
    Combustion = Spell(400613,{castByID = true, ranged = true, ignoreChanneling = false}),
    Shoot = Spell(5019,{castByID = true, ranged = true, targeted = true, ignoreChanneling = false})
}, aoe, getfenv(1))



local targetedEnemies = {}


awful.onEvent(function()
    targetedEnemies = {}
end, "PLAYER_REGEN_ENABLED")


awful.onEvent(function(info, event, source, dest)
    if event ~= "SPELL_AURA_APPLIED" then return end
    if not source.isUnit(player) then return end
    local _, _, _, _, _, _, _, _, _, _, _, _, spellName = unpack(info)
    if spellName == livingbomb.name then
        targetedEnemies[dest.guid] = true
    end
end)



--AOE

livingbomb:Callback(function(spell)
    if player.manapct > 30 then
        awful.enemies.loop(function(unit, i, uptime)
            if targetedEnemies[unit.guid] then return end 
            if not spell:Castable(unit) then return end
            if unit.hp <= 50 then return end
            if unit.debuff(spell.id) then return end
            if spell:Cast(unit) then
                return true
            end
        end)
    end
end)


LivingFlame:Callback(function(spell)
    if not spell:Castable(player) then return end
    if player.manapct > 50 then
        local function sort(a, b) return a.hp > b.hp end
        awful.enemies.sort(sort).loop(function(unit, i, uptime)
            if unit.hp <= 60 then return end
            if not spell:Castable(unit) then return end
            if spell:Cast(unit) then
                return true
            end
        end)
    end
end)

--PvP
FrostNova:Callback(function(spell)
    if awful.enemies.around(player, 5, function(enemy) return enemy.isPlayer end) >= 1 then
        spell:Cast()
    end
end)

Polymorph:Callback(function(spell)
    if awful.enemies.find(function(enemy) return enemy.debuff(spell.id, player) end) then return end
    awful.enemies.loop(function(unit)
        if unit.inCombat then return end
        if unit.debuff(spell.id) then return end
        if not spell:Castable(unit) then return end
        if unit.hp <= 40 then return end
        if spell:Cast(unit) then
            return true
        end
    end)
end)



--damage filler spells


Pyroblast:Callback(function(spell) --needs improvement, would help if i ever saw pyroblast proc.
    if not spell:Castable(player) then return end
    --[[if player.buff(spell.name) then
        if spell:Cast(target) then
            return true
        end
    end]]
    if player.manapct > 30 then
    if not target.inCombat then return end    
        if spell:Cast(unit) then
            return true
        end
    end
end)


Scorch:Callback(function(spell)
    if player.manapct > 10 then
    if not target.inCombat then return end
        if target.debuffRemains(22959) < 30 then
            for i = 1, 5 do
                if target.debuffStacks(22959) < 5 then
                    spell:Cast(unit)
                else
                    if target.debuffRemains(22959) < 3 then
                        spell:Cast(unit)
                    end
                    return
                end
            end
        end
    end
end)

Combustion:Callback(function(spell)
    if player.manapct > 50 then
    if not target.inCombat then return end
        if spell:Cast() then
            return true
        end
    end
end)

Shoot:Callback(function(spell)
    if player.manapct > 5 then
    if not target.inCombat then return end
        if not spell.current then
            spell:Cast()
        end
    end
end)






--buffs 

Intellect:Callback(function(spell)
    if not player.buff(spell.name) then
    if not spell:Castable(player) then return end
        if spell:Cast(player) then
            return true
        end
    end
end)

FrostShield:Callback(function(spell)
    if not player.buff(spell.name) then
    if not spell:Castable(player) then return end
        if spell:Cast(player) then
            return true
        end
    end
end)

Evocation:Callback(function(spell)
    if player.manapct < 10 then
    if not spell:Castable(player) then return end
        if spell:Cast() then
            return true
        end
    end
end)

