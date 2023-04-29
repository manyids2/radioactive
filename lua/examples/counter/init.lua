local ui = require("radioactive.ui")
local div = require("radioactive.widgets.div")
local button = require("radioactive.widgets.button")

local function increment()
	return function()
		local c = ui.get_component("count_label")
		if c == nil then
			return
		end
		c.state.text[1] = tostring(tonumber(c.state.text[1]) + 1)
		c.state.dirty = true
		c:render()
	end
end

local function decrement()
	return function()
		local c = ui.get_component("count_label")
		if c == nil then
			return
		end
		c.state.text[1] = tostring(tonumber(c.state.text[1]) - 1)
		c.state.dirty = true
		c:render()
	end
end

-- Need to setup children before init
local count_label = div.setup({
	id = "count_label",
	text = { "1" },
	rect = { col = 10, row = 5, width = 20, height = 5 },
})

local inc_button = button.setup({
	id = "inc_button",
	text = {"+ -> <up>", "- -> <down>"},
	keys = {
		increment = {
			"n",
			"<up>",
			increment,
			{ desc = "increment" },
		},
		decrement = {
			"n",
			"<down>",
			decrement,
			{ desc = "decrement" },
		},
	},
	rect = { col = 10, row = 15, width = 20, height = 5 },
})

local M = {
	id = "counter",
	class = "counter",
	children = { count_label, inc_button },
	state = { count = 0 },
	setup = function()
		count_label:init()
		inc_button:init()
	end,
	init = function()
		count_label:init()
		inc_button:init()
	end,
	is_dirty = function()
		return (count_label:is_dirty() and inc_button:is_dirty())
	end,
	render = function()
		count_label:render()
		inc_button:render()
	end,
}

return M
