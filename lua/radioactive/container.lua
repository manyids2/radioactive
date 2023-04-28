local api = vim.api
local ui = require("radioactive.ui")
local layout = require("radioactive.layout")

local M = {}

M.default_config = {
	id = "container",
	class = "container",
	text = "container",
	rect = { col = 10, row = 5, width = 20, height = 5 },
}

M.config = {}
M.state = {
	window = nil,
	buffer = nil,
	text = nil,
	rect = nil,
	dirty = true,
}

function M.setup(config)
	M.config = ui.validate_config(config, M.default_config)
	return M
end

function M.init()
	-- Component specific
	M.state.text = M.config.text
	M.state.rect = M.config.rect

	-- window, create new buffer
	local wb = layout.create_win(M.config.rect)
	if (not wb.buffer) or not wb.window then
		return
	end
	M.state.buffer = wb.buffer
	M.state.window = wb.window
end

function M.is_dirty()
	return M.state.dirty
end

function M.render()
  print("Rendering container")
	if M.state.dirty then
		ui.set_lines(M.state.buffer, M.state.text)
		api.nvim_win_set_buf(M.state.window, M.state.buffer)
		M.state.dirty = false
	end
end

function M.destroy()
	print("Destroying container")
	api.nvim_win_close(M.state.window, true)
	api.nvim_buf_delete(M.state.buffer, { force = true })
end

return M
