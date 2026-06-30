-- Most of these are not needed, but check this out https://github.com/Sin-cy/nvim-scratch/blob/main/lua/commands.lua

-- Create a group for all the user commands with clear = true
-- 1) Automatically clear out older versions of the same autocommand when reloading your configuration, preventing commands from piling up
-- 2) Disable, remove, or view a specific collection of related commands at once
local augroup = vim.api.nvim_create_augroup("UserConfig", { clear = true })

-- Show a quick highlight when you yank something
-------------------------------------------------
vim.api.nvim_create_autocmd("TextYankPost", {
    group = augroup,
    desc = "Highlight when yanking (copying) text",
    callback = function()
        vim.hl.on_yank()
    end,
})

-- Format on save - 
--------------------
-- check https://github.com/radleylewis/nvim-lite/blob/master/init.lua

-- Return to last cursor position - this doesn't seem to work, because this file was not getting included
-------------------------------------------------------------
-- vim.api.nvim_create_autocmd("BufReadPost", {
-- 	group = augroup,
-- 	desc = "Restore last cursor position",
-- 	callback = function()
-- 		if vim.o.diff then -- except in diff mode
-- 			return
-- 		end
--
-- 		local last_pos = vim.api.nvim_buf_get_mark(0, '"') -- {line, col}
-- 		local last_line = vim.api.nvim_buf_line_count(0)
--
-- 		local row = last_pos[1]
-- 		if row < 1 or row > last_line then
-- 			return
-- 		end
--
-- 		pcall(vim.api.nvim_win_set_cursor, 0, last_pos)
-- 	end,
-- })

-- Markdown checkbox toggle helper
----------------------------------
local function toggle_checkbox()
    local line = vim.api.nvim_get_current_line()
    if line:match("%[ %]") then
        line = line:gsub("%[ %]", "[x]")
    elseif line:match("%[x%]") then
        line = line:gsub("%[x%]", "[ ]")
    end
    vim.api.nvim_set_current_line(line)
end

-- Markdown link follow helper
----------------------------------
local function follow_link()
    local line = vim.api.nvim_get_current_line()
    local _, _, url = line:find("%[([^%]]+)%]%(([^)]+)%)")
    if url then
        if url:match("^https?://") then
            vim.ui.open(url)
        else
            vim.cmd("edit " .. vim.fn.fnameescape(url))
        end
        return
    end
    local _, _, wiki = line:find("%[%[([^%]]+)%]%]")
    if wiki then
        local path = wiki:match("(.*)|")
        if not path then path = wiki end
        vim.cmd("edit " .. vim.fn.fnameescape(path .. ".md"))
        return
    end
    vim.notify("No link under cursor", vim.log.levels.WARN)
end

-- Wrap, linebreak, spellcheck and keymaps for markdown/text
------------------------------------------------------------
vim.api.nvim_create_autocmd("FileType", {
    group = augroup,
    pattern = { "markdown", "text", "gitcommit" },
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.linebreak = true
        vim.opt_local.spell = true

        -- Buffer-local markdown keymaps
        local map = vim.keymap.set
        local buf = vim.api.nvim_get_current_buf()
        map("n", "<leader>mr", "<cmd>RenderMarkdown toggle<CR>", { buffer = buf, desc = "Toggle markdown rendering" })
        map("n", "<leader>mR", "<cmd>RenderMarkdown buf_toggle<CR>", { buffer = buf, desc = "Toggle rendering (buffer)" })
        map("n", "<leader>mp", "<cmd>RenderMarkdown preview<CR>", { buffer = buf, desc = "Preview markdown" })
        map("n", "<leader>mc", toggle_checkbox, { buffer = buf, desc = "Toggle checkbox" })
        map("n", "<leader>ml", follow_link, { buffer = buf, desc = "Follow link" })
    end,
})
