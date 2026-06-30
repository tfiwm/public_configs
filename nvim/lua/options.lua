-- ========================================================================== --
--                               1. CORE OPTIONS                              --
-- ========================================================================== --
vim.g.mapleader = " "         -- Set spacebar as the leader key
vim.opt.number = true         -- Show line numbers
vim.opt.relativenumber = true -- Relative line numbers for easy jumping
vim.opt.mouse = "a"           -- Enable mouse support

-- Current line
vim.opt.cursorline = true     -- highlight the current line
vim.opt.wrap = false          -- Disable line wrapping
-- Break wrapped lines at word boundaries rather than mid-word.
vim.opt.linebreak = true

-- Indentation, shifting and tabs
vim.opt.tabstop = 4           -- Render tabs as 4 spaces
vim.opt.softtabstop = 4       -- Number of spaces for editing
vim.opt.shiftwidth = 4        -- Size of an indent
vim.opt.expandtab = true      -- Turn tabs into spaces
vim.opt.smartindent = true    -- Insert indents automatically
vim.opt.autoindent = true -- copy indent from current line

-- Searching
vim.opt.ignorecase = true     -- Case-insensitive searching
vim.opt.smartcase = true      -- Case-sensitive if capitals are used
vim.opt.hlsearch = true       -- Clear highlights after search matches
vim.opt.incsearch = true      -- Show search results while typing

vim.opt.termguicolors = true  -- True color support, makes use of all 24-bit available colors
-- vim.cmd.colorscheme('habamax') -- Set a good color scheme

-- vim.opt.colorcolumn = "100" -- Show addition vertical column as a guideline for width
vim.opt.clipboard = "unnamedplus" -- Use system clipboard

-- Scrolling
vim.opt.scrolloff = 4         -- Keep 4 lines visible above/below cursor
vim.opt.sidescrolloff = 4     -- Keep 4 lines visible to the left/right cursor

-- better swap file handling?
vim.opt.swapfile = false
vim.opt.backup = false
-- Start creating undo files so that we are can undo even after reopening the file
vim.opt.undofile = true
-- Put those undo files in this centralized directory inside the standard data dir, which is typically ~/.local/share/nvim
vim.opt.undodir = vim.fn.stdpath("data") .. "/undodir"
-- Ask for confirmation instead of failing silently when, e.g., closing an unsaved buffer.
vim.opt.confirm = true
-- Briefly highlight the matching bracket/paren when you type a closing one.
vim.opt.showmatch = true

-- Splitting
vim.opt.splitbelow = true -- split new windows below instead of the default above
vim.opt.splitright = true -- split new windows right instead of the default left
vim.opt.inccommand = "split" -- show all the substitute command results as a preview in split

-- Add a column to the left side of line number. This can be used for various diagnostics, git state etc.
vim.opt.signcolumn = "yes"

-- Makes the command line minimal, show it only when typing commands. Otherwise, hide behind status line
-- This has some bugs due to which you may not see the command line when there is an error unless you go 'g>'
-- This is set by the floating tiny command line plugin in its config
-- vim.opt.cmdheight = 0
-- Single line command line
-- vim.opt.cmdheight = 1

-- Dictates when and how the statusline is displayed at the bottom of your screen or windows
-- Value of 3 means - instead of every split having its own statusline, display a single statusline spanning the entire bottom edge of the editor window.
vim.opt.laststatus = 2

-- These are some improvements to auto completion, specifically when using mini-completions
-- 'menuone' - always show the completion list even when there is only one item to complete
-- 'noselect' - explictly accept a completion instead of automatically inserting the first item into the file
-- 'fuzzy' - enables fuzzy matching
-- 'nosort' - keeps the order from mini-completions
vim.opt.completeopt = "menuone,noselect,fuzzy,nosort"
vim.opt.shortmess:append("c")

-- Misc
-- vim.opt.showmode = false -- do not show the mode, instead have it in statusline, this is when you are building custom status line
-- vim.opt.pumheight = 10 -- popup menu height
-- vim.opt.pumblend = 10 -- popup menu transparency
-- vim.opt.winblend = 0 -- floating window transparency
-- vim.opt.conceallevel = 2 -- obsidian requirement
-- vim.opt.concealcursor = "" -- do not hide cursorline in markup

-- Maximum column in which to search for syntax items.  In long lines the text after this column is not highlighted 
-- and following lines may not be highlighted correctly, because the syntax state is cleared. 
vim.opt.synmaxcol = 300 -- syntax highlighting limit

-- vim.opt.fillchars = { eob = " " } -- hide "~" on empty lines

-- TIMEOUT
-- Time (ms) Neovim waits after you stop typing before firing CursorHold
-- events. Keeping it low makes LSP hover/highlight feel more responsive.
-- If this many milliseconds nothing is typed the swap file will be written to disk. default 4000
vim.opt.updatetime = 300 -- faster completion

-- Time in milliseconds to wait for a mapped sequence to complete. default 1000 ms
-- vim.opt.timeoutlen = 500 -- timeout duration

-- Time in milliseconds to wait for a key code sequence to complete. default 50 
-- Also used for CTRL-\ CTRL-N and CTRL-\ CTRL-G when part of a command has been typed.
-- vim.opt.ttimeoutlen = 50 -- key code timeout
vim.opt.autoread = true -- auto-reload changes if outside of neovim
-- vim.opt.autowrite = false -- do not auto-save

-- vim.opt.hidden = true -- allow hidden buffers, default
-- vim.opt.errorbells = false -- no error sounds

-- indent	allow backspacing over autoindent, 
-- eol	allow backspacing over line breaks (join lines),
-- start	allow backspacing over the start of insert; CTRL-W and CTRL-U stop once at the start of insert.
vim.opt.backspace = "indent,eol,start" -- better backspace behaviour

-- vim.opt.autochdir = false -- do not autochange directories, default: off
-- vim.opt.iskeyword:append("-") -- include - in words
-- vim.opt.path:append("**") -- include subdirs in search, used with gf, find , tabfind commands.
-- vim.opt.selection = "inclusive" -- include last char in selection, default inclusive

-- Folding: requires treesitter available at runtime; safe fallback if not
-- Use zc to fold and zo to unfold
vim.opt.foldmethod = "expr" -- use expression for folding
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- use treesitter for folding
vim.opt.foldlevel = 99 -- start with all folds open

-- Blinking cursor
-- vim.opt.guicursor = "n-v-c:block,i-ci-ve:block,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175" -- cursor blinking and settings

-- How the completions are shown when wildchar is expanded
-- Don't set it here, respect mini.cmdline's built-in config for this
-- vim.opt.wildmode = "longest:full,full" -- complete longest common match, full completion list, cycle through with Tab
-- vim.o.wildoptions= "pum,tagfile,fuzzy"

-- linematch default is 40, when a diff hunk is more than this limit, do not align lines 
vim.opt.diffopt:append("linematch:60") -- improve diff display

-- Performance
-- Time in milliseconds for redrawing the display.  Applies to 'hlsearch', 'inccommand', 
-- :match highlighting, syntax highlighting, and async LanguageTree:parse().
-- default: 2000 ms. If this time is exceeded, that action is aborted
-- vim.opt.redrawtime = 10000 
vim.opt.maxmempattern = 10000 -- max amount of memory used for pattern matching, default: 1000

-- Neovide options
if vim.g.neovide then
    -- Not changing this since we are setting font size
    -- vim.g.neovide_scale_factor = 0.88

    -- This is the default nvim fonts
    -- vim.o.guifont = "Source Code Pro,DejaVu Sans Mono,Courier New,monospace"
    -- Set this font for Neovide to make the fontsize similar to regular nvim
    vim.o.guifont = "Source Code Pro:h12"

    vim.g.neovide_cursor_vfx_mode = "pixiedust"
    -- vim.g.neovide_cursor_vfx_mode = "torpedo"
    -- vim.g.neovide_cursor_vfx_mode = "railgun"
end

-- Add the system word list as an additional dictionary source so that
-- spell suggestions draw from a broad vocabulary.
-- vim.opt.dictionary:append("/usr/share/dict/words")
