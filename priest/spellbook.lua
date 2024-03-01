local Unlocker, awful, project = ...
local p = project.p.s
local player, target = awful.player, awful.target
local Spell = awful.Spell

awful.Populate({
    shield = awful.Spell(17,{castByID = true}),
    fort = awful.Spell(1243,{beneficial = true, castByID = true}),
    --cc
    scream = Spell(865,{castByID = true, ranged = true}),
    --AoE

    --DMG
    penance = awful.Spell(402174,{castByID = true, ranged = true}),
    pain = awful.Spell(589,{castByID = true, ranged = true}),
    voidplague = awful.Spell(425204,{castByID = true, ranged = true}),
    smite = awful.Spell(591,{castByID = true, ranged = true}),
}, p, getfenv(1))


--[[
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
--]]




--PvP

scream:Callback(function(spell)
    if player.manapct > 20 then
        if not spell:Castable(unit) then return end
        if awful.enemies.around(player, 5, function(enemy) return enemy.isPlayer end) >= 1 then
            spell:Cast()
        end
    end
end)


--damage spells


pain:Callback(function(spell)
    if target.Combat then
        awful.enemies.loop(function(unit, i, uptime)
            if not spell:Castable(unit) then return end
            if unit.debuff(spell.id) then return end
            if spell:Cast(unit) then
                return true
            end
        end)
    end
end)

voidplague:Callback(function(spell)
    if target.Combat then
        awful.enemies.loop(function(unit, i, uptime)
            if not spell:Castable(unit) then return end
            if unit.debuff(spell.id) then return end
            if spell:Cast(unit) then
                return true
            end
        end)
    end
end)

smite:Callback(function(spell)
    if target.Combat then
        spell:Cast(target)
    end
end)

penance:Callback(function(spell)
    if target.Combat then
        spell:Cast(target)
    end
end)




--buffs 

fort:Callback(function(spell)
    if not player.buff(spell.name) then
    if not spell:Castable(player) then return end
        if spell:Cast() then
            return true
        end
    end
end)


shield:Callback(function(spell)
    if not player.Combat then return end
    if player.debuff(6788) then return end
    if player.hp > 80 then return end
    if not player.buff(spell.name) then
        if spell:Cast() then
            return true
        end
    end
end)

