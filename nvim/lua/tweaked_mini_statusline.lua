-- ==========================================================================
-- MINI.STATUSLINE + MINI.ICONS COLORS
-- ==========================================================================
local function get_clean_filename()
    return MiniStatusline.is_truncated(140) and '%f' or '%F'
end

require('mini.statusline').setup({
    content = {
        active = function()
            -- Exact default section definitions
            local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
            local git           = MiniStatusline.section_git({ trunc_width = 40 })
            local diff          = MiniStatusline.section_diff({ trunc_width = 75 })
            local diagnostics   = MiniStatusline.section_diagnostics({ trunc_width = 75 })
            local lsp           = MiniStatusline.section_lsp({ trunc_width = 75 })
            local fileinfo      = MiniStatusline.section_fileinfo({ trunc_width = 120 })
            local location      = MiniStatusline.section_location({ trunc_width = 75 })
            local search        = MiniStatusline.section_searchcount({ trunc_width = 75 })
            local filename      = get_clean_filename()

            -- 2. Custom Buffer Status Logic
            local buffer_status = ""
            local status_hl     = mode_hl -- Default to mode color

            if vim.bo.readonly or not vim.bo.modifiable then
                buffer_status = ""
                -- Use colors from MiniIcons highlight groups 
                status_hl = "MiniIconsOrange"
            elseif vim.bo.modified then
                buffer_status = "󰈸"
                status_hl = "MiniIconsYellow"
            end


            return MiniStatusline.combine_groups({
                -- Mode (Far Left)
                { hl = mode_hl,                 strings = { mode:upper() } },

                -- Buffer status Icons (Right of Mode)
                { hl = status_hl,               strings = { buffer_status } },

                -- Exact default Devinfo block
                { hl = 'MiniStatuslineDevinfo', strings = { git, diff, diagnostics, lsp } },

                '%<', -- Mark general truncate point

                -- Clean Filename without buffer status indicators
                { hl = 'MiniStatuslineFilename', strings = { filename } },

                '%=', -- End left alignment

                -- Give a separate highlight group for search
                { hl = 'Search',                 strings = { search } }, -- Search gets 'Search' HL

                { hl = mode_hl,                  strings = { location } }, -- Location gets mode HL
                -- Exact default Fileinfo block
                { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
            })
        end
    }
})
