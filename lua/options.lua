local opt = vim.opt
vim.opt.spell = false
vim.opt.spelllang = {}
vim.g.loaded_spellfile_plugin = 1

vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- Leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ============================================================================
-- CORE SETTINGS
-- ============================================================================

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.signcolumn = "yes"

-- Indentation
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.autoindent = true

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = false

-- UI/UX
vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.opt.cursorline = true
vim.opt.wrap = false
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.colorcolumn = "100"
vim.opt.showmode = false
vim.opt.showcmd = true
vim.opt.cmdheight = 1
vim.opt.laststatus = 3
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.mouse =""

-- Files & Backups
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo"
vim.opt.updatetime = 300
vim.opt.timeoutlen = 500

-- Completion
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.pumheight = 10

-- Clipboard
vim.opt.clipboard = "unnamedplus"

-- Folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = false

-- Performance
vim.opt.hidden = true
vim.opt.history = 100
vim.opt.lazyredraw = true
vim.opt.synmaxcol = 240

-- Make the separator background transparent so it blends with the editor
vim.api.nvim_set_hl(0, "WinSeparator", { bg = "None", fg = "None" })

-- Create undo directory
vim.fn.mkdir(vim.fn.stdpath("data") .. "/undo", "p")



