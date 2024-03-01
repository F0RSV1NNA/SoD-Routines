local Unlocker, awful, project = ...

awful.DevMode = true

project.p = {}
project.p.s = awful.Actor:New({ spec = 5, class = "priest" })