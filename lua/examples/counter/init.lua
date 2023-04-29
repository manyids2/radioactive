local ui = require("radioactive.ui")
local div = require("radioactive.widgets.div")
local button = require("radioactive.widgets.button")

local function increment(components)
	local text = components.count_label.state.text
	text = { tostring(tonumber(text[1]) + 1) }
	components.count_label.state.text = text
end

local function decrement(components)
	local text = components.count_label.state.text
	text = { tostring(tonumber(text[1]) - 1) }
	components.count_label.state.text = text
end

-- Need to setup children before init
local count_label = div.setup({
	id = "count_label",
	text = { "1" },
	rect = { col = 10, row = 5, width = 20, height = 5 },
})

local inc_button = button.setup({
	id = "inc_button",
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
	rect = { col = 10, row = 15, width = 13, height = 5 },
})

return {
	id = "counter",
	class = "counter",
	children = { count_label, inc_button },
	state = { count = 0 },
	init = ui.init_children,
	is_dirty = ui.is_dirty_children,
	render = ui.render_children,
}
