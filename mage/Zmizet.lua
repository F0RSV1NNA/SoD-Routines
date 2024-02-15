local Unlocker, awful, project = ...

awful.DevMode = true

project.mage = {}
project.mage.aoe = awful.Actor:New({ spec = 2, class = "mage" })