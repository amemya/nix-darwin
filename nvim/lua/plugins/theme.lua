return {
  {
    "Mofiqul/vscode.nvim",
    lazy = false,    -- Make sure we load this during startup
    priority = 1000, -- Load this before all the other start plugins
    config = function()
      vim.o.background = 'dark'
      require('vscode').setup({
        transparent = false,
        italic_comments = true,
      })
      vim.cmd.colorscheme("vscode")
    end,
  }
}
