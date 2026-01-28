local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

return require("lazy").setup({
  -- CORE
  { "nvim-lua/plenary.nvim" },
  { "nvim-tree/nvim-web-devicons" },

-- THEME: Catppuccin Mocha
  { 
    "catppuccin/nvim", 
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha", -- latte, frappe, macchiato, mocha
        transparent_background = false, -- Matches your previous setting
        term_colors = true,
        styles = { 
            comments = { "italic" },
            keywords = { "italic" },
        },
        -- Catppuccin requires explicit enabling of integrations
        integrations = {
            cmp = true,
            gitsigns = true,
            nvimtree = true,
            treesitter = true,
            mason = true,
            native_lsp = {
                enabled = true,
                virtual_text = {
                    errors = { "italic" },
                    hints = { "italic" },
                    warnings = { "italic" },
                    information = { "italic" },
                },
                underlines = {
                    errors = { "underline" },
                    hints = { "underline" },
                    warnings = { "underline" },
                    information = { "underline" },
                },
            },
        }
      })
      -- Apply the scheme immediately
      vim.cmd.colorscheme "catppuccin"
    end
  },

  -- FILE EXPLORER (Your Custom Logic Preserved)
  {
    "nvim-tree/nvim-tree.lua",
    config = function()
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
      require("nvim-tree").setup({
        disable_netrw = true,
        hijack_netrw = true,
        sync_root_with_cwd = true,
        update_focused_file = { enable = true, update_root = true },
        view = { width = 35, side = "left" },
        renderer = {
            root_folder_label = false,
            highlight_git = true,
            indent_markers = { enable = true },
            icons = {
                show = { file = true, folder = true, folder_arrow = true, git = true },
            },
        },
        filters = { dotfiles = false, custom = { ".git", "node_modules", ".cache" } },
        git = { enable = true, ignore = false },
      })
      -- Tree Keymaps
      local keymap = vim.keymap.set
      keymap("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file tree" })
      keymap("n", "<leader>o", "<cmd>NvimTreeFocus<CR>", { desc = "Focus file tree" })
    end
  },

  -- UI COMPONENTS
  { 
    "nvim-lualine/lualine.nvim",
    config = function()
       require("lualine").setup({
        options = {
            theme = "catppuccin",
            globalstatus = true,
            component_separators = { left = "|", right = "|" },
            section_separators = { left = "", right = "" },
        },
    })
    end
  },
  { 
    "akinsho/bufferline.nvim", 
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
       require("bufferline").setup({
        options = {
            diagnostics = "nvim_lsp",
            offsets = { { filetype = "NvimTree", text = "File Explorer", text_align = "center", separator = true } },
            separator_style = "thin",
            indicator = { style = "none" },
        },
    })
    end 
  },
  { 
    "lukas-reineke/indent-blankline.nvim", 
    main = "ibl", 
    opts = { indent = { char = "|" }, scope = { enabled = true } } 
  },
  
  -- GIT
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        signs = {
            add = { text = "|" }, change = { text = "|" }, delete = { text = "_" },
            topdelete = { text = "-" }, changedelete = { text = "~" }, untracked = { text = "|" },
        },
        on_attach = function(bufnr)
            local gs = package.loaded.gitsigns
            local keymap = vim.keymap.set
            keymap("n", "]c", function() if vim.wo.diff then return "]c" end vim.schedule(function() gs.next_hunk() end) return "<Ignore>" end, { expr = true, buffer = bufnr })
            keymap("n", "[c", function() if vim.wo.diff then return "[c" end vim.schedule(function() gs.prev_hunk() end) return "<Ignore>" end, { expr = true, buffer = bufnr })
            keymap("n", "<leader>hs", gs.stage_hunk, { buffer = bufnr })
            keymap("n", "<leader>hr", gs.reset_hunk, { buffer = bufnr })
            keymap("n", "<leader>hp", gs.preview_hunk, { buffer = bufnr })
            keymap("n", "<leader>hb", function() gs.blame_line({ full = true }) end, { buffer = bufnr })
            keymap("n", "<leader>gs", "<cmd>Git<CR>", { desc = "Git status" })
        end,
      })
    end
  },
  { "tpope/vim-fugitive" },

  -- TELESCOPE
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      telescope.setup({
        defaults = {
            prompt_prefix = "> ", selection_caret = "> ", path_display = { "truncate" },
            file_ignore_patterns = { "node_modules", ".git/", "*.pyc" },
            mappings = { i = { ["<C-j>"] = actions.move_selection_next, ["<C-k>"] = actions.move_selection_previous, ["<esc>"] = actions.close } },
        },
      })
      local builtin = require("telescope.builtin")
      local keymap = vim.keymap.set
      keymap("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
      keymap("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
      keymap("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })
      keymap("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
    end
  },

  -- UTILITIES
  { "numToStr/Comment.nvim", config = true },
  { "windwp/nvim-autopairs", event = "InsertEnter", config = true },
  { "kylechui/nvim-surround", event = "VeryLazy", config = true },
  { "folke/which-key.nvim", event = "VeryLazy", config = true },

  -- LSP & COMPLETION SUPPORT
  { "neovim/nvim-lspconfig" },
  { "williamboman/mason.nvim", config = true },
  { "williamboman/mason-lspconfig.nvim" },
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "hrsh7th/cmp-cmdline" },
  { "L3MON4D3/LuaSnip" },
  { "saadparwaiz1/cmp_luasnip" },
  
  -- TREESITTER
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      -- Protected call: checks if the module exists before running setup
      local status_ok, configs = pcall(require, "nvim-treesitter.configs")
      if not status_ok then
        return
      end

      configs.setup({
        ensure_installed = { "c", "cpp", "rust", "bash", "lua", "python", "javascript", "json", "markdown", "vim" },
        sync_install = false,
        auto_install = true,
        highlight = { enable = true, additional_vim_regex_highlighting = false },
        indent = { enable = true },
      })
    end
  },
  -- DEBUGGING (DAP)
  { "mfussenegger/nvim-dap" },
  { "rcarriga/nvim-dap-ui", dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"} },
})
