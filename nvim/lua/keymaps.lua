local keymap = vim.keymap.set

-- Window navigation (Ctrl + hjkl)
keymap("n", "<C-h>", "<C-w>h")
keymap("n", "<C-j>", "<C-w>j")
keymap("n", "<C-k>", "<C-w>k")
keymap("n", "<C-l>", "<C-w>l")

-- Window resize
keymap("n", "<C-Up>", ":resize +2<CR>", { desc = "Increase window height" })
keymap("n", "<C-Down>", ":resize -2<CR>", { desc = "Decrease window height" })
keymap("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
keymap("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })

-- Insert mode helpers
-- TODO: repurpose this for something else
-- keymap("i", "<C-c>", "<Esc>", { desc = "Get out of insert mode" })
-- This works in Neovide but not in pure command line since shift + space doesn't register there
-- keymap("i", "<S-Space>", "<Esc>", { desc = "Get out of insert mode" })
keymap("i", ";;", "<Esc>", { desc = "Get out of insert mode" })

-- Window management (<leader>w = current Window)
keymap("n", "<leader>wj", ":split<CR>", { desc = "Split window below" })
keymap("n", "<leader>wk", ":leftabove split<CR>", { desc = "Split window above" })
keymap("n", "<leader>wl", ":vsplit<CR>", { desc = "Split window right" })
keymap("n", "<leader>wh", ":leftabove vsplit<CR>", { desc = "Split window right" })
keymap("n", "<leader>we", "<Cmd>wincmd =<CR>", { desc = "Equalize windows" })
keymap("n", "<leader>ww", ":update<CR>", { desc = "Write current window" })
keymap("n", "<leader>wq", ":q<CR>", { desc = "Quit current window" })
keymap("n", "<leader>wf", ":tab split<CR>", { desc = "Fullscreen current widnow in a new tab" })
keymap("n", "<leader>wo", ":only<CR>", { desc = "Fullscreen current and close others" })

-- Fast custom shorthand keymaps 
keymap("n", "<leader>q", ":q<CR>", { desc = "Quit current window fast" })
keymap("n", "Q", ":qa<CR>", { desc = "Quit everything and exit" })

keymap("n", "<leader>r", ":x<CR>", { desc = "Write current window and quit", silent = true })
keymap("n", "<leader><Space>", ":nohlsearch<CR>", { desc = "Clear search highlighting", silent = true })

-- All windows in current tab (<leader>a = All windows in current tab)
keymap("n", "<leader>aw", ":tabdo u<CR>", { desc = "Write all windows in current tab" })
-- This will not close the last tab 
keymap("n", "<leader>aq", ":tabclose<CR>", { desc = "Quit all windows in current tab" })
keymap("n", "<leader>aa", ":tabclose<CR>", { desc = "Quit all windows in current tab" })
keymap("n", "<leader>ah", "gT", { desc = "Switch to left tab" })
keymap("n", "<leader>al", "gt", { desc = "Switch to right tab" })

-- Kill / force (<leader>k prefix + the above = force the action)
-- TODO: kw and ka can be separated out into single prefix
keymap("n", "<leader>kww", ":update!<CR>", { desc = "Force write current window" })
keymap("n", "<leader>kwq", ":q!<CR>", { desc = "Force quit current window" })
keymap("n", "<leader>kaw", ":tabdo u!<CR>", { desc = "Force write all windows/buffers/tabs" })
keymap("n", "<leader>kaq", ":tabclose!<CR>", { desc = "Force quit all windows/buffers/tabs (discard)" })

-- Buffer management
keymap("n", "<leader>jd", ":bdelete<CR>", { desc = "Delete buffer" })
keymap("n", "<leader>jo", "<Cmd>%bdelete|e#|bd#<CR>", { desc = "Delete other buffers" })
keymap("n", "<leader>jk", ":bp<CR>", { desc = "Switch to previous buffer" })
keymap("n", "<leader>jj", ":bn<CR>", { desc = "Switch to next buffer" })
keymap("n", "<leader>jf", "<C-6>", { desc = "Ping-pong between last two buffers" })

-- Restart
keymap("n", "R", ":restart<CR>", { desc = "Restart" })

-- Yank/paste helpers
keymap("x", "p", [["_dP]], { desc = "Paste over selection without losing yanked text" })

-- Visual line moves
keymap("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move lines down" })
keymap("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move lines up" })

-- Indent/outdent while keeping selection
keymap("v", "<", "<gv", { desc = "Unindent and keep selection" })
keymap("v", ">", ">gv", { desc = "Indent and keep selection" })

-- Join lines without moving cursor
keymap("n", "J", "mzJ`z", { desc = "Join lines without moving cursor" })

-- Centered scrolling
keymap("n", "<C-d>", "<C-d>zz", { desc = "Scroll down with cursor centered" })
keymap("n", "<C-u>", "<C-u>zz", { desc = "Scroll up with cursor centered" })
keymap("n", "n", "nzzzv", { desc = "Next search result centered" })
keymap("n", "N", "Nzzzv", { desc = "Previous search result centered" })

-- Wrap-aware j/k
keymap("n", "j", function()
  return vim.v.count == 0 and "gj" or "j"
end, { expr = true, silent = true, desc = "Down (wrap-aware)" })
keymap("n", "k", function()
  return vim.v.count == 0 and "gk" or "k"
end, { expr = true, silent = true, desc = "Up (wrap-aware)" })

-- Undo tree (built-in package plugin: nvim.undotree)
keymap("n", "<leader>eu", function()
  vim.cmd.packadd("nvim.undotree")
  require("undotree").open()
end, { desc = "Toggle undo tree" })

-- Toggle diagnostics
keymap("n", "<leader>ed", function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "Toggle diagnostics" })

-- Toggle UI options (<leader>e group)
keymap("n", "<leader>ec", function() vim.o.cursorline = not vim.o.cursorline end, { desc = "Toggle cursorline" })
keymap("n", "<leader>ei", function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), { bufnr = 0 }) end, { desc = "Toggle LSP inlay hints" })
keymap("n", "<leader>el", function() vim.o.list = not vim.o.list end, { desc = "Toggle invisible chars (list)" })
keymap("n", "<leader>er", function()
  vim.o.number = not vim.o.number
  vim.o.relativenumber = not vim.o.relativenumber
end, { desc = "Toggle line numbers (absolute + relative)" })
keymap("n", "<leader>es", function() vim.o.spell = not vim.o.spell end, { desc = "Toggle spell check" })
keymap("n", "<leader>ew", function() vim.o.wrap = not vim.o.wrap end, { desc = "Toggle line wrap" })
keymap("n", "<leader>eh", ":help!<CR>", { desc = "Help tag for word under cursor" })

-- Message/pager views (<leader>e group)
-- Immediatly after running an Ex command, just press enter instead of this
keymap("n", "<leader>ep", "g<", { desc = "Pager: recent messages" })
keymap("n", "<leader>em", ":messages<CR>", { desc = "Show :messages" })
keymap("n", "<leader>en", function() require("mini.notify").show_history() end, { desc = "MiniNotify history" })

-- Copy full file path
keymap("n", "<leader>pa", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  print("file:", path)
end, { desc = "Copy full file path" })
