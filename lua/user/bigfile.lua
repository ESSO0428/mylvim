lvim.builtin.bigfile.config = {
  filesize = 1,      -- size of the file in MiB, the plugin round file sizes to the closest MiB
  pattern = { "*" }, -- autocmd pattern or function see <### Overriding the detection of big files>
  features = {       -- features to disable
    "indent_blankline",
    "illuminate",
    "lsp",
    "treesitter",
    "syntax",
    "matchparen",
    "vimopts",
    "filetype",
    {
      name = "mymatchparen",
      opts = {
        defer = false,
      },
      disable = function()
        vim.cmd('set nowrap')
        vim.cmd('set nofoldenable')
        vim.cmd('setlocal nospell')
        vim.cmd('setlocal cursorline')
        require "rainbow-delimiters".disable(0)
        if not require('session_manager.utils').session_loading then
          local choice = vim.fn.input(
            "File is large file, Do you want to continue loading?\n[n]ot open\n[s]ecurity session save and open\n[y]es directly open\nchoice(s/y/n): ")
          if choice == "s" then
            local fileName = vim.api.nvim_buf_get_name(0)
            vim.defer_fn(function()
              vim.cmd("BufferLineKill")
              vim.cmd('SessionManager save_current_session')
              vim.cmd("e " .. fileName)
            end, 50)
          elseif choice == "y" then
            -- Continue with default settings
          else
            vim.defer_fn(function()
              vim.cmd("BufferLineKill")
            end, 50)
          end
        end
      end,
    }
  },
}
