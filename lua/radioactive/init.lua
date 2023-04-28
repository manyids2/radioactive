local M = {}

function M.setup(config)
  M.ui = require("radioactive.ui")
	M.ui.init(config)
end

return M
