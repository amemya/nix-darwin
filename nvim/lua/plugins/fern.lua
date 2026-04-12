return {
  {
    "lambdalisue/fern.vim",
    dependencies = {
      "lambdalisue/nerdfont.vim",
      "lambdalisue/fern-git-status.vim",
      "lambdalisue/fern-renderer-nerdfont.vim",
      "lambdalisue/glyph-palette.vim",
    },
    init = function()
      -- These globals need to be set before fern is loaded
      vim.g['fern#default_hidden'] = 1
      vim.g['fern#renderer'] = 'nerdfont'
    end,
    config = function()
      -- glyph-palette hook
      local augroup = vim.api.nvim_create_augroup("my-glyph-palette", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "fern", "nerdtree", "startify" },
        callback = function()
          vim.fn['glyph_palette#apply']()
        end,
        group = augroup,
      })

      -- toggle command
      vim.api.nvim_create_user_command('Fe', function()
        vim.cmd("Fern . -reveal=% -drawer -toggle -width=45")
      end, { nargs = 0 })

      -- auto open on VimEnter if no args are provided
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          if vim.fn.argc() == 0 then
            vim.schedule(function()
              vim.cmd("Fern . -reveal=% -drawer -toggle -width=45")
              vim.cmd("wincmd p")
            end)
          end
        end,
      })
    end,
  }
}
