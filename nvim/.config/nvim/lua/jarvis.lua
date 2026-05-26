-- ~/.config/nvim/lua/jarvis.lua
local M = {}

function M.refactor()
	-- Native visual selection extraction
	local _, srow, scol, _ = unpack(vim.fn.getpos("v"))
	local _, erow, ecol, _ = unpack(vim.fn.getpos("."))
	if srow > erow then
		srow, erow = erow, srow
	end

	local lines = vim.api.nvim_buf_get_lines(0, srow - 1, erow, false)
	local current_code = table.concat(lines, "\n")

	-- Drop down Neovim's native input prompt via dressing.nvim
	vim.ui.input({ prompt = "Jarvis Directive: " }, function(input)
		if not input or input == "" then
			return
		end

		-- Spawn a sleek floating window for status
		local buf = vim.api.nvim_create_buf(false, true)
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, { " [ SYSTEM: AWAITING DEEPSEEK-R1 ] " })

		-- Use a dark, minimal aesthetic with a purple border (hooks into Catppuccin if active)
		local win = vim.api.nvim_open_win(buf, false, {
			relative = "cursor",
			row = 1,
			col = 0,
			width = 36,
			height = 1,
			style = "minimal",
			border = "single",
			borderhl = "DiagnosticVirtualTextHint",
		})

		local system_prompt =
			"You are a minimalist, expert coding agent. Output ONLY the raw code replacement inside your answer block. Do not include markdown blocks, explanations, or commentary."
		local user_prompt = string.format("Context:\n%s\n\nInstruction: %s", current_code, input)

		local payload = vim.fn.json_encode({
			model = "deepseek-r1:14b",
			messages = {
				{ role = "system", content = system_prompt },
				{ role = "user", content = user_prompt },
			},
			stream = false,
		})

		-- High-performance asynchronous system call
		vim.system({
			"curl",
			"-s",
			"-X",
			"POST",
			"http://localhost:11434/api/chat",
			"-H",
			"Content-Type: application/json",
			"-d",
			payload,
		}, { text = true }, function(obj)
			vim.schedule(function()
				-- Clean up the floating status window
				if vim.api.nvim_win_is_valid(win) then
					vim.api.nvim_win_close(win, true)
				end

				if obj.code ~= 0 or not obj.stdout then
					print("Jarvis: Error connecting to local node.")
					return
				end

				local success, decoded = pcall(vim.fn.json_decode, obj.stdout)
				if not success or not decoded.message or not decoded.message.content then
					print("Jarvis: Error decoding JSON payload.")
					return
				end

				local response = decoded.message.content

				-- Strip out R1's thinking tags and formatting
				local clean_code = response:gsub("<think>.-</think>", ""):gsub("^%s*(.-)%s*$", "%1")
				local result_lines = {}
				for line in string.gmatch(clean_code, "[^\r\n]+") do
					table.insert(result_lines, line)
				end

				-- Inject the refactored code
				vim.api.nvim_buf_set_lines(0, srow - 1, erow, false, result_lines)
			end)
		end)
	end)
end

function M.setup()
	vim.keymap.set("v", "<leader>jr", M.refactor, { desc = "Refactor Selection" })
end

return M
