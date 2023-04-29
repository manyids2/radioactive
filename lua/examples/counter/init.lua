local button = require("radioactive.widgets.button")

local buttons_id = "buttons"
local buttons = button.setup({
	id = buttons_id,
	data = { count = 1 },
	rect = { col = 0.3, row = 0.4, width = 0.4, height = 3, zindex = 500 },
	style = { align_vertical = "center", align_horizontal = "center" },
	format_lines = function(self)
		self.state.text = { string.format("██    😸 %3s    ██", self.data.count) }
	end,
	keys = {
		increment = {
			"n",
			"<up>",
			function(components)
				local c = components.buttons
				c.data.count = c.data.count + 1
			end,
			{ buttons_id },
		},
		decrement = {
			"n",
			"<down>",
			function(components)
				local c = components.buttons
				c.data.count = c.data.count - 1
			end,
			{ buttons_id },
		},
	},
})

return {
	id = "counter",
	class = "counter",
	children = { buttons },
	state = { count = 0 },
}
