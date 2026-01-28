-- ============================================================================
-- KEY MAPPINGS
-- ============================================================================

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Better escape
keymap("i", "jk", "<ESC>", opts)
keymap("i", "kj", "<ESC>", opts)

-- Save and quit
keymap("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })
keymap("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })
keymap("n", "<leader>Q", "<cmd>qa!<CR>", { desc = "Quit all force" })
keymap("n", "<leader>x", "<cmd>x<CR>", { desc = "Save and quit" })

-- Clear search
keymap("n", "<Esc>", "<cmd>nohlsearch<CR>", opts)

-- Window navigation
keymap("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Window resizing
keymap("n", "<C-Up>", "<cmd>resize +2<CR>", opts)
keymap("n", "<C-Down>", "<cmd>resize -2<CR>", opts)
keymap("n", "<C-Left>", "<cmd>vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", "<cmd>vertical resize +2<CR>", opts)

-- Window splits
keymap("n", "<leader>v", "<cmd>vsplit<CR>", { desc = "Split vertically" })
keymap("n", "<leader>h", "<cmd>split<CR>", { desc = "Split horizontally" })
keymap("n", "<leader>c", "<C-w>c", { desc = "Close split" })

-- Buffer navigation
keymap("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Next buffer" })
keymap("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
keymap("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })

-- Better indenting
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("v", "J", ":m '>+1<CR>gv=gv", opts)
keymap("v", "K", ":m '<-2<CR>gv=gv", opts)
keymap("n", "<A-j>", "<cmd>m .+1<CR>==", opts)
keymap("n", "<A-k>", "<cmd>m .-2<CR>==", opts)

-- Keep cursor centered
keymap("n", "<C-d>", "<C-d>zz", opts)
keymap("n", "<C-u>", "<C-u>zz", opts)
keymap("n", "n", "nzzzv", opts)
keymap("n", "N", "Nzzzv", opts)

-- Better paste
keymap("v", "p", '"_dP', opts)

-- Delete without yank (changed to avoid conflicts)
keymap("n", "<leader>D", '"_d', { desc = "Delete without yank" })
keymap("v", "<leader>D", '"_d', { desc = "Delete without yank" })

-- Select all
keymap("n", "<C-a>", "gg<S-v>G", opts)

-- Replace word under cursor
keymap("n", "<leader>r", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Replace word" })

-- Make executable
keymap("n", "<leader>X", "<cmd>!chmod +x %<CR>", { desc = "Make executable" })

