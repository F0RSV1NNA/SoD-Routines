local Unlocker, awful, project = ...

awful.DevMode = true

project.priest = {}
project.priest.shadow = awful.Actor:New({ spec = 5, class = "priest" })