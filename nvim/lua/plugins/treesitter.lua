return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = { "c", "lua", "python", "go", "javascript", "typescript", "toml", "markdown" },
        highlight = {
          enable = true,
        },
      }
    end,
  }
}
