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
    --cc
    FrostNova = Spell(865,{castByID = true, ranged = true }),
    Polymorph = Spell(12824,{castByID = true, ranged = true }),
    --AoE
    LivingFlame = Spell(401556,{castByID = true, ranged = true }),
    livingbomb = Spell(400613,{castByID = true, ranged = true }),
    Blizzard = Spell(10,{castByID = true, ranged = true }),
    --DMG
    Pyroblast = Spell(11366,{castByID = true, ranged = true }),
    Scorch = Spell(2948,{castByID = true, ranged = true }),
    Combustion = Spell(400613,{castByID = true, ranged = true }),
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

--Logic for casting Living Flame spell on enemies

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

--Root enemies with Frost Nova spell

FrostNova:Callback(function(spell) 
    if awful.enemies.around(player, 5, player.meleeRangeOf(player)) >= 2 then -- this shit broke
        spell:Cast()
    end
end)

Polymorph:Callback(function(spell) -- needs a ton more logic/improvement to be useful against players.
    awful.enemies.loop(function(enemy)
        if spell:Cast(enemy, {face = true}) then
            return true
        end
    end)
end)


--damage filler spells



Pyroblast:Callback(function(spell) --improve this. its shit...i think.
    if not spell:Castable(player) then return end
    --[[if player.buff(spell.name) then
        if spell:Cast(target) then
            return true
        end
    end]]
    if player.manapct > 30 then
        if spell:Cast(target) then
            return true
        end
    end
end)


Scorch:Callback(function(spell)
    if player.manapct > 10 then
        for i = 1, 5 do -- cast 5 times?
            if not spell:Cast(target) then
                return
            end
        end
    end
end)


Combustion:Callback(function(spell)
    if player.manapct > 50 then
        if spell:Cast() then
            return true
        end
    end
end)

Shoot:Callback(function(spell)
    if player.manapct > 5 then
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
    if not spell:Castable(player) then return end
    if player.manapct < 5 then
        if spell:Cast() then
            return true
        end
    end
end)
