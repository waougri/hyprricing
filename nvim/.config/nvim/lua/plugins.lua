local add = MiniDeps.add

add({
	source = "nvim-treesitter/nvim-treesitter",
	checkout = "master",
	monitor = "main",
	hooks = {
		post_checkout = function()
			vim.cmd("TSUpdate")
		end,
	},
})

require("nvim-treesitter.configs").setup({
	ensure_installed = { "lua", "vimdoc" },
	highlight = { enable = true },
})

add("williamboman/mason.nvim")

add({
	source = "nvim-mini/mini.pairs",
	checkout = "stable",
})
require("mini.pairs").setup({
	-- disable neighbor deletion if it's annoying
	mappings = {
		["("] = { action = "open", pair = "()", neigh_pattern = "[^\\]." },
		["["] = { action = "open", pair = "[]", neigh_pattern = "[^\\]." },
		["{"] = { action = "open", pair = "{}", neigh_pattern = "[^\\]." },
		-- Set 'delete = false' if you want to stop the auto-deleting behavior
		["backspace"] = { action = "delete", pair = "()", neigh_pattern = "[^\\]." },
	},
})

add("nvim-mini/mini.surround")
require("mini.surround").setup()

add("echasnovski/mini.animate")
require("mini.animate").setup()

add("echasnovski/mini.cursorword")
require("mini.cursorword").setup()

add("echasnovski/mini.indentscope")
require("mini.indentscope").setup()

add("echasnovski/mini.trailspace")
require("mini.trailspace").setup()

add("echasnovski/mini.colors")
require("mini.colors").setup()

add("echasnovski/mini.hipatterns")
require("mini.hipatterns").setup()

add("echasnovski/mini.hues")
require("mini.hues").setup({
	background = "#000000",
	foreground = "#d5c8e1",
	accent = "purple",
})

add("echasnovski/mini.icons")
require("mini.icons").setup()

add("echasnovski/mini.notify")
require("mini.notify").setup()

add("echasnovski/mini.starter")
require("mini.starter").setup()

add("echasnovski/mini.statusline")
require("mini.statusline").setup()

add("echasnovski/mini.tabline")
require("mini.tabline").setup()

add("nvim-mini/mini.files")
require("mini.files").setup()

add({
	source = "neovim/nvim-lspconfig",
	depends = { "williamboman/mason.nvim" },
})

add({ source = "mason-org/mason-lspconfig.nvim" })
require("mason").setup()
require("mason-lspconfig").setup({ automatic_enable = true })

MiniDeps.add({
	source = "saghen/blink.cmp",
	depends = { "rafamadriz/friendly-snippets" },
	checkout = "main",
})

require("blink.cmp").setup({
	keymap = { preset = "enter" },
	appearance = { nerd_font_variant = "mono" },
	sources = { default = {
		"lsp",
		"path",
		"snippets",
		"buffer",
	} },
	signature = { enabled = true },
	fuzzy = { implementation = "prefer_rust" },
	completion = { documentation = { auto_show = true } },
})

add("echasnovski/mini.pick")
require("mini.pick").setup()

add("echasnovski/mini.extra")
require("mini.extra").setup()

add("folke/which-key.nvim")
require("which-key").setup()

add("MysticalDevil/inlay-hints.nvim")
require("inlay-hints").setup()

add("stevearc/conform.nvim")
add("zapling/mason-conform.nvim")

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "black", "isort" },
		rust = { "rustfmt", lsp_format = "fallback" },
		c = { "clang-format" },
		cpp = { "clang-format" },
		javascript = { "prettier", stop_after_first = true },
		typescript = { "prettier", stop_after_first = true },
		json = {}, -- disabled: prettier mangles indentation on save
	},
})

require("mason-conform").setup()

local pick = require("mini.pick")
local extra = require("mini.extra")

vim.keymap.set("n", "<leader>ff", function()
	pick.builtin.files()
end, { desc = "Find Files" })

vim.keymap.set("n", "<leader>fg", function()
	pick.builtin.grep_live()
end, { desc = "Grep Search" })

vim.keymap.set("n", "<leader>fs", function()
	extra.pickers.lsp({ scope = "document_symbol" })
end, { desc = "Find Symbols" })

vim.keymap.set("n", "gr", function()
	extra.pickers.lsp({ scope = "references" })
end, { desc = "Go to References" })

vim.keymap.set("n", "gd", function()
	extra.pickers.lsp({ scope = "definition" })
end, { desc = "Go to Definition" })

local capabilities = require("blink.cmp").get_lsp_capabilities()

vim.lsp.handlers["workspace/diagnostic/refresh"] = function()
	return true
end

local ih = require("inlay-hints")

local function setup_server(name, opts)
	local config = vim.tbl_deep_extend("force", {
		capabilities = capabilities,
		on_attach = function(client, bufnr)
			ih.on_attach(client, bufnr)
		end,
	}, opts)
	vim.lsp.config(name, config)
	vim.lsp.enable(name)
end

setup_server("pyright", {
	cmd = { "/home/starlith/.npm-packages/bin/pyright-langserver", "--stdio" },
})

setup_server("qmlls", {
	cmd = { "/usr/sbin/qmlls6" },
	settings = {
		settings = {
			qml = {
				hint = {
					enable = true, -- Enables inlay hints
				},
			},
		},
	},
})

setup_server("lua_ls", {
	cmd = { "/usr/sbin/lua-language-server" },
	settings = {
		Lua = { hint = { enable = true } },
	},
})

setup_server("clangd", {
	cmd = { vim.fn.exepath("clangd") },
	settings = {
		clangd = {
			InlayHints = {
				Enabled = true,
				ParameterNames = true,
				DeducedTypes = true,
				Designators = true,
			},
		},
	},
})

setup_server("rust_analyzer", {
	cmd = { vim.fn.exepath("rust_analyzer") },
	settings = {
		["rust-analyzer"] = {
			inlayHints = {
				chainingHints = { enable = true },
				closingBraceHints = { enable = true, minLines = 25 },
				parameterHints = { enable = true },
				typeHints = { enable = true },
			},
		},
	},
})

setup_server("vtsls", {
	cmd = { vim.fn.exepath("vtsls"), "--stdio" },
	settings = {
		typescript = {
			inlayHints = {
				includeInlayParameterNameHints = "all",
				includeInlayFunctionParameterTypeHints = true,
				includeInlayVariableTypeHints = true,
				includeInlayFunctionLikeReturnTypeHints = true,
				includeInlayEnumMemberValueHints = true,
			},
		},
		javascript = {
			inlayHints = {
				includeInlayParameterNameHints = "all",
				includeInlayFunctionParameterTypeHints = true,
				includeInlayVariableTypeHints = true,
				includeInlayFunctionLikeReturnTypeHints = true,
				includeInlayEnumMemberValueHints = true,
			},
		},
	},
})
