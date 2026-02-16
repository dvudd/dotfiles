return {
  "romgrk/barbar.nvim",
  dependencies = {
    "lewis6991/gitsigns.nvim", -- OPTIONAL: for git status
    "nvim-tree/nvim-web-devicons", -- OPTIONAL: for file icons
  },
  init = function()
    vim.g.barbar_auto_setup = false
  end,
  opts = {
    -- lazy.nvim will automatically call setup if opts is provided
    animation = true,
    auto_hide = false,
    tabpages = true,
    clickable = true,
    -- Excludes buffers from the tabline
    exclude_ft = { "qf" },
    exclude_name = {},
    icons = {
      buffer_index = false,
      buffer_number = false,
      button = "",
      diagnostics = {
        [vim.diagnostic.severity.ERROR] = { enabled = true, icon = " " },
        [vim.diagnostic.severity.WARN] = { enabled = false },
        [vim.diagnostic.severity.INFO] = { enabled = false },
        [vim.diagnostic.severity.HINT] = { enabled = true },
      },
      gitsigns = {
        added = { enabled = true, icon = "+" },
        changed = { enabled = true, icon = "~" },
        deleted = { enabled = true, icon = "-" },
      },
      filetype = {
        custom_colors = false,
        enabled = true,
      },
      separator = { left = "▎", right = "" },
      modified = { button = "●" },
      pinned = { button = "", filename = true },
      preset = "default",
      alternate = { filetype = { enabled = false } },
      current = { buffer_index = false },
      inactive = { button = "×" },
      visible = { modified = { buffer_number = false } },
    },
    insert_at_end = false,
    insert_at_start = false,
    maximum_padding = 1,
    minimum_padding = 1,
    maximum_length = 30,
    minimum_length = 0,
    semantic_letters = true,
    sidebar_filetypes = {
      NvimTree = true,
    },
    no_name_title = nil,
  },
  version = "^1.0.0", -- recommended
}
