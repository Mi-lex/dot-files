return {
  {
    "nvim-telescope/telescope.nvim",
    opts = function(_, opts)
      opts.pickers = opts.pickers or {}
      opts.pickers.find_files = vim.tbl_deep_extend("force", opts.pickers.find_files or {}, {
        hidden = true,
        no_ignore = true,
        file_ignore_patterns = { ".git/", "node_modules/" },
      })
      if vim.fn.executable("rg") == 1 then
        opts.pickers.find_files.find_command = {
          "rg", "--files", "--color", "never", "--hidden", "--no-ignore",
          "-g", "!.git", "-g", "!node_modules",
        }
      elseif vim.fn.executable("fd") == 1 then
        opts.pickers.find_files.find_command = {
          "fd", "--type", "f", "--color", "never", "--hidden", "--no-ignore",
          "-E", ".git", "-E", "node_modules",
        }
      elseif vim.fn.executable("fdfind") == 1 then
        opts.pickers.find_files.find_command = {
          "fdfind", "--type", "f", "--color", "never", "--hidden", "--no-ignore",
          "-E", ".git", "-E", "node_modules",
        }
      end
    end,
  },
}
