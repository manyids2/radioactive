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

function M.validate_config(config)
	if config == nil then
		config = M.default_config
	end
	vim.validate({ config = { config, "table" } })
	config = vim.tbl_extend("keep", config, M.default_config)
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
	for name, child in pairs(M.state.children) do
		print(name, vim.inspect(child))
	end
	if M.state.dirty then
		-- set title in markdown
		M.set_lines(M.state.buffer, { M.state.data.title })
		api.nvim_win_set_buf(M.state.window, M.state.buffer)
		M.state.dirty = false
	end
end

function M.init(config)
	M.config = M.validate_config(config)

	-- Styling
	vim.cmd("colorscheme " .. M.config.theme)

	-- window, create new buffer
	local window = api.nvim_get_current_win()
	local buffer = api.nvim_create_buf(false, true)
	if (not buffer) or not window then
		return
	end

	-- initialize children
	-- local children = M.init_child(config.child_module)

	-- state
	M.state = {
		name = "root",
		children = {},
		buffer = buffer,
		window = window,
		dirty = true,
		data = { title = "# radioactive" },
	}

	-- set options, default to filetype markdown for title
	M.set_buf_options(buffer, M.config.bufopts)

	-- 'global' keys ( quit, help )
	keys.set_default_keys(M.config.keys, M.state)

	-- render
	M.render()
end

return M
