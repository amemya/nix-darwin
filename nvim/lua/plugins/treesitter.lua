return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    config = function()
      local ok, treesitter = pcall(require, 'nvim-treesitter.configs')
      if ok then
        treesitter.setup {
          auto_install = false,
          highlight = {
            enable = true,
          },
        }
      end
    end,
  }
}