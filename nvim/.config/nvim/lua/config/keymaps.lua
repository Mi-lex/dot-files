-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set({ "n", "t" }, "<D-j>", function()
  Snacks.terminal.focus(nil, { cwd = LazyVim.root() })
end, { desc = "Toggle Terminal" })

vim.keymap.set("n", "<C-d>", function()
  Snacks.bufdelete()
end, { desc = "Delete Buffer" })

vim.keymap.set("n", "<D-/>", "gcc", { remap = true, desc = "Toggle Comment" })
vim.keymap.set("x", "<D-/>", "gc", { remap = true, desc = "Toggle Comment" })

vim.keymap.set("n", "gh", function()
  if vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })[1] then
    vim.diagnostic.open_float()
  else
    vim.lsp.buf.hover()
  end
end, { desc = "Hover (diagnostics / LSP)" })

vim.keymap.set("n", "<D-o>", LazyVim.pick("files"), { desc = "Find Files (Root Dir)" })

vim.keymap.set("n", "<leader>e", "<leader>fE", { remap = true, desc = "Explorer Snacks (cwd)" })
vim.keymap.set("n", "<leader>E", "<leader>fe", { remap = true, desc = "Explorer Snacks (root dir)" })
