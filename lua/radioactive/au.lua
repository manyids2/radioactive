local M = {}

function M.augroup(name)
	return vim.api.nvim_create_augroup("radioactive_" .. name, { clear = true })
end

function M.buf_au(name, event)
	vim.api.nvim_create_autocmd({ event }, {
		group = M.augroup(name),
		callback = function(e)
			print(string.format("event fired: %s", vim.inspect(e)))
		end,
	})
end

return M
