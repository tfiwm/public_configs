-- When something is displayed in the ui2 pager (e.g. long output of a ex command),
-- you can use 'g<' to jump to the ui2 pager and make it full screen
require('vim._core.ui2').enable({})
require('options')
require('keymaps')
require('pack')
-- to review
require('lsp')
-- to review
require('treesitter')
-- to review
require('commands')
-- Sets a manul implementation for status line using Nerd fonts
-- to review
require('tweaked_mini_statusline')
-- to review
require('floating_terminal')

vim.cmd.colorscheme('catppuccin')
