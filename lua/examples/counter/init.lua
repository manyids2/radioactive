local boxA = require("radioactive.container").setup({
	id = "boxA",
	text = { "Box A" },
	rect = { col = 10, row = 5, width = 20, height = 5 },
})
local boxB = require("radioactive.container").setup({
	id = "boxB",
	text = { "Box B" },
	rect = { col = 10, row = 15, width = 20, height = 5 },
})

local M = {
	id = "counter",
	class = "counter",
	children = { boxA, boxB },
	init = function()
		boxA.init()
		boxB.init()
	end,
	is_dirty = function()
		return (boxA.is_dirty() and boxB.is_dirty())
	end,
	render = function()
		boxA.render()
		boxB.render()
	end,
}

return M
