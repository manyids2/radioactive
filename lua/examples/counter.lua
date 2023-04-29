local button = require("radioactive.widgets.button")

local buttons_id = "buttons"
local buttons = button.setup({
	id = buttons_id,
	data = { count = 0 },
	rect = { col = 0.1, row = 0.3, width = 0.8, height = 0.4, zindex = 500 },
	style = { align_vertical = "center", align_horizontal = "center" },
	format_lines = function(self)
		self.state.text = {
			"█   j   😸   k   █",
			"",
			string.format("%3s", self.data.count),
			"",
			"" .. string.rep("██", math.abs(math.ceil(self.data.count))) .. "",
		}
	end,
	keys = {
		increment = {
			"n",
			"j",
			function(components)
				local c = components.buttons
				c.data.count = math.min(10, c.data.count + 1)
			end,
			{ buttons_id },
		},
		decrement = {
			"n",
			"k",
			function(components)
				local c = components.buttons
				c.data.count = math.max(-10, c.data.count - 1)
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
