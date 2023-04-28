local api = vim.api
local ui = require("radioactive.ui")
local layout = require("radioactive.layout")

local M = {}

local default_config = {
	id = "container",
	class = "container",
	text = "container",
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

	return {
		config = vconfig,
		state = state,
		init = M.init,
		is_dirty = M.is_dirty,
		render = M.render,
		destroy = M.destroy,
	}
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
end

function M.is_dirty(self)
	return self.state.dirty
end

function M.render(self)
	print("Rendering container")
	if self.state.dirty then
		ui.set_lines(self.state.buffer, self.state.text)
		api.nvim_win_set_buf(self.state.window, self.state.buffer)
		self.state.dirty = false
	end
end

function M.destroy(self)
	print("Destroying container")
	api.nvim_win_close(self.state.window, true)
	api.nvim_buf_delete(self.state.buffer, { force = true })
end

return M
