local keymap = vim.keymap.set
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- 1. YOUR CUSTOM KEYMAPS (Runs when LSP attaches)
local on_attach = function(client, bufnr)
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    keymap("n", "gd", vim.lsp.buf.definition, bufopts)
    keymap("n", "gD", vim.lsp.buf.declaration, bufopts)
    keymap("n", "gi", vim.lsp.buf.implementation, bufopts)
    keymap("n", "gR", vim.lsp.buf.references, bufopts)
    keymap("n", "K", vim.lsp.buf.hover, bufopts)
    keymap("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
    keymap("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
    keymap("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
    keymap("n", "<leader>f", function() vim.lsp.buf.format({ async = true }) end, bufopts)
    keymap("n", "[d", vim.diagnostic.goto_prev, bufopts)
    keymap("n", "]d", vim.diagnostic.goto_next, bufopts)
    keymap("n", "<leader>dl", vim.diagnostic.open_float, bufopts)
end

-- C/C++ (clangd)
-- 1. Fix the "offset_encoding" error (force UTF-16 to match nvim-cmp)
local clangd_capabilities = vim.deepcopy(capabilities)
clangd_capabilities.offsetEncoding = { "utf-16" }

vim.lsp.config('clangd', {
    cmd = { 
        "clangd", 
        "--background-index", 
        "--clang-tidy", 
        "--header-insertion=iwyu", 
        "--completion-style=detailed", 
        "--function-arg-placeholders", 
        "--fallback-style=llvm",
        -- CRITICAL for Kali/Linux: Tells clangd where to look for system headers/Qt
        "--query-driver=/usr/bin/c++,/usr/bin/**/clang-*,/usr/bin/g++" 
    },
    capabilities = clangd_capabilities,
    on_attach = on_attach,
})
vim.lsp.enable('clangd')

-- Rust
vim.lsp.config('rust_analyzer', {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
        ["rust-analyzer"] = {
            -- config 1: Use a separate "check" table for the command
            check = {
                command = "clippy",
            },
            -- config 2: checkOnSave must be a boolean (or omitted, as it defaults to true)
            checkOnSave = true,
            procMacro = {
                enable = true
            },
        }
    }
})
vim.lsp.enable('rust_analyzer')


-- Python, Bash, Lua
vim.lsp.config('pyright', { capabilities = capabilities, on_attach = on_attach })
vim.lsp.enable('pyright')
vim.lsp.config('bashls', { capabilities = capabilities, on_attach = on_attach })
vim.lsp.enable('bashls')
vim.lsp.config('lua_ls', {
    settings = { Lua = { diagnostics = { globals = { "vim" } } } },
    capabilities = capabilities,
    on_attach = on_attach,
})
vim.lsp.enable('lua_ls')

-- 3. COMPLETION (CMP)
local cmp = require("cmp")
local luasnip = require("luasnip")
require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
    snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
    window = { completion = cmp.config.window.bordered(), documentation = cmp.config.window.bordered() },
    mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_next_item() elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump() else fallback() end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_prev_item() elseif luasnip.jumpable(-1) then luasnip.jump(-1) else fallback() end
        end, { "i", "s" }),
    }),
    sources = cmp.config.sources({
        { name = "nvim_lsp", priority = 1000 },
        { name = "luasnip", priority = 750 },
        { name = "buffer", priority = 500 },
        { name = "path", priority = 250 },
    }),
})

-- 4. DEBUGGING (DAP)
local dap = require("dap")
local dapui = require("dapui")
dapui.setup()

dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

-- DAP Keymaps
keymap("n", "<leader>bt", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
keymap("n", "<leader>bc", dap.continue, { desc = "Continue" })
keymap("n", "<leader>bi", dap.step_into, { desc = "Step into" })
keymap("n", "<leader>bo", dap.step_over, { desc = "Step over" })
keymap("n", "<leader>bu", dapui.toggle, { desc = "Toggle DAP UI" })
