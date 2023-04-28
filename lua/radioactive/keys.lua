local M = {}

-- keymaps
function M.map(buf, mode, lhs, rhs, opts)
	opts = opts or {}
	opts.silent = opts.silent ~= false
	vim.api.nvim_buf_set_keymap(buf, mode, lhs, rhs, opts)
end

function M.global_map(mode, lhs, rhs, opts)
	opts = opts or {}
	opts.silent = opts.silent ~= false
	vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
end

-- from config
function M.set_global_keys(keys)
	M.global_map("n", keys.help, ":echo 'help'<cr>", { desc = "Help" })
	M.global_map("n", keys.quit, "<cmd>qa<cr>", { desc = "Quit" })
end

return M
