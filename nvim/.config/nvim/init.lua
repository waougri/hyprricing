require("config.lazy")

function server(server_name, filetypes, settings)
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
            runtime = { version = 'LuaJIT' },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
            },
            diagnostics = { globals = { 'vim' } },
        },
    },
}
vim.lsp.enable("lua_ls") -- ← was missing

server("rust-analyzer", { "rust" }) -- ← dropped "rs"

vim.lsp.config["typescript-language-server"] = {
    cmd = { vim.fn.exepath("typescript-language-server"), "--stdio" }, -- ← --stdio required
    filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
    root_markers = { "tsconfig.json", "package.json", ".git" },
}
vim.lsp.enable("typescript-language-server")

vim.lsp.config["clangd"] = {
    cmd = {
        vim.fn.exepath("clangd"),
        "--background-index",
        "--clang-tidy",
        "--header-insertion=iwyu",
        "--completion-style=detailed",
        "--fallback-style=llvm",
    },
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
    root_markers = { ".clangd", "compile_commands.json", ".git" },
}
vim.lsp.enable("clangd")

vim.lsp.config["roslyn"] = { -- ← [] assignment, not function call
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
}
vim.lsp.enable("roslyn")

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
        local opts = { buffer = ev.buf }
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'K',  vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
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

require("oil").setup({ -- ← no trailing comma
    view_options = {
        show_hidden = true,
        is_always_hidden = function(name, bufnr)
            return false
        end,
    }
})

require('mini.tabline').setup()

vim.keymap.set("n", "-", function()
    require("oil").open_float()
end, { desc = "Open Oil" })

vim.diagnostic.config({
    virtual_text = {
        prefix = '●',
        spacing = 4,
    },
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
})

require("autoclose").setup()
require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    -- Conform will run multiple formatters sequentially
    python = { "isort", "black" },
    -- You can customize some of the format options for the filetype (:help conform.format)
    rust = { "rustfmt", lsp_format = "fallback" },
    -- Conform will run the first available formatter
    javascript = { "prettierd", "prettier", stop_after_first = true },
    cpp = {"clangd"},
  },
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args)
    require("conform").format({ bufnr = args.buf })
  end,
})
