local M = {}

function M.setup(config)
  M.ui = require("radioactive.ui")
	M.ui.setup(config)
	M.ui.init()
end

return M
