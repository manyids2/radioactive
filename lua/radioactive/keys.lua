local M = {}

-- keymaps
function M.buf_map(buffer, mode, lhs, callback, desc)
	vim.keymap.set(mode, lhs, callback, { silent = true, desc = desc, buffer = buffer })
end

function M.global_map(mode, lhs, rhs, opts)
	opts = opts or {}
	opts.silent = opts.silent ~= false
	vim.keymap.set(mode, lhs, rhs, opts)
end

-- from config
function M.set_global_keys(keys)
	M.global_map("n", keys.help, ":echo 'help'<cr>", { desc = "Help" })
	M.global_map("n", keys.quit, "<cmd>qa<cr>", { desc = "Quit" })

	M.global_map("n", "<leader>us", function()
		print("Toggle Spelling")
	end, { desc = "Toggle Spelling" })
end

return M
