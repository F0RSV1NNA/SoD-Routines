local Unlocker, awful, project = ...
local shadow = project.p.s
local settings = project.settings
local player, target = awful.player, awful.target

print("[|cffFF6B33Zmizet|r  |cff3FC7EBPriest|r]")

shadow:Init(function()

    local channeling = ChannelInfo()

    if player.mounted then return end 
    if channeling then return end
    
    --beneficial
    fort()
    shield()


    --PvP Scenerio

    if target.player then
        scream()
    end


    -- AoE Rotation

    if settings.AoE then
        if target.enemy then
            --livingbomb()
           -- LivingFlame()
        end
    end


    -- Single target Rotation

    if not settings.AoE then
        if target.enemy then
            pain()
            voidplague()
            smite()
            penance()
        end
    end

end)
