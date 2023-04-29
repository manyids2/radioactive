local ui = require("radioactive.ui")
local div = require("radioactive.widgets.div")
local button = require("radioactive.widgets.button")

local function increment(components)
	local c = components.count_label
	local count = c.data.count
	count = count + 1
	c.data.count = count
	c.state.text = { tostring(count) }
end

local function decrement(components)
	local c = components.count_label
	local count = c.data.count
	count = count - 1
	c.data.count = count
	c.state.text = { tostring(count) }
end

-- Need to setup children before init
local count_label = div.setup({
	id = "count_label",
	text = { "1" },
	data = { count = 1 },
})

local buttons = button.setup({
	id = "buttons",
	text = { "", "    +       ", "", "    -       " },
	keys = {
		increment = {
			"n",
			"<up>",
			increment,
			{ "count_label" },
		},
		decrement = {
			"n",
			"<down>",
			decrement,
			{ "count_label" },
		},
	},
	rect = { col = 0.4, row = 0.5, width = 13, height = 5, zindex = 500 },
})

return {
	id = "counter",
	class = "counter",
	children = { count_label, buttons },
	state = { count = 0 },
	init = ui.init_children,
	is_dirty = ui.is_dirty_children,
	render = ui.render_children,
}
