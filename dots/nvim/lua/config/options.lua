-- General settings
vim.opt.number = true                -- Show line numbers
vim.opt.relativenumber = false        -- Show relative line numbers
vim.opt.mouse = "a"                  -- Enable mouse support
vim.opt.clipboard = "unnamedplus"    -- Use system clipboard
vim.opt.ignorecase = true            -- Ignore case in search
vim.opt.smartcase = true             -- Unless search has uppercase
vim.opt.hlsearch = true              -- Highlight search results
vim.opt.incsearch = true             -- Incremental search
vim.opt.wrap = false                 -- Don't wrap lines
vim.opt.breakindent = true           -- Indent wrapped lines
vim.opt.tabstop = 4                  -- Tab width
vim.opt.shiftwidth = 4               -- Indent width
vim.opt.expandtab = true             -- Use spaces instead of tabs
vim.opt.smartindent = true           -- Smart indentation
vim.opt.termguicolors = true         -- True color support
vim.opt.signcolumn = "yes"           -- Always show sign column
vim.opt.updatetime = 250             -- Faster completion
vim.opt.timeoutlen = 300             -- Faster key sequence completion
vim.opt.splitbelow = true            -- Horizontal splits below
vim.opt.splitright = true            -- Vertical splits right
vim.opt.scrolloff = 8                -- Keep 8 lines above/below cursor
vim.opt.sidescrolloff = 8            -- Keep 8 columns left/right of cursor
vim.opt.cursorline = true            -- Highlight current line
vim.opt.undofile = true              -- Persistent undo
vim.opt.backup = false               -- No backup files
vim.opt.swapfile = false             -- No swap files
vim.opt.completeopt = "menu,menuone,noselect"  -- Better completion experience

-- Godot-specific settings
vim.opt.wildignore:append({ "*.import", "*.uid" })  -- Ignore Godot import files
