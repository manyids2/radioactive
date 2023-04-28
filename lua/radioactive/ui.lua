local M = {}

M.self = M
M.config = {}
M.state = {}

local keys = require("radioactive.keys")
local api = vim.api

function M.render()
	if M.state.dirty then
		api.nvim_buf_set_option(M.state.buffer, "modifiable", true)
		api.nvim_buf_set_lines(M.state.buffer, -1, -1, false, M.state.loading.lines)
		api.nvim_buf_set_option(M.state.buffer, "modifiable", false)

		api.nvim_win_set_buf(M.state.window, M.state.buffer)
		api.nvim_win_set_cursor(M.state.window, { 2, 0 })
		M.state.dirty = false
	end
end

function M.init(config)
	M.config = config

	-- Extras
	vim.cmd("colorscheme " .. config.opts.theme)
	-- vim.cmd("ZenMode") -- messes up focus

	-- window, create new buffer
	local window = api.nvim_get_current_win()
	local buffer = api.nvim_create_buf(false, true)
	if (not buffer) or not window then
		return
	end

	-- set options
	api.nvim_buf_set_option(buffer, "filetype", "markdown")
	api.nvim_buf_set_option(buffer, "modifiable", false)

	-- state
	M.state = {
		loading = { lines = { "# radioactive" } },
		buffer = buffer,
		window = window,
		open = false,
		dirty = true,
	}

	-- keys
	keys.set_keys(M.config.opts.keys, M.state)

	-- events
	-- au.set_listeners(M.config.opts.listeners, M.state)

	-- render
	M.render()
end

return M
