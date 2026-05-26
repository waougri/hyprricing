require("config.lazy")

function server (server_name, filetypes, settings)

	vim.lsp.config[server_name] = {
		cmd = { vim.fn.exepath(server_name) },
		filetypes = filetypes,
		root_markers = { '.git' },
		settings = settings
	}
	vim.lsp.enable(server_name)
end

vim.lsp.config["lua_ls"] = {
	cmd = { vim.fn.exepath("lua-language-server") },
	root_markers = { ".git", ".nvim.lua" },
	settings = {
		Lua = {
			runtime = {
				version = 'LuaJIT',
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false,
			},
			diagnostics = {
				globals = {'vim'},
			},
		},
	},
}


server("rust-analyzer", {"rust", "rs"})
server("clangd", {"cpp", "hpp", "h", "c", "cxx", "hxx", "ixx"})
server("typescript-language-server", {"ts", "js", "jsx", "tsx"})

vim.lsp.config("roslyn", {
    on_attach = function()
        print("This will run when the server attaches!")
    end,
    settings = {
        ["csharp|inlay_hints"] = {
            csharp_enable_inlay_hints_for_implicit_object_creation = true,
            csharp_enable_inlay_hints_for_implicit_variable_types = true,
        },
        ["csharp|code_lens"] = {
            dotnet_enable_references_code_lens = true,
        },
    },
})

vim.api.nvim_create_autocmd('LspAttach', {

	callback = function(ev)
		local opts = {buffer = ev.buf}
		vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
		vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
		vim.keymap.set('n', 'K',  vim.lsp.buf.hover, opts)
		vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
		vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
		vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
		vim.keymap.set({'n', 'v'}, '<leader>ca', vim.lsp.buf.code_action, opts)
		vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)

		-- Format current buffer
		vim.keymap.set('n', '<leader>f', function()
			vim.lsp.buf.format { async = true }
		end, opts)
	end,
})


vim.opt.formatoptions:remove("a")
vim.cmd.colorscheme("gentoo")
vim.opt.syntax = "on"
vim.opt.number = true 
vim.opt.relativenumber = true
vim.opt.wrap = true
vim.opt.linebreak = true

require("oil").setup({
	view_options  = {
		show_hidden = true,
		is_always_hidden = function(name, bufnr)
			return false
		end,}

	})

	require('mini.tabline').setup()

	vim.keymap.set("n", "-", function()
		require("oil").open_float()
	end, { desc = "Open Oil" })


	vim.diagnostic.config({
  virtual_text = {
    prefix = '●', -- Or use a different symbol like ''
    spacing = 4,
  },
  signs = true,
  underline = true,
  update_in_insert = false, -- Only show when you aren't typing
  severity_sort = true,
})
