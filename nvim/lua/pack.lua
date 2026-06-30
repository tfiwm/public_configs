vim.pack.add {
    'https://github.com/catppuccin/nvim',              -- Install a colorscheme (or is it a theme?) plugin
    "https://github.com/nvim-mini/mini.nvim",          -- all mini modules
    "https://github.com/rafamadriz/friendly-snippets", -- colllection of snippets, including Flutter and Dart
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", branch = "main", build = ":TSUpdate" },
    "https://github.com/neovim/nvim-lspconfig",        -- provides default LSP server configs for many LSPs,
    "https://github.com/mason-org/mason.nvim",         -- to make it easy to install LSPs
    "https://github.com/NeogitOrg/neogit.git",
    -- dartls goes crazy when doing just :CodeDiff, but :CodeDiff HEAD.. works fine
    "https://github.com/esmuellert/codediff.nvim.git",
    "https://github.com/ibhagwan/fzf-lua.git",
    "https://github.com/sindrets/diffview.nvim.git",
    {
        src = "https://github.com/nickjvandyke/opencode.nvim",
        version = vim.version.range("*"), -- Latest stable release
    },
    "https://github.com/rachartier/tiny-cmdline.nvim",
    "https://github.com/folke/which-key.nvim",
    "https://github.com/MeanderingProgrammer/render-markdown.nvim",
}
--
-- NVIM TREE - a file explorer on the left side, not really needed with MiniFiles
-- https://youtu.be/lljs_7xB7Ps?t=1570

-------------------------------------
------ FZF LUA - fuzzy finder and search
-------------------------------------
local fzf = require("fzf-lua")
fzf.setup({
  winopts = {
    on_create = function()
      vim.keymap.set("t", "<C-r>", [['<C-\><C-N>"'.nr2char(getchar()).'pi']], { expr = true, buffer = true })
    end
  }
})

-- <leader>f — find files, buffers, help
vim.keymap.set("n", "<leader>ff", fzf.files, { desc = "Find files" })
vim.keymap.set("n", "<leader>fr", fzf.oldfiles, { desc = "Recent files" })
vim.keymap.set("n", "<leader>fj", fzf.buffers, { desc = "Switch buffer" })
vim.keymap.set("n", "<leader>fh", fzf.help_tags, { desc = "Find help" })
vim.keymap.set("n", "<leader>fc", fzf.commands, { desc = "Commands" })
vim.keymap.set("n", "<leader>f:", fzf.command_history, { desc = "Command history" })
vim.keymap.set("n", "<leader>f/", fzf.search_history, { desc = "Search history" })
vim.keymap.set("n", "<leader>fk", fzf.keymaps, { desc = "Keymaps" })

-- <leader>s — search within files
vim.keymap.set("n", "<leader>ss", fzf.live_grep, { desc = "Live grep" })
vim.keymap.set("n", "<leader>sw", fzf.grep_cword, { desc = "Grep word under cursor" })
vim.keymap.set("n", "<leader>sW", fzf.grep_cWORD, { desc = "Grep WORD under cursor" })
vim.keymap.set("n", "<leader>sv", fzf.grep_visual, { desc = "Grep visual selection" })
vim.keymap.set("n", "<leader>sB", fzf.lines, { desc = "All buffer lines" })
vim.keymap.set("n", "<leader>sb", fzf.blines, { desc = "Current buffer lines" })
vim.keymap.set("n", "<leader>sm", fzf.marks, { desc = "Marks" })
vim.keymap.set("n", "<leader>sj", fzf.jumps, { desc = "Jumps" })
vim.keymap.set("n", "<leader>sr", fzf.registers, { desc = "Registers" })
vim.keymap.set("n", "<leader>sR", fzf.live_grep_resume, { desc = "Resume last grep" })
vim.keymap.set("n", "<leader>sn", fzf.live_grep_glob, { desc = "Grep with glob filter" })

-----------------------------------------------------------
------ MINI NOTIFY - shows notification on the top right
-----------------------------------------------------------
require("mini.notify").setup({
    -- Enforce a minimum window width so short messages (like "recording @a")
    -- don't produce a tiny, hard-to-read floating window.
    window = {
        config = function(bufnr)
            local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
            local max_line = 0
            for _, line in ipairs(lines) do
                max_line = math.max(max_line, vim.fn.strdisplaywidth(line))
            end
            local min_width = 24
            return { width = math.max(max_line, min_width) }
        end,
    },
    -- only show messages
    content = {
        format = function(notif)
            return notif.msg
        end,
    },
})

----------------------------------------------------------------------------------------
------ MINI CMDLINE COMPLETION - Shows completion dialog box as you type in command line
----------------------------------------------------------------------------------------
require("mini.cmdline").setup({
    -- If you enable this, typos will be auto corrected
    autocorrect = { enable = false }
})


--------------------------------------------------------------------------------------------------------
------ MINI SURROUND - Cool surround actions like replace the surrounding double quote with single quote
--------------------------------------------------------------------------------------------------------
require("mini.surround").setup()
-- Default Keymaps
-- | `sa` | Add surrounding or Direct with 'saiw' |
-- | `sd` | Delete surrounding |
-- | `sr` | Replace surrounding |
-- | `sf` | Find surrounding (right) |
-- | `sF` | Find surrounding (left) |
-- | `sh` | Highlight surrounding |
-- | `sn` | Update n_lines |
-- | `l` / `n` | as suffix for prev/next |

--------------------------------------------------------------------------------------------------------
-- MINI FILES - File explorer for project directory structure, file operations like create, rename, move
--------------------------------------------------------------------------------------------------------
local MiniFiles = require("mini.files")
MiniFiles.setup({
    mappings = {
        -- Open a file or directory
        go_in = "<CR>",
        go_in_plus = "L",
        -- Go back to prevous directory
        go_out = "<leader>h",
        go_out_plus = "H",
        synchronize = "<leader>s",
    },
})

-- Use q to close it, but if you open something using 'L', it will automatically close it
-- Use commands just like in Oil to create, delete and rename files. To apply changes, use '='
-- Use C - n and C - p to cycle through items
vim.keymap.set("n", "<leader>ee", "<cmd>lua MiniFiles.open()<CR>", { desc = "Open mini file explorer" })
vim.keymap.set("n", "<leader>ef", function()
    MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
    MiniFiles.reveal_cwd()
end, { desc = "Open MiniFiles from the directory of currently opened file" })

-------------------------------------------------------------------------------
------ MINI PICKER - keep loaded for mini.extra pickers
-------------------------------------------------------------------------------
require("mini.pick").setup()
local MiniExtra = require("mini.extra")
MiniExtra.setup()

vim.keymap.set("n", "<leader>de", function() MiniExtra.pickers.diagnostic() end, { desc = "Diagnostics list (mini.extra)" })

----------------------------------------------
------ MINI COMPLETIONS - complete as you type
----------------------------------------------
require("mini.completion").setup({
    lsp_completion = {
        auto_setup = true, -- attach to buffers that have LSP connected
    }
})

---------------------------------------------
------ MINI SNIPPETS - collection of snippets
---------------------------------------------
--- Use C - l to jump to the next placeholder in the inserted snippet and C - h to move to the previous
local MiniSnippets = require("mini.snippets")
MiniSnippets.setup({
    snippets = {
        MiniSnippets.gen_loader.from_lang(), -- loads friendly-snippets
    },
})
MiniSnippets.start_lsp_server({ match = false }) -- returns all the snippets and let mini handle the filtering

-----------------------------------------------------------
------ MINI INDENT - visualize and navigate indented blocks
-----------------------------------------------------------
-- # Shows indentation lines
-- # Adds motion to go to the top and bottom of indentation. e.g. '[i' to go to the top of indent
-- In visual mode, use the builtin (not from Mini Indent) nvim feature 'an' to select outwards and 'in' to select inwards
-- This is more fine grained wherein it can go outwards via function calls, arguments, lists etc., i.e, not just go outwards based on indent
-- # Adds text object that targets contents of current indentation

local MiniIndentscope = require('mini.indentscope')
MiniIndentscope.setup( {
    draw = {
      -- Delay (in ms) between event and start of drawing scope indicator
      delay = 100,

      -- Animation rule for scope's first drawing. A function which, given
      -- next and total step numbers, returns wait time (in ms). See
      -- |MiniIndentscope.gen_animation| for builtin options. To disable
      -- animation, use `require('mini.indentscope').gen_animation.none()`.
      -- animation = MiniIndentscope.gen_animation.quadratic({ easing = 'out', duration = 300, unit = 'total' }),
      animation = MiniIndentscope.gen_animation.cubic({ easing = 'out', duration = 15, unit = 'step' }),
  }})

------------------------------------
-- MINI ICONS - add glyphs and icons
------------------------------------
local MiniIcons = require('mini.icons')
MiniIcons.setup()
-- This function mocks exported functions of 'nvim-tree/nvim-web-devicons'
-- plugin. It will mock all its functions which return icon data by
-- using |MiniIcons.get()| equivalent.
MiniIcons.mock_nvim_web_devicons()

---------------------------------------------------------------
-- MINI BRACKETED - [x / ]x navigation for diagnostics, etc.
-- NOTE: intentionally overrides nvim 0.12 built-in ]b/[b/]d/[d/]q/[q etc.
-- with its own (slightly different) behavior; kept for its extra
-- suffixes the built-ins lack (]w/[w, ]f/[f, ]c/[c, ...).
---------------------------------------------------------------
require('mini.bracketed').setup({
    undo = { suffix = "" }, -- disable: interferes with u/CTRL-R
})

----------------------------------------------------------------------------------------------------------
------ MINI DIFF - inline annotation of hunks
----------------------------------------------------------------------------------------------------------
-- # Shows current buffer modifications inline, like added/deleted/modified lines.
-- This can be annotated on line number or sign column
-- # Inline diff called overlay, which can be enabled using toggle_overlay
-- TODO: setup keymaps for hunk actions and other required git stuff. Most of the keymaps are default
----------------------------------------------------------------------------------------------------------
local MiniDiff = require("mini.diff")
MiniDiff.setup({
    source = MiniDiff.gen_source.git({ index = false }),
})
vim.keymap.set("n", "]h", function()
	MiniDiff.goto_hunk("next")
end, { desc = "Next git hunk" })

vim.keymap.set("n", "[h", function()
	MiniDiff.goto_hunk("prev")
end, { desc = "Prev git hunk" })

vim.keymap.set("n", "<leader>hs", MiniDiff.operator, { desc = "Stage hunk" })

-- Control overlay
vim.keymap.set("n", "<leader>hp", function()
    MiniDiff.toggle_overlay()
end, { desc = "Preview diff overlay" })

----------------------------------------------------------------------------------------------------
------ MINI GIT - basic buffer based git features like history, run any git command using :Git, etc.
----------------------------------------------------------------------------------------------------
-- # Can run git commands using :Git. The output from the command is showed to the user intelligently
-- via notify or new window depending on the command.
-- # Provides completion when typing :Git commands
-- # History related features like evolution of current line, details of a commit etc.

--------  These are default mappings
--  -- Apply hunks inside a visual/operator region
--  apply = 'gh',
--  -- Reset hunks inside a visual/operator region
--  reset = 'gH',
--  -- Hunk range textobject to be used inside operator
--  -- Works also in Visual mode if mapping differs from apply and reset
--  textobject = 'gh',
--  -- Go to hunk range in corresponding direction
--  goto_first = '[H',
--  goto_prev = '[h',
--  goto_next = ']h',
--  goto_last = ']H',
require("mini.git").setup({})
-- Show the evolution of current line or when on commit hash, inspect that commit
vim.keymap.set("n", "<leader>hb", function()
    require("mini.git").show_at_cursor()
end, { desc = "Git inspect current line or commit" })

---------------------------------------
------ NEOGIT - advanced git operations
---------------------------------------
require('neogit').setup {
    -- Use diffview instead of codediff when implicitly opening diff from Neogit
    diff_viewer = "diffview",
}
vim.keymap.set("n", "<leader>gg", "<cmd>Neogit<cr>", { desc = "Open Neogit UI" })

---------------------------------------------------------------
------ CODEDIFF - all about diffing files, commits and branches
---------------------------------------------------------------
require("codediff").setup({
    diff = { compute_moves = true },
      highlights = {
        char_brightness = 1.4,
      },
})

------ DIFFVIEW.NVIM
require("diffview").setup({ })

--------------------------------------------------------------------
-- GIT KEYMAPS - neogit, diffview, codediff, fzf-lua git pickers
--------------------------------------------------------------------
vim.keymap.set("n", "<leader>gd", "<cmd>CodeDiff HEAD...<CR>", { desc = "Open full diffview" })
vim.keymap.set("n", "<leader>gf", "<cmd>CodeDiff file HEAD<CR>", { desc = "Diff this file vs HEAD (codediff)" })
vim.keymap.set("n", "<leader>gD", "<cmd>DiffviewOpen<CR>", { desc = "Open full diffview" })
vim.keymap.set("n", "<leader>gq", "<cmd>DiffviewClose<CR>", { desc = "Close diffview" })

-- Commit history
vim.keymap.set("n", "<leader>gF", "<cmd>DiffviewFileHistory %<CR>", { desc = "Commit history of this file (diffview)" })
vim.keymap.set("n", "<leader>gC", "<cmd>CodeDiff history<CR>", { desc = "All commit history (codediff)" })

-- fzf-lua git pickers
local fzf_git = require("fzf-lua")
vim.keymap.set("n", "<leader>gkc", fzf_git.git_commits, { desc = "Git commits" })
vim.keymap.set("n", "<leader>gkb", fzf_git.git_branches, { desc = "Git branches" })
vim.keymap.set("n", "<leader>gks", fzf_git.git_status, { desc = "Git status" })
vim.keymap.set("n", "<leader>gkS", fzf_git.git_stash, { desc = "Git stash" })

--------------------------------------------------------------------
-- DIAGNOSTICS KEYMAPS - fzf-lua and native diagnostics
--------------------------------------------------------------------
vim.keymap.set("n", "<leader>dd", fzf_git.diagnostics_document, { desc = "Document diagnostics" })
vim.keymap.set("n", "<leader>db", fzf_git.diagnostics_workspace, { desc = "Workspace diagnostics" })

--------------------------------------------------------------------
-- LISTS - quickfix and location list toggles
--------------------------------------------------------------------
vim.keymap.set("n", "<leader>lq", "<cmd>copen<CR>", { desc = "Quickfix list" })
vim.keymap.set("n", "<leader>ll", "<cmd>lopen<CR>", { desc = "Location list" })


-------------------------------------------------
------ OPENCODE.NVIM - control opencode from nvim
-------------------------------------------------

-- already set in other options
-- vim.o.autoread = true -- Required for `vim.g.opencode_opts.events.reload`

-- vim.g.opencode_opts = {
--   -- Your configuration, if any; goto definition on the type for details
-- }

-- Recommended/example keymaps
vim.keymap.set({ "n", "x" }, "<leader>oa", function() require("opencode").ask("@this: ") end, { desc = "Ask OpenCode…" })
vim.keymap.set({ "n", "x" }, "<leader>os", function() require("opencode").select() end,       { desc = "Select OpenCode…" })

vim.keymap.set({ "n", "x" }, "go",  function() return require("opencode").operator("@this ") end,        { desc = "Append range to OpenCode", expr = true })
vim.keymap.set("n",          "goo", function() return require("opencode").operator("@this ") .. "_" end, { desc = "Append line to OpenCode", expr = true })

-- This keymap hangs, but the command can actually scroll
-- vim.keymap.set("n", "<S-C-u>", function() require("opencode").command("session.half.page.up") end,   { desc = "Scroll OpenCode up" })
-- vim.keymap.set("n", "<S-C-d>", function() require("opencode").command("session.half.page.down") end, { desc = "Scroll OpenCode down" })

----------------------------------------------------------------
------ RENDER-MARKDOWN.NVIM - preview markdown inline
----------------------------------------------------------------
require("render-markdown").setup({
    completions = { lsp = { enabled = true } },
})

----------------------------------------------------------------
------ WHICH-KEY - keymap discovery popup
----------------------------------------------------------------
local wk = require("which-key")
wk.setup({})
wk.add({
    { "<leader>a", group = "Current Tab" },
    { "<leader>d", group = "Diagnostics" },
    { "<leader>e", group = "Toggle/UI" },
    { "<leader>f", group = "Find" },
    { "<leader>g", group = "Git" },
    { "<leader>h", group = "Hunk" },
    { "<leader>i", group = "Intelligence (LSP)" },
    { "<leader>j", group = "Buffer" },
    { "<leader>k", group = "Forced Window/Tab operations" },
    { "<leader>l", group = "Lists" },
    { "<leader>m", group = "Markdown" },
    { "<leader>o", group = "OpenCode" },
    { "<leader>p", group = "Project/Path" },
    { "<leader>r", group = "Update quit current window" },
    { "<leader>s", group = "Search" },
    { "<leader>t", group = "Terminal" },
    { "<leader>w", group = "Current Window" },
})

----------------------------------------------------------------
------ TINY-CMDLINE.NVIM - move command line float at the center
----------------------------------------------------------------
-- # Makes the command line floating at the center using the new vim._core.ui2 features
-- # Doesn't necessarily need setup() call, but needs cmdheight to be zero
vim.o.cmdheight = 0
require("tiny-cmdline").setup{
    -- by default '/' and '?' goes to the bottom, but we want them to be at the center, floating
    native_types = {},
    title  = {
        enabled = true,
    },
}
