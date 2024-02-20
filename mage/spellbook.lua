local Unlocker, awful, project = ...
local aoe = project.mage.aoe
local player = awful.player
local Spell = awful.Spell

awful.Populate({
    Intellect = Spell(1460,{beneficial = true, castByID = true}),
    FrostShield = Spell(7301,{beneficial = true, castByID = true}),
    Evocation = Spell(12051,{castByID = true}),
    --cc
    FrostNova = Spell(865,{castByID = true, ranged = true}),
    Polymorph = Spell(12824,{castByID = true, ranged = true}),
    --AoE
    LivingFlame = Spell(401556,{castByID = true, ranged = true}),
    livingbomb = Spell(400613,{castByID = true, ranged = true}),
    --DMG
    wand = awful.Spell(5019,{castByID = true, ranged = true}),
    Pyroblast = Spell(11366,{castByID = true, ranged = true}),
    Scorch = Spell(2948,{castByID = true, ranged = true}),
    Combustion = Spell(400613,{castByID = true, ranged = true}),
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
            if spell:Cast(unit) then
                return true
            end
        end)
    end
end)


--PvP
FrostNova:Callback(function(spell)
    if player.manapct > 20 then
        if not spell:Castable(unit) then return end
        if awful.enemies.around(player, 5, function(enemy) return enemy.isPlayer end) >= 1 then
            spell:Cast()
        end
    end
end)

Polymorph:Callback(function(spell)
    if player.castingid == Polymorph.id then return end -- Try adding this and see if it's enough to stop it from happening, if not, we go advanced
    if awful.enemies.find(function(enemy) return enemy.debuff(spell.id, player) end) then return end
    awful.enemies.loop(function(unit)
        if unit.Combat then return end
        if unit.debuff(spell.id) then return end
        if not spell:Castable(player) then return end
        if unit.hp <= 40 then return end
        if spell:Cast(unit) then
            return true
        end
    end)
end)


--damage spells

Pyroblast:Callback(function(spell) --needs improvement, would help if i ever saw pyroblast proc.
    if not spell:Castable(player) then return end
    if player.buff(400625) then
        if spell:Cast(unit) then
            return true
        end
    end
    if player.manapct > 30 then
    if not target.inCombat then return end    
        if spell:Cast(unit) then
            return true
        end
    end
end)

Scorch:Callback(function(spell)
    if player.manapct > 10 then
        if target.inCombat then
            if target.debuffStacks(22959) < 5 then
                spell:Cast(target)
            elseif target.debuffStacks(22959) == 5 then
                if target.debuffRemains(22959) < 8 then
                    spell:Cast(target)
                end
            end
        end
    end
end)

Combustion:Callback(function(spell)
    if player.manapct > 50 then
    if not spell:Castable(player) then return end
    if not target.inCombat then return end
        if spell:Cast() then
            return true
        end
    end
end)

wand:Callback(function(spell)
    if not target.enemy or target.dead or player.moving or IsAutoRepeatSpell(spell.name) then return end
    spell:Cast(target)
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

project.EvoCasted = 0
Evocation:Callback(function(spell)
    if player.manapct < 10 then
    if not spell:Castable(player) then return end
        if spell:Cast() then
            project.EvoCasted = awful.time
            return true
        end
    end
end)

