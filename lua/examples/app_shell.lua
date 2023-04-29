local ui = require("radioactive.ui")
local appshell = require("radioactive.widgets.appshell")

return {
	id = "appshell",
	class = "appshell",
	children = { appshell.setup({}) },
	state = { count = 0 },
	init = ui.init_children,
	is_dirty = ui.is_dirty_children,
	render = ui.render_children,
}
