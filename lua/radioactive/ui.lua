local api = vim.api
local keys = require("radioactive.keys")

local M = {}

M.self = M
M.config = {}
M.state = {}
M.default_config = {
	app = "radioactive.basic",
	theme = "catppuccin-latte",
	keys = {
		help = "<C-space>",
		quit = "q",
	},
	bufopts = { filetype = "markdown", modifiable = false },
}

function M.validate_config(config, default_config)
	if config == nil then
		config = default_config
	end
	vim.validate({ config = { config, "table" } })
	config = vim.tbl_extend("keep", config, default_config)
	return config
end

function M.set_lines(buffer, lines)
	api.nvim_buf_set_option(buffer, "modifiable", true)
	api.nvim_buf_set_lines(buffer, 0, -1, false, lines)
	api.nvim_buf_set_option(buffer, "modifiable", false)
end

function M.set_buf_options(buffer, opts)
	for key, value in pairs(opts) do
		api.nvim_buf_set_option(buffer, key, value)
	end
end

function M.render()
	-- reset dirty based on children
	for _, child in pairs(M.state.children) do
		if child.is_dirty() then
			child.render()
		end
	end
	if M.state.dirty then
		-- set title in markdown
		M.set_lines(M.state.buffer, { M.state.data.title })
		api.nvim_win_set_buf(M.state.window, M.state.buffer)
		M.state.dirty = false
	end
end

function M.setup(config)
	M.config = M.validate_config(config, M.default_config)
	return M
end

function M.init()
	-- Styling
	vim.cmd("colorscheme " .. M.config.theme)

	-- window, create new buffer
	local window = api.nvim_get_current_win()
	local buffer = api.nvim_create_buf(false, true)
	if (not buffer) or not window then
		return
	end

	-- state
	M.state = {
		id = "root",
		class = "root",
		buffer = buffer,
		window = window,
		children = {},
		dirty = true,
		data = { title = "# radioactive" },
	}

	-- set options, default to filetype markdown for title
	M.set_buf_options(buffer, M.config.bufopts)

	-- 'global' keys ( quit, help )
	keys.set_global_keys(M.config.keys)

	-- initialize children
	M.state.children = { require(M.config.app) }
	for _, child in pairs(M.state.children) do
		child.init()
	end

	-- render
	M.render()
end

return M
