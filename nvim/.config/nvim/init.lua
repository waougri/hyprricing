
-- Clone 'mini.nvim' manually in a way that it gets managed by 'mini.deps'
local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing [`mini.nvim`](../doc/mini-nvim.qmd#mini.nvim)" | redraw')
  local clone_cmd = {
    'git', 'clone', '--filter=blob:none',
    'https://github.com/nvim-mini/mini.nvim', mini_path
  }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echo "Installed [`mini.nvim`](../doc/mini-nvim.qmd#mini.nvim)" | redraw')
end

-- Set up 'mini.deps' (customize to your liking)
require('mini.deps').setup({ path = { package = path_package } })
require('plugins')


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
vim.g.mapleader = ' '

vim.keymap.set('n', '<leader>e', function() require('mini.files').open() end, {desc = 'Open Mini FIles'})
vim.diagnostic.config({ virtual_text = true })
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
-- Optional: Apply to other areas
vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })

