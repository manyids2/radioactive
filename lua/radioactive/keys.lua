local M = {}

-- keymaps
function M.map(buf, mode, lhs, rhs, opts)
	opts = opts or {}
	opts.silent = opts.silent ~= false
	vim.api.nvim_buf_set_keymap(buf, mode, lhs, rhs, opts)
end

-- from config
function M.set_default_keys(keys, state)
	local buf = state.buffer
	M.map(buf, "n", keys.help, ":echo 'help'<cr>", { desc = "Help" })
	M.map(buf, "n", keys.quit, "<cmd>qa<cr>", { desc = "Quit" })
end

return M