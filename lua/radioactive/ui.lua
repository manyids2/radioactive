local api = vim.api
local layout = require("radioactive.layout")
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
	init = M.init_children,
	is_dirty = M.is_dirty_children,
	render = M.render_children,
}

function M.shallow_copy(t)
	local t2 = {}
	for k, v in pairs(t) do
		t2[k] = v
	end
	return t2
end

function M.validate_config(config, default_config)
	if config == nil then
		config = default_config
	end
	vim.validate({ config = { config, "table" } })
	config = vim.tbl_extend("keep", config, default_config)

	return M.shallow_copy(config)
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

function M.get_components(ids)
	local components = {}
	for _, c in pairs(M.state.components) do
		if vim.tbl_contains(ids, c.id) then
			components[c.id] = c
		end
	end
	return components
end

function M.init_children(self)
	for _, c in pairs(self.children) do
		c:init()
	end
end

function M.is_dirty_children(self)
	local dirty = false
	for _, c in pairs(self.children) do
		dirty = dirty or c:is_dirty()
	end
	return dirty
end

function M.render_children(self)
	for _, c in pairs(self.children) do
		c:render()
	end
end

function M.render_only(components)
	for _, c in pairs(components) do
		c.state.dirty = true
		c:render()
	end
end

function M.apply_style(lines, rect, style)
	-- assuming style is center for now
	local lheight = vim.tbl_count(lines)
	local wwidth = rect.width
	local wheight = rect.height

	-- get top padding
	local tpad = math.ceil((wheight - lheight) / 2)
	local slines = {}
	for _ = 1, tpad, 1 do
		table.insert(slines, "")
	end

	-- get left and right padding
	for _, line in pairs(lines) do
		local lwidth = vim.api.nvim_strwidth(line)
		local lpad = math.ceil((wwidth - lwidth) / 2)
		local rpad = wwidth - lwidth - lpad
		local newline = string.rep(" ", lpad) .. line .. string.rep(" ", rpad)
		table.insert(slines, newline)
	end

	-- get bottom padding
	local bpad = wheight - lheight - tpad
	for _ = 1, bpad, 1 do
		table.insert(slines, "")
	end
	return slines
end

function M.format_lines()
	local size = layout.get_width_height()
	local wheight = size.height
	local lines = { M.state.data.title }
	for _ = 1, wheight - 2, 1 do
		table.insert(lines, "")
	end
	table.insert(lines, M.state.data.footer)
	M.state.text = lines
end

function M.render()
	for _, child in pairs(M.state.children) do
		child:render()
	end

	-- background
	if M.state.dirty then
		M.format_lines()
		M.set_lines(M.state.buffer, M.state.text)
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
		components = {},
		dirty = true,
		data = { title = "#  radioactive", footer = " <tab> to focus" },
	}

	-- set options, default to filetype markdown for title
	M.set_buf_options(buffer, M.config.bufopts)

	-- 'global' keys ( quit, help )
	keys.set_global_keys(M.config.keys)

	-- initialize app
	M.app = require(M.config.app)

	for _, method in ipairs({ "init", "is_dirty", "render" }) do
		if M.app[method] == nil then
			M.app[method] = M[method .. "_children"]
		end
	end

	M.state.children = { M.app }
	M.state.components = { M.app }
	for _, child in pairs(M.state.children) do
		child:init()
	end

	-- render
	M.render()
end

return M
