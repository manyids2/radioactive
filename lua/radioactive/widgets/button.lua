local api = vim.api
local ui = require("radioactive.ui")
local keys = require("radioactive.keys")
local layout = require("radioactive.layout")

local M = {}

function M.on_click(id)
	return function()
		for _, c in pairs(ui.state.components) do
			if c.id == id then
        local text = c.state.text
				if text[1] == "off" then
					text[1] = "on"
				else
					text[1] = "off"
				end
				c.state.dirty = true
				c:render()
			end
		end
	end
end

local default_config = {
	id = "button",
	class = "button",
	text = { "off" },
	keys = {
		click = {
			"n",
			"<enter>",
			M.on_click,
			{ desc = "click" },
		},
	},
	rect = { col = 10, row = 5, width = 20, height = 5 },
}

function M.setup(sconfig)
	local vconfig = ui.validate_config(sconfig, default_config)

	-- Need to copy dict properly
	local config = ui.shallow_copy(vconfig)
	config.rect = ui.shallow_copy(vconfig.rect)

	local state = {
		window = nil,
		buffer = nil,
		text = nil,
		rect = nil,
		dirty = true,
	}

	local button = {
		config = vconfig,
		id = vconfig.id,
		class = vconfig.class,
		keys = vconfig.keys,
		state = state,
		init = M.init,
		is_dirty = M.is_dirty,
		render = M.render,
		destroy = M.destroy,
	}

	return button
end

function M.init(self)
	-- Component specific
	self.state.text = self.config.text
	self.state.rect = self.config.rect

	-- window, create new buffer
	local wb = layout.create_win(self.config.rect)
	if (not wb.buffer) or not wb.window then
		return
	end
	self.state.buffer = wb.buffer
	self.state.window = wb.window

	-- attach event listener
	for desc, value in pairs(self.config.keys) do
		local mode = value[1]
		local lhs = value[2]
		local callback = value[3](self.config.id)
		keys.buf_map(self.state.buffer, mode, lhs, callback, desc)
	end

	-- keep record
	table.insert(ui.state.components, self)
end

function M.is_dirty(self)
	return self.state.dirty
end

function M.render(self)
	if self.state.dirty then
		ui.set_lines(self.state.buffer, self.state.text)
		api.nvim_win_set_buf(self.state.window, self.state.buffer)
		self.state.dirty = false
	end
end

function M.destroy(self)
	api.nvim_win_close(self.state.window, true)
	api.nvim_buf_delete(self.state.buffer, { force = true })
end

return M
