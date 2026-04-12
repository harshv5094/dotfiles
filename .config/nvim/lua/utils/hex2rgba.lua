-- NOTE:
-- Source: https://github.com/austinwilcox/hex2rgba/blob/main/lua/hex2rgba/init.lua

local M = {}

function M.Set()
	local r, c = unpack(vim.api.nvim_win_get_cursor(0))
	local lines = vim.api.nvim_buf_get_lines(0, r - 1, r, false)
	local line = unpack(lines)
	local hexCodeStartIndex = string.find(line, "#%x%x%x%x%x")
	local length = 6
	if hexCodeStartIndex == nil then
		hexCodeStartIndex = string.find(line, "#%x%x%x")
		length = 3
		if hexCodeStartIndex == nil then
			return ""
		end
	end
	local hexCode = string.sub(line, hexCodeStartIndex, hexCodeStartIndex + length)
	local rgba = Get(hexCode)
	vim.api.nvim_buf_set_text(0, r - 1, hexCodeStartIndex - 1, r - 1, hexCodeStartIndex + hexCode:len() - 1, { rgba })
	return ""
end

function Get(hex)
	local hexWithoutPound = hex:gsub("#", "")
	local red, green, blue
	if hexWithoutPound:len() == 3 then
		red = tonumber("0x" .. hexWithoutPound:sub(1, 1)) * 17
		green = tonumber("0x" .. hexWithoutPound:sub(2, 2)) * 17
		blue = tonumber("0x" .. hexWithoutPound:sub(3, 3)) * 17
	else
		red = tonumber("0x" .. hexWithoutPound:sub(1, 2))
		green = tonumber("0x" .. hexWithoutPound:sub(3, 4))
		blue = tonumber("0x" .. hexWithoutPound:sub(5, 6))
	end
	local rgba = "rgba(" .. tostring(red) .. "," .. tostring(green) .. "," .. blue .. ",1.0)"

	return rgba
end

return M
