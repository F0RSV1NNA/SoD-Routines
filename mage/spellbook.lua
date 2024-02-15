-- Initialize necessary variables and objects for the spellbook
local Unlocker, awful, project = ...
local aoe = project.mage.aoe
local player = awful.player
local Spell = awful.Spell

-- Populate the spellbook with spells and their configurations
awful.Populate({
    Intellect = Spell(1460,{beneficial = true, castByID = true }),
    FrostShield = Spell(7301,{beneficial = true, castByID = true }),
    Evocation = Spell(12051,{castByID = true }),
    FrostNova = Spell(865,{castByID = true, ranged = true }),
    LivingFlame = Spell(401556,{castByID = true, ranged = true }),
    livingbomb = Spell(400613,{castByID = true, ranged = true }),
    Shoot = Spell(5019,{castByID = true, ranged = true, targeted = true})
}, aoe, getfenv(1))


--Table of enemies that have been targeted and living bomb applied to.

local targetedEnemies = {}

--Reset the table of targeted enemies when out of combat

awful.onEvent(function()
    targetedEnemies = {}
end, "PLAYER_REGEN_ENABLED")

--Add enemies with living bomb applied to the targetedEnemies table

awful.onEvent(function(info, event, source, dest)
    if event ~= "SPELL_AURA_APPLIED" then return end
    if not source.isUnit(player) then return end
    local _, _, _, _, _, _, _, _, _, _, _, _, spellName = unpack(info)
    if spellName == livingbomb.name then
        targetedEnemies[dest.guid] = true
    end
end)

--Logic for casting Living Bomb spell on enemies

livingbomb:Callback(function(spell)
    if player.mana > 30 then
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

--Logic for casting Living Flame spell on enemies

LivingFlame:Callback(function(spell)
    if not spell:Castable(player) then return end
    if player.mana > 50 then
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

--Root enemies with Frost Nova spell

FrostNova:Callback(function(spell)
    if enemies.around(player, 5, enemy.meleeRangeOf(player)) >= 2 then
        spell:Cast()
    end
end)

--damage filler spells

Shoot:Callback(function(spell)
   if not spell.current then
        spell:Cast()
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
    if not spell:Castable(player) then return end
    if player.mana < 20 then
        spell:Cast()
    end
end)
