-- Clone 'mini.nvim' manually in a way that it gets managed by 'mini.deps'
local path_package = vim.fn.stdpath("data") .. "/site/"
local mini_path = path_package .. "pack/deps/start/mini.nvim"
if not vim.loop.fs_stat(mini_path) then
	vim.cmd('echo "Installing [`mini.nvim`](../doc/mini-nvim.qmd#mini.nvim)" | redraw')
	local clone_cmd = {
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/nvim-mini/mini.nvim",
		mini_path,
	}
	vim.fn.system(clone_cmd)
	vim.cmd("packadd mini.nvim | helptags ALL")
	vim.cmd('echo "Installed [`mini.nvim`](../doc/mini-nvim.qmd#mini.nvim)" | redraw')
end

-- Set up 'mini.deps' (customize to your liking)
require("mini.deps").setup({ path = { package = path_package } })
require("plugins")

vim.cmd.colorscheme("gentoo")
vim.cmd.syntax("on")
vim.wo.relativenumber = true
vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop = 2
vim.opt_local.expandtab = true
-- Hide the default statusline and use a single global one
vim.opt.laststatus = 3
vim.opt.cmdheight = 0
-- Optioddnal: Hide the mode (NORMAL, INSERT, etc.) since mini.statusline shows it
vim.opt.showmode = false
vim.g.mapleader = " "

vim.keymap.set("n", "<leader>e", function()
	require("mini.files").open()
end, { desc = "Open Mini FIles" })
vim.keymap.set("n", "<C-x>", ":bd<CR>", { desc = "Kill current buffer" })

vim.diagnostic.config({ virtual_text = true })
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
-- Optional: Apply to other areas
vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })

local ih = require("inlay-hints")
vim.keymap.set("n", "<leader>ti", function()
	ih.toggle()
end, { desc = "Toggle Inlay Hints" })

vim.keymap.set("n", "]d", function()
	vim.diagnostic.goto_next()
end, { desc = "Next Diagnostic" })
vim.keymap.set("n", "[d", function()
	vim.diagnostic.goto_prev()
end, { desc = "Prev Diagnostic" })

-- Errors only (skips warnings/hints)
vim.keymap.set("n", "]e", function()
	vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
end, { desc = "Next Error" })
vim.keymap.set("n", "[e", function()
	vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
end, { desc = "Prev Error" })

-- Current file
vim.keymap.set("n", "<leader>fd", function()
	extra.pickers.diagnostic({ scope = "current" })
end, { desc = "File Diagnostics" })

-- Project-wide
vim.keymap.set("n", "<leader>fD", function()
	extra.pickers.diagnostic({ scope = "all" })
end, { desc = "Project Diagnostics" })

vim.keymap.set("n", "<C-e>", function()
	vim.diagnostic.open_float()
end, { desc = "Show Diagnostic" })

vim.keymap.set({ "n", "v" }, "<leader>cf", function()
	require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "Format buffer" })

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		require("conform").format({ bufnr = args.buf })
	end,
})
