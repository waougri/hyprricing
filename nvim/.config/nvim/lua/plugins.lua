-- =============================================================
--  plugins.lua  ·  MiniDeps-based config
--  Requirements: Neovim ≥ 0.11, MiniDeps bootstrapped in init.lua
--
--  LSP:         nvim-lspconfig ONLY (never mix with vim.lsp.config)
--  Git signs:   gitsigns ONLY (mini.diff removed)
--  Picker:      fzf-lua (replaces mini.pick — more powerful)
--  Indent:      indent-blankline v3 + mini.indentscope (static + animated)
--  Scroll:      neoscroll.nvim
--  HTML tags:   nvim-ts-autotag
--  Debug:       nvim-dap + nvim-dap-ui + mason-nvim-dap
--  Diff/merge:  diffview.nvim
-- =============================================================

local add = MiniDeps.add

-- ──────────────────────────────────────────────────────────────
-- HELPERS
-- ──────────────────────────────────────────────────────────────
local map = function(mode, lhs, rhs, desc)
	vim.keymap.set(mode, lhs, rhs, { desc = desc, silent = true, noremap = true })
end

-- ──────────────────────────────────────────────────────────────
-- 1. TREESITTER  +  AUTOTAG
-- ──────────────────────────────────────────────────────────────
add({
	source = "nvim-treesitter/nvim-treesitter",
	checkout = "master",
	hooks = {
		post_checkout = function()
			vim.cmd("TSUpdate")
		end,
	},
})
add("nvim-treesitter/nvim-treesitter-context")
add("windwp/nvim-ts-autotag") -- auto-rename matching HTML/JSX tags

require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"lua",
		"vimdoc",
		"rust",
		"typescript",
		"javascript",
		"tsx",
		"python",
		"svelte",
		"html",
		"css",
		"toml",
	},
	highlight = { enable = true },
	indent = { enable = true },
	autotag = { enable = true }, -- powered by nvim-ts-autotag
})

require("nvim-ts-autotag").setup({
	opts = {
		enable_rename = true,
		enable_close = true,
		enable_close_on_slash = true,
	},
})

require("treesitter-context").setup({
	max_lines = 3,
	trim_scope = "outer",
	mode = "cursor",
})

map("n", "[c", function()
	require("treesitter-context").go_to_context(vim.v.count1)
end, "Jump to Context")

-- ──────────────────────────────────────────────────────────────
-- 2. SMOOTH SCROLLING
-- ──────────────────────────────────────────────────────────────
add("karb94/neoscroll.nvim")
require("neoscroll").setup({
	mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "zt", "zz", "zb" },
	hide_cursor = false,
	stop_eof = true,
	duration_multiplier = 0.6, -- faster than default
	easing = "sine",
})

-- ──────────────────────────────────────────────────────────────
-- 3. MINI ECOSYSTEM
--    Excluded: mini.statusline, mini.tabline (lualine used)
--              mini.diff  (gitsigns conflict)
--              mini.pick  (fzf-lua used — more powerful)
--              mini.extra (fzf-lua has all LSP pickers built-in)
-- ──────────────────────────────────────────────────────────────
local function setup_mini(name, config)
	require("mini." .. name).setup(config or {})
end

setup_mini("tabline")

-- Theme FIRST
setup_mini("hues", {
	background = "#000000",
	foreground = "#d5c8e1",
	accent = "purple",
})
setup_mini("colors")
setup_mini("icons")

-- Editing
setup_mini("pairs", {
	mappings = {
		["("] = { action = "open", pair = "()", neigh_pattern = "[^\\]." },
		["["] = { action = "open", pair = "[]", neigh_pattern = "[^\\]." },
		["{"] = { action = "open", pair = "{}", neigh_pattern = "[^\\]." },
	},
})
setup_mini("surround")
setup_mini("trailspace")
setup_mini("cursorword")
setup_mini("animate")

-- UI
setup_mini("starter")
setup_mini("hipatterns")

-- Explorer
setup_mini("files")
map("n", "<leader>e", function()
	require("mini.files").open()
end, "Explorer")
map("n", "<leader>E", function()
	require("mini.files").open(vim.api.nvim_buf_get_name(0))
end, "Explorer (current file)")

-- ──────────────────────────────────────────────────────────────
-- 4. INDENT GUIDES  (ibl v3 for static lines + mini.indentscope
--    for the animated current-scope highlight — best of both)
-- ──────────────────────────────────────────────────────────────
add("lukas-reineke/indent-blankline.nvim")

require("ibl").setup({
	indent = {
		char = "│",
		tab_char = "│",
		highlight = "IblIndent",
	},
	scope = {
		enabled = true,
		highlight = "IblScope",
		show_start = false,
		show_end = false,
	},
	exclude = {
		filetypes = {
			"help",
			"dashboard",
			"ministarter",
			"MiniFiles",
			"toggleterm",
			"trouble",
			"lazy",
			"mason",
		},
	},
})

-- mini.indentscope draws the animated scope line on top of ibl's static ones
setup_mini("indentscope", {
	symbol = "│",
	options = { try_as_border = true },
	draw = {
		delay = 50,
		animation = require("mini.indentscope").gen_animation.quadratic({
			easing = "out",
			duration = 80,
			unit = "step",
		}),
	},
})

-- Disable mini.indentscope in non-code buffers
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "help", "ministarter", "MiniFiles", "toggleterm", "trouble", "mason" },
	callback = function()
		vim.b.miniindentscope_disable = true
	end,
})

-- ──────────────────────────────────────────────────────────────
-- 5. FZF-LUA  (replaces mini.pick — telescope-level power, faster)
-- ──────────────────────────────────────────────────────────────
add({ source = "ibhagwan/fzf-lua", depends = { "echasnovski/mini.icons" } })

require("fzf-lua").setup({
	"telescope", -- use telescope-style layout/keybinds as base preset
	winopts = {
		height = 0.85,
		width = 0.85,
		preview = { layout = "vertical", vertical = "up:45%" },
	},
	fzf_opts = {
		["--layout"] = "reverse",
		["--info"] = "inline",
	},
	keymap = {
		fzf = {
			["ctrl-q"] = "select-all+accept", -- send all to quickfix
		},
	},
})

local fzf = require("fzf-lua")

map("n", "<leader>ff", fzf.files, "Find Files")
map("n", "<leader>fg", fzf.live_grep, "Grep")
map("n", "<leader>fb", fzf.buffers, "Buffers")
map("n", "<leader>fh", fzf.help_tags, "Help Tags")
map("n", "<leader>fr", fzf.oldfiles, "Recent Files")
map("n", "<leader>f:", fzf.command_history, "Command History")
map("n", "<leader>fd", fzf.diagnostics_workspace, "Diagnostics")
map("n", "<leader>fk", fzf.keymaps, "Keymaps")
map("n", "<leader>fc", fzf.git_commits, "Git Commits")

-- ──────────────────────────────────────────────────────────────
-- 6. MASON
-- ──────────────────────────────────────────────────────────────
add("williamboman/mason.nvim")
add({ source = "neovim/nvim-lspconfig", depends = { "williamboman/mason.nvim" } })
add("mason-org/mason-lspconfig.nvim")

require("mason").setup()
require("mason-lspconfig").setup({ automatic_installation = true })

-- ──────────────────────────────────────────────────────────────
-- 7. COMPLETION  (blink.cmp)
-- ──────────────────────────────────────────────────────────────
add("saghen/blink.lib")
add({
	source = "saghen/blink.cmp",
	depends = { "saghen/blink.lib", "rafamadriz/friendly-snippets" },
	checkout = "main",
})

require("blink.cmp").setup({
	keymap = { preset = "enter" },
	appearance = { nerd_font_variant = "mono" },
	sources = { default = { "lsp", "path", "snippets", "buffer" } },
	signature = { enabled = true },
	fuzzy = { implementation = "prefer_rust" },
	completion = {
		documentation = { auto_show = true, auto_show_delay_ms = 200 },
		accept = { auto_brackets = { enabled = true } },
	},
})

local capabilities = require("blink.cmp").get_lsp_capabilities()

-- ──────────────────────────────────────────────────────────────
-- 8. LSP  (lspconfig only — never mix with vim.lsp.config/enable)
-- ──────────────────────────────────────────────────────────────
local lspconfig = require("lspconfig")

local function server(name, opts)
	local cfg = vim.tbl_deep_extend("force", { capabilities = capabilities }, opts or {})
	local bin = (cfg.cmd and cfg.cmd[1]) or name
	if vim.fn.executable(bin) == 0 then
		return
	end
	lspconfig[name].setup(cfg)
end

server("basedpyright")

server("lua_ls", {
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			workspace = { checkThirdParty = false, library = vim.api.nvim_get_runtime_file("", true) },
			hint = { enable = true },
			diagnostics = { globals = { "vim", "MiniDeps" } },
		},
	},
})

server("ts_ls", {
	settings = {
		typescript = {
			inlayHints = {
				includeInlayVariableTypeHints = true,
				includeInlayParameterNameHints = "all",
				includeInlayFunctionParameterTypeHints = true,
			},
		},
		javascript = {
			inlayHints = {
				includeInlayVariableTypeHints = true,
				includeInlayParameterNameHints = "all",
				includeInlayFunctionParameterTypeHints = true,
			},
		},
	},
})

server("kotlin_language_server")
server("svelte")

server("clangd", {
	cmd = {
		"clangd",
		"--background-index",
		"--clang-tidy",
		"--header-insertion=iwyu",
		"--completion-style=detailed",
		"--function-arg-placeholders",
		"--fallback-style=llvm",
	},
	settings = {
		clangd = {
			InlayHints = { Enabled = true, ParameterNames = true, DeducedTypes = true },
		},
	},
})

-- ──────────────────────────────────────────────────────────────
-- 9. RUST  (rustaceanvim — do NOT also call server("rust_analyzer"))
-- ──────────────────────────────────────────────────────────────
add("mrcjkb/rustaceanvim")

vim.g.rustaceanvim = {
	tools = { hover_actions = { auto_focus = true } },
	server = {
		capabilities = capabilities,
		settings = {
			["rust-analyzer"] = {
				inlayHints = { typeHints = { enable = true }, parameterHints = { enable = true } },
				check = { command = "clippy" },
				cargo = { allFeatures = true },
			},
		},
	},
}

map("n", "<leader>rr", "<cmd>RustLsp runnables<cr>", "Rust Runnables")
map("n", "<leader>rd", "<cmd>RustLsp debuggables<cr>", "Rust Debuggables")
map("n", "<leader>re", "<cmd>RustLsp expandMacro<cr>", "Expand Macro")
map("n", "<leader>rc", "<cmd>RustLsp openCargo<cr>", "Open Cargo.toml")
map("n", "<leader>rp", "<cmd>RustLsp parentModule<cr>", "Parent Module")
map("n", "<leader>rx", "<cmd>RustLsp explainError<cr>", "Explain Error")
map("n", "<leader>rR", "<cmd>RustLsp reloadWorkspace<cr>", "Reload Workspace")

-- ──────────────────────────────────────────────────────────────
-- 10. FORMATTING
-- ──────────────────────────────────────────────────────────────
add("stevearc/conform.nvim")
add("zapling/mason-conform.nvim")

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "ruff_format", "ruff_organize_imports" },
		rust = { "rustfmt" },
		javascript = { "prettierd", "prettier", stop_after_first = true },
		typescript = { "prettierd", "prettier", stop_after_first = true },
		svelte = { "prettierd", "prettier", stop_after_first = true },
	},
	format_on_save = { timeout_ms = 500, lsp_fallback = true },
})
require("mason-conform").setup()

-- ──────────────────────────────────────────────────────────────
-- 11. LSP KEYMAPS  (buffer-local via LspAttach)
--     Uses fzf-lua for all pickers
-- ──────────────────────────────────────────────────────────────
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local function bmap(mode, lhs, rhs, desc)
			vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf, desc = desc, silent = true, noremap = true })
		end

		bmap("n", "K", vim.lsp.buf.hover, "Hover Docs")
		bmap("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
		bmap("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
		bmap("n", "<leader>th", function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf }))
		end, "Toggle Inlay Hints")

		bmap("n", "gd", fzf.lsp_definitions, "Go to Definition")
		bmap("n", "gr", fzf.lsp_references, "References")
		bmap("n", "gi", fzf.lsp_implementations, "Implementation")
		bmap("n", "gt", fzf.lsp_typedefs, "Type Definition")
		bmap("n", "<leader>fs", fzf.lsp_document_symbols, "Doc Symbols")
		bmap("n", "<leader>fS", fzf.lsp_workspace_symbols, "WS Symbols")
	end,
})

-- ──────────────────────────────────────────────────────────────
-- 12. DIAGNOSTICS  (lsp_lines)
-- ──────────────────────────────────────────────────────────────
add("https://git.sr.ht/~whynothugo/lsp_lines.nvim")
require("lsp_lines").setup()

vim.diagnostic.config({
	virtual_text = false,
	virtual_lines = { only_current_line = true },
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
})

map("n", "]d", vim.diagnostic.goto_next, "Next Diagnostic")
map("n", "[d", vim.diagnostic.goto_prev, "Prev Diagnostic")
map("n", "<leader>tl", function()
	local lines = (vim.diagnostic.config() or {}).virtual_lines
	vim.diagnostic.config({
		virtual_lines = (type(lines) == "table" and lines.only_current_line) and true or { only_current_line = true },
	})
end, "Toggle Full/Inline Diagnostics")

-- ──────────────────────────────────────────────────────────────
-- 13. DAP  (Debug Adapter Protocol)
--     Adapters: codelldb (Rust/C++), debugpy (Python), js-debug (TS/JS)
-- ──────────────────────────────────────────────────────────────
add("jay-babu/mason-nvim-dap.nvim")
add("mfussenegger/nvim-dap")
add({ source = "rcarriga/nvim-dap-ui", depends = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } })
add("nvim-neotest/nvim-nio") -- required by dap-ui

local dap = require("dap")
local dapui = require("dapui")

require("mason-nvim-dap").setup({
	ensure_installed = { "codelldb", "python", "js" },
	automatic_installation = true,
	handlers = {}, -- let mason-nvim-dap handle default configs
})

dapui.setup({
	icons = { expanded = "", collapsed = "", current_frame = "" },
	layouts = {
		{
			elements = {
				{ id = "scopes", size = 0.40 },
				{ id = "breakpoints", size = 0.20 },
				{ id = "stacks", size = 0.20 },
				{ id = "watches", size = 0.20 },
			},
			size = 40,
			position = "left",
		},
		{
			elements = { { id = "repl", size = 0.5 }, { id = "console", size = 0.5 } },
			size = 12,
			position = "bottom",
		},
	},
})

-- Auto open/close dapui when session starts/ends
dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end

-- Python adapter  (mason installs debugpy at this path)
dap.adapters.python = {
	type = "executable",
	command = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python",
	args = { "-m", "debugpy.adapter" },
}
dap.configurations.python = {
	{
		type = "python",
		request = "launch",
		name = "Launch file",
		program = "${file}",
		pythonPath = function()
			return vim.fn.exepath("python3") or "python"
		end,
	},
}

-- Rust / C++ via codelldb
dap.adapters.codelldb = {
	type = "server",
	port = "${port}",
	executable = {
		command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
		args = { "--port", "${port}" },
	},
}
dap.configurations.rust = {
	{
		type = "codelldb",
		request = "launch",
		name = "Launch (codelldb)",
		program = function()
			return vim.fn.input("Binary: ", vim.fn.getcwd() .. "/target/debug/", "file")
		end,
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
	},
}
dap.configurations.c = dap.configurations.rust
dap.configurations.cpp = dap.configurations.rust

-- TypeScript / JavaScript via vscode-js-debug
dap.adapters["pwa-node"] = {
	type = "server",
	host = "localhost",
	port = "${port}",
	executable = {
		command = "node",
		args = {
			vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
			"${port}",
		},
	},
}

local js_config = {
	{
		type = "pwa-node",
		request = "launch",
		name = "Launch file",
		program = "${file}",
		cwd = "${workspaceFolder}",
	},
	{
		type = "pwa-node",
		request = "attach",
		name = "Attach to process",
		processId = require("dap.utils").pick_process,
		cwd = "${workspaceFolder}",
	},
}
dap.configurations.javascript = js_config
dap.configurations.typescript = js_config
dap.configurations.javascriptreact = js_config
dap.configurations.typescriptreact = js_config

-- DAP keymaps
map("n", "<leader>db", dap.toggle_breakpoint, "Toggle Breakpoint")
map("n", "<leader>dB", function()
	dap.set_breakpoint(vim.fn.input("Condition: "))
end, "Conditional Breakpoint")
map("n", "<leader>dc", dap.continue, "Continue / Start")
map("n", "<leader>dn", dap.step_over, "Step Over")
map("n", "<leader>di", dap.step_into, "Step Into")
map("n", "<leader>do", dap.step_out, "Step Out")
map("n", "<leader>dr", dap.repl.open, "REPL")
map("n", "<leader>dl", dap.run_last, "Run Last")
map("n", "<leader>dq", dap.terminate, "Terminate")
map("n", "<leader>du", dapui.toggle, "Toggle DAP UI")
map("n", "<leader>de", function()
	dapui.eval(nil, { enter = true })
end, "Eval Expression")

-- ──────────────────────────────────────────────────────────────
-- 14. GIT  (gitsigns only — no mini.diff)
-- ──────────────────────────────────────────────────────────────
add("lewis6991/gitsigns.nvim")
require("gitsigns").setup({
	current_line_blame = true,
	current_line_blame_opts = { delay = 500 },
	on_attach = function(bufnr)
		local gs = package.loaded.gitsigns
		local function bm(mode, l, r, desc)
			vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc, silent = true })
		end
		bm("n", "]h", gs.next_hunk, "Next Hunk")
		bm("n", "[h", gs.prev_hunk, "Prev Hunk")
		bm("n", "<leader>hs", gs.stage_hunk, "Stage Hunk")
		bm("n", "<leader>hr", gs.reset_hunk, "Reset Hunk")
		bm("n", "<leader>hp", gs.preview_hunk, "Preview Hunk")
		bm("n", "<leader>hb", gs.blame_line, "Blame Line")
		bm("n", "<leader>hd", gs.diffthis, "Diff This")
		bm("n", "<leader>hS", gs.stage_buffer, "Stage Buffer")
		bm("n", "<leader>hR", gs.reset_buffer, "Reset Buffer")
	end,
})

-- ──────────────────────────────────────────────────────────────
-- 15. DIFFVIEW
-- ──────────────────────────────────────────────────────────────
add({ source = "sindrets/diffview.nvim", depends = { "echasnovski/mini.icons" } })
require("diffview").setup({
	enhanced_diff_hl = true,
	view = {
		default = { layout = "diff2_horizontal" },
		merge_tool = {
			layout = "diff3_horizontal",
			disable_diagnostics = true,
		},
	},
	file_panel = { win_config = { width = 35 } },
})

map("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", "Diffview Open")
map("n", "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", "File History")
map("n", "<leader>gH", "<cmd>DiffviewFileHistory<cr>", "Branch History")
map("n", "<leader>gc", "<cmd>DiffviewClose<cr>", "Diffview Close")

-- ──────────────────────────────────────────────────────────────
-- 16. TROUBLE
-- ──────────────────────────────────────────────────────────────
add({ source = "folke/trouble.nvim", depends = { "echasnovski/mini.icons" } })
require("trouble").setup({ modes = { diagnostics = { auto_close = true } } })

-- Replace your trouble setup + maps with this:

require("trouble").setup({
	modes = {
		diagnostics = { auto_close = true },
		symbols = {
			auto_close = true,
			win = { position = "right", size = 0.3 },
		},
		-- todo mode must be declared explicitly in v3
		todo = {
			mode = "quickfix",
			filter = { range = true },
		},
	},
})

map("n", "<leader>xx", function()
	require("trouble").toggle("diagnostics")
end, "Diagnostics")

map("n", "<leader>xX", function()
	require("trouble").toggle({ mode = "diagnostics", filter = { buf = 0 } })
end, "Buffer Diagnostics")

map("n", "<leader>xs", function()
	require("trouble").toggle("symbols")
end, "Symbols")

map("n", "<leader>xt", function()
	require("trouble").toggle("todo")
end, "Todos")
-- ──────────────────────────────────────────────────────────────
-- 17. TODO COMMENTS
-- ──────────────────────────────────────────────────────────────
add("folke/todo-comments.nvim")
require("todo-comments").setup()

map("n", "]t", function()
	require("todo-comments").jump_next()
end, "Next Todo")
map("n", "[t", function()
	require("todo-comments").jump_prev()
end, "Prev Todo")

-- ──────────────────────────────────────────────────────────────
-- 18. FLASH
-- ──────────────────────────────────────────────────────────────
add("folke/flash.nvim")
require("flash").setup()

map({ "n", "x", "o" }, "s", function()
	require("flash").jump()
end, "Flash Jump")
map({ "n", "x", "o" }, "S", function()
	require("flash").treesitter()
end, "Flash Treesitter")
map("n", "gs", function()
	require("flash").jump({ search = { mode = "search" } })
end, "Flash Search")

-- ──────────────────────────────────────────────────────────────
-- 19. FOLDING  (nvim-ufo)
-- ──────────────────────────────────────────────────────────────
add("kevinhwang91/promise-async")
add({ source = "kevinhwang91/nvim-ufo", depends = { "kevinhwang91/promise-async" } })

vim.o.foldcolumn = "1"
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true

require("ufo").setup({
	provider_selector = function()
		return { "treesitter", "indent" }
	end,
})

map("n", "zR", require("ufo").openAllFolds, "Open All Folds")
map("n", "zM", require("ufo").closeAllFolds, "Close All Folds")
map("n", "zK", function()
	if not require("ufo").peekFoldedLinesUnderCursor() then
		vim.lsp.buf.hover()
	end
end, "Peek Fold / Hover")

-- ──────────────────────────────────────────────────────────────
-- 20. TERMINAL
-- ──────────────────────────────────────────────────────────────
add("akinsho/toggleterm.nvim")
require("toggleterm").setup({
	size = 20,
	open_mapping = [[<C-\>]],
	direction = "horizontal",
	shade_terminals = true,
})

map("t", "<Esc><Esc>", "<C-\\><C-n>", "Exit Terminal Mode")

-- ──────────────────────────────────────────────────────────────
-- 21. LUALINE
-- ──────────────────────────────────────────────────────────────
add("nvim-lualine/lualine.nvim")
require("lualine").setup({
	options = {
		theme = "auto",
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		globalstatus = true,
		disabled_filetypes = { statusline = { "ministarter", "MiniFiles" } },
	},
	sections = {
		lualine_a = { { "mode", icon = "" } },
		lualine_b = { { "branch", icon = "" }, "diff", "diagnostics" },
		lualine_c = { { "filename", path = 1, symbols = { modified = " ●", readonly = " " } } },
		lualine_x = {
			"encoding",
			"fileformat",
			{
				function()
					local clients = vim.lsp.get_clients({ bufnr = 0 })
					if #clients == 0 then
						return ""
					end
					return " "
						.. table.concat(
							vim.tbl_map(function(c)
								return c.name
							end, clients),
							", "
						)
				end,
				color = { fg = "#9d7cd8" },
			},
			-- Show DAP status in statusline
			{
				function()
					return require("dap").status()
				end,
				cond = function()
					return package.loaded["dap"] and require("dap").status() ~= ""
				end,
				color = { fg = "#e06c75" },
				icon = "",
			},
		},
		lualine_y = { "progress" },
		lualine_z = { { "location", icon = "" } },
	},
})

-- ──────────────────────────────────────────────────────────────
-- 22. DROPBAR
-- ──────────────────────────────────────────────────────────────
add("Bekaboo/dropbar.nvim")
require("dropbar").setup({
	icons = {
		kinds = { use_devicons = true },
		ui = { bar = { separator = "  " } },
	},
	bar = {
		sources = function(buf, _)
			local sources = require("dropbar.sources")
			local utils = require("dropbar.utils")
			if vim.bo[buf].buftype == "terminal" then
				return { sources.terminal }
			end
			return { sources.path, utils.source.fallback({ sources.lsp, sources.treesitter }) }
		end,
	},
})

-- ──────────────────────────────────────────────────────────────
-- 23. NOICE
-- ──────────────────────────────────────────────────────────────
add({ source = "folke/noice.nvim", depends = { "MunifTanjim/nui.nvim" } })
require("noice").setup({
	notify = { enabled = true },
	lsp = {
		override = {
			["vim.lsp.util.convert_input_to_markdown_lines"] = true,
			["vim.lsp.util.stylize_markdown"] = true,
		},
		hover = { enabled = false }, -- blink handles this
		signature = { enabled = false }, -- blink handles this
	},
	presets = {
		bottom_search = true,
		command_palette = true,
		long_message_to_split = true,
		inc_rename = true,
		lsp_doc_border = true,
	},
	routes = {
		{ filter = { event = "msg_show", find = "%d+L, %d+B" }, view = "mini" },
		{ filter = { event = "msg_show", find = "^%d+ change" }, view = "mini" },
		{ filter = { event = "msg_show", find = "written" }, view = "mini" },
	},
})

map("n", "<leader>fn", "<cmd>Noice history<cr>", "Notification History")
map("n", "<leader>nd", "<cmd>Noice dismiss<cr>", "Dismiss Notifications")

-- ──────────────────────────────────────────────────────────────
-- 24. WHICH-KEY
-- ──────────────────────────────────────────────────────────────
add("folke/which-key.nvim")
require("which-key").setup({
	preset = "modern",
	delay = 400,
	icons = { mappings = true },
	spec = {
		{ "<leader>f", group = "find" },
		{ "<leader>r", group = "rust/rename" },
		{ "<leader>x", group = "diagnostics" },
		{ "<leader>h", group = "git hunks" },
		{ "<leader>g", group = "git diff" },
		{ "<leader>b", group = "buffers" },
		{ "<leader>t", group = "toggles" },
		{ "<leader>n", group = "notifications" },
		{ "<leader>d", group = "debug" },
	},
})

-- ──────────────────────────────────────────────────────────────
-- 25. SCROLLBAR
-- ──────────────────────────────────────────────────────────────
add("lewis6991/satellite.nvim")
require("satellite").setup({
	current_only = true,
	handlers = {
		gitsigns = { enable = true },
		diagnostic = { enable = true },
	},
})

-- ──────────────────────────────────────────────────────────────
-- 26. SMEAR CURSOR
-- ──────────────────────────────────────────────────────────────
add("sphamba/smear-cursor.nvim")
require("smear_cursor").setup({
	cursor_color = "#9d7cd8",
	stiffness = 0.8,
	trailing_stiffness = 0.5,
	distance_stop_animating = 0.5,
})

-- ──────────────────────────────────────────────────────────────
-- 27. RENDER MARKDOWN
-- ──────────────────────────────────────────────────────────────
add({ source = "MeanderingProgrammer/render-markdown.nvim", depends = { "echasnovski/mini.icons" } })
require("render-markdown").setup({ file_types = { "markdown" } })

-- ──────────────────────────────────────────────────────────────
-- 28. COLORIZER
-- ──────────────────────────────────────────────────────────────
add("NvChad/nvim-colorizer.lua")
require("colorizer").setup({
	filetypes = { "css", "svelte", "typescript", "javascript", "lua", "html" },
	user_default_options = {
		RGB = true,
		RRGGBB = true,
		names = false,
		css = true,
		mode = "virtualtext",
		virtualtext = "■",
	},
})

-- ──────────────────────────────────────────────────────────────
-- 29. DRESSING
-- ──────────────────────────────────────────────────────────────
add("stevearc/dressing.nvim")
require("dressing").setup({
	input = { win_options = { winblend = 0 } },
	select = { backend = { "fzf_lua", "builtin" } }, -- fzf-lua for selects too
})

-- ──────────────────────────────────────────────────────────────
-- 30. AUTOCMDS & OPTIONS
-- ──────────────────────────────────────────────────────────────
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 })
	end,
})

vim.opt.colorcolumn = "80,120"

-- ──────────────────────────────────────────────────────────────
-- 31. GENERAL KEYMAPS
-- ──────────────────────────────────────────────────────────────
map("n", "<leader>bd", "<cmd>bdelete<cr>", "Delete Buffer")
map("n", "]b", "<cmd>bnext<cr>", "Next Buffer")
map("n", "[b", "<cmd>bprev<cr>", "Prev Buffer")

map("n", "<leader>w", "<cmd>w<cr>", "Save")
map("n", "<leader>q", "<cmd>q<cr>", "Quit")
map("n", "<leader>nh", "<cmd>nohl<cr>", "Clear Highlight")
map("n", "<leader>ts", function()
	require("mini.trailspace").trim()
end, "Trim Trailing Space")
