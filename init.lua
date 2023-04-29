-- bootstrap lazy.nvim
require("radioactive.bootstrap")

-- start app
local ui = require("radioactive.ui")
ui.setup({ app = "examples.counter" })
ui.init()
