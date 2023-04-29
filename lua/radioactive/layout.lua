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
	local size = M.get_width_height()
	if rect.col < 1 then
		rect.col = math.ceil(size.width * rect.col)
	end
	if rect.row < 1 then
		rect.row = math.ceil(size.height * rect.row)
	end
	if rect.height < 1 then
		rect.height = math.ceil(size.height * rect.height)
	end
	if rect.width < 1 then
		rect.width = math.ceil(size.width * rect.width)
	end

  if rect.zindex == nil then
    rect.zindex = 10
  end

	local opts = {
		relative = "editor",
		col = rect.col,
		row = rect.row,
		width = rect.width,
		height = rect.height,
		zindex = rect.zindex,
		style = "minimal",
	}
	local window = vim.api.nvim_open_win(buffer, true, opts)
	return { window = window, buffer = buffer }
end

return M
