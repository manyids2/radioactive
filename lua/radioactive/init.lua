local if_nil = vim.F.if_nil

local M = {}
M.ui = require("radioactive.ui")

function M.setup(config)
	if not config then
		config = {}
	end
	local default_config = {
		theme = "catppuccin-latte",
		keys = {
			help = "<C-space>",
			quit = "q",
		},
	}
	vim.validate({ config = { config, "table" } })
	config.opts = vim.tbl_extend("keep", if_nil(config.opts, {}), default_config)

	-- start the app
	M.ui.init(config)
end

return M
