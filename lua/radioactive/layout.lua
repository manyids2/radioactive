local M = {}

function M.get_width_height()
	local stats = vim.api.nvim_list_uis()[1]
	local width = stats.width
	local height = stats.height
	return { width = width, height = height }
end

function M.get_centre_rect(fraction)
	local size = M.get_width_height()
	local width = math.ceil(size.width * fraction)
	local height = math.ceil(size.height * fraction)
  local col = math.ceil((size.width - width) / 2)
	local row = math.ceil((size.height - height) / 2) - 1
	return { col = col, row = row, width = width, height = height }
end

function M.create_win(rect)
	local buffer = vim.api.nvim_create_buf(false, true)
	local opts = {
		relative = "editor",
		col = rect.col,
    row = rect.row,
		width = rect.width,
		height = rect.height,
		style = "minimal",
	}
	local window = vim.api.nvim_open_win(buffer, true, opts)
	return { window = window, buffer = buffer }
end

return M
