local Unlocker, awful, project = ...


local gui, settings, cmd = awful.UI:New("example", {
	title = "Example GUI",
	show = true,
	colors = {
		title = {245, 235, 55, 1},
		primary = {255, 255, 255, 1},
		accent = {245, 235, 55, 1},
		background = {21, 21, 21, 0.45}
	}
})

local example = gui:Tab("Example")
example:Button({
	text = "Enable",
	var = "enable",
	icon = icon.id,
	default = true
})

example:Button({
	text = "AOE",
	var = "aoe",
	icon = icon.id,
	default = true
})
