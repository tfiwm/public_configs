-- Adds Mason* commands to install and manage LSPs
require("mason").setup()

-- LSP keymaps are set buffer-local inside LspAttach autocmd below

-- Configure the look and functioning of diagnostic messages
------------------------------------------------------------
-- These will be the icons used for different severity
local diagnostic_signs = {
    Error = "\u{f057} ",
    Warn = "\u{f071} ",
    Hint = "\u{ea61}",
    Info = "\u{f05a}",
}
vim.diagnostic.config({
    -- Inline diagnostic message and its style
    virtual_text = { prefix = "●", spacing = 4 },
    signs = {
        -- Set custom icons to improve the sign column icons of diagnostic messages
        text = {
            [vim.diagnostic.severity.ERROR] = diagnostic_signs.Error,
            [vim.diagnostic.severity.WARN] = diagnostic_signs.Warn,
            [vim.diagnostic.severity.INFO] = diagnostic_signs.Info,
            [vim.diagnostic.severity.HINT] = diagnostic_signs.Hint,
        },
    },
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
        border = "rounded",
        source = true,
        header = "",
        prefix = "",
        focusable = false,
        style = "minimal",
    },
})

-- Configuration for various LSPs
---------------------------------
-- This should work without any completion plugins
local capabilities = vim.lsp.protocol.make_client_capabilities()
-- Merge the above native capabilities with that from Mini Completions by merging both the capabilities table and prefer Mini's capabilities
capabilities = vim.tbl_deep_extend("force", capabilities, require("mini.completion").get_lsp_capabilities())
-- Set the capabilities that we setup, here '*' means for all LSPs
vim.lsp.config("*", { capabilities = capabilities })

-- Language specific configuration
-----------------------------
vim.lsp.config("lua_ls", { -- for Lua
    settings = {
        Lua = {
            diagnostics = { globals = { "vim" } }, -- define 'vim' as a global constant
            telemetry = { enable = false }
        },
    },
})


-- Enable LSP inlay hints by default
------------------------------------
-- Some servers (e.g. dartls) use dynamic capability registration, so
-- inlayHint may not be advertised at LspAttach time. Re-trigger when
-- the server registers capabilities later.
-- vim.lsp.handlers['client/registerCapability'] = (function(overridden)
--     return function(err, res, ctx)
--         local result = overridden(err, res, ctx)
--         local client = vim.lsp.get_client_by_id(ctx.client_id)
--         if client then
--             for bufnr, _ in pairs(client.attached_buffers) do
--                 -- Guard to make sure that we don't enable it if it has already been done
--                 if client:supports_method("textDocument/inlayHint")
--                     and not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
--                 then
--                     vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
--                 end
--             end
--         end
--         return result
--     end
-- end)(vim.lsp.handlers['client/registerCapability'])


vim.lsp.config("dartls", {
    root_dir = function(bufnr, callback)
        local root_files = { "pubspec.yaml", ".git" }
        local root_dir = vim.fs.root(bufnr, root_files)
        local bufname = vim.api.nvim_buf_get_name(bufnr)
        -- print(string.format("[%s] [LSP ROOTDIR] buffer %d (%s)", os.date("%H:%M:%S"), bufnr, bufname))
        -- print(string.format("%s (nr): %s (implicit) is the Buffer type of %d:%s",vim.bo[bufnr].buftype, vim.bo.buftype, bufnr, bufname))
        if string.match(bufname, "^diffview://") then
            vim.notify("Disabled LSP on diffview URI", vim.log.levels.WARN)
            return
        end
        if string.match(bufname, "^codediff://") then
            vim.notify("Disabled LSP on codediff URI", vim.log.levels.WARN)
            return
        end
        if root_dir then
            callback(root_dir)
            --     print(string.format("[%s] [LSP ROOTDIR] rootdir is true for %d (%s)", os.date("%H:%M:%S"), bufnr, bufname))
            --     vim.notify(string.format("[%s] [LSP ROOTDIR] buffer %d (%s)", os.date("%H:%M:%S"), bufnr, bufname),
            --         vim.log.levels.INFO)
        end
    end,
})
vim.lsp.config("pyright", {})
vim.lsp.config("bashls", {})
vim.lsp.config("ts_ls", {})
vim.lsp.config("clangd", {})

-- LSP issue of codediff buffers can be resolved by disabling LSP with the help of the :CodeDiff origin/HEAD... command
-- mentioned here https://github.com/esmuellert/codediff.nvim/issues/140

-- Enable different LSPs
------------------------
-- Use `MasonInstall <LSP name>` to install required LSPs
-- OR Use `Mason` to open Mason interactively, find the LSP you want, use `i` to install it.
-- To check the binary path of an LSP, use ':lua print(vim.fn.exepath("lua-language-server")) (or another LSP name)
vim.lsp.enable({
    -- Use these one from Mason
    "lua_ls",
    "pyright",
    "bashls",
    "ts_ls",
    "clangd",
    ---- Instead of Mason, uses the dart LSP that comes with Flutter install,
    ---- lspconfig starts like this - { "dart", "language-server", "--protocol=lsp" }
    "dartls",
    -- "efm",
    -- "marksman",
    -- "gopls",
    -- "rust_analyzer",
})

----------------------------
-- LSP RELATED AUTO COMMANDS
----------------------------

----------------------------------------------------------------------------
-- AUTOMATICALLY HIGHLIGHT THE CURRENT SYMBOL
-- Highlight all occurrences of the symbol under the cursor after the
-- cursor has been still for `updatetime` ms. Cleared when the cursor moves.
----------------------------------------------------------------------------

-- Create a single, self-cleaning autocommand group
local lsp_highlight_grp = vim.api.nvim_create_augroup("LspDocumentHighlight", { clear = true })

vim.api.nvim_create_autocmd("LspAttach", {
  group = lsp_highlight_grp,
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    -- 1. EFFICIENT FILTERING: create auto command unless the server can't highlight
    if client and client:supports_method("textDocument/documentHighlight") then

        -- 2. FILETYPE FILTERING (Optional): Whitelist your preferred languages
        -- This handles your Dart, C++, Python, etc. perfectly via internal filetype strings.
        -- local allowed_filetypes = { lua = true, python = true, javascript = true, typescript = true, dart = true, c = true, cpp = true }
        -- if not allowed_filetypes[vim.bo[bufnr].filetype] then
        --   return
        -- end

        -- 3. BUFFER-LOCAL AUTOCMDS: Bind triggers only to this specific file buffer
        -- Creating a sub-group tied directly to this buffer protects performance.
        local buffer_group = vim.api.nvim_create_augroup("LspHighlights_" .. bufnr, { clear = true })

        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
          group = buffer_group,
          buffer = bufnr,
          callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
          group = buffer_group,
          buffer = bufnr,
          callback = vim.lsp.buf.clear_references,
        })

        -- 4. CLEANUP: Erase the autocommands automatically if the LSP disconnects
        vim.api.nvim_create_autocmd("LspDetach", {
          group = lsp_highlight_grp,
          buffer = bufnr,
          callback = function()
            vim.lsp.buf.clear_references()
            -- Safely target and wipe only the autocommands tied to this specific file buffer
            pcall(vim.api.nvim_clear_autocmds, { group = "LspHighlights_" .. bufnr, buffer = bufnr })
          end,
        })
    end

    -- Buffer-local LSP keymaps
    -- NOTE: gd/gD below are LSP-buffer-only overrides (buffer = bufnr).
    -- On non-LSP files, native gd/gD keyword-search still work untouched.
    -- nvim 0.12's built-in gr* family (grr/gri/grt/grn/gra/grx) and gO are
    -- intentionally NOT remapped here — they work unshadowed. fzf-lua equivalents
    -- and the remaining LSP actions live under <leader>i* (Intelligence group).
    local map = vim.keymap.set
    local fzf = require("fzf-lua")

    -- Enable inlay hints per-buffer if the server supports them.
    -------------------------------------------------------------
    -- Servers using dynamic registration (e.g. dartls) are handled by the
    -- client/registerCapability wrapper above. We need this gating to prevent
    -- making this call prematurely for dynamic registration servers like dartls
    -- if client:supports_method("textDocument/inlayHint") then
    --     vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    -- end

    map("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "Hover documentation" })
    map("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "Go to definition" })
    map("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr, desc = "Go to declaration" })
    map("n", "gl", vim.diagnostic.open_float, { buffer = bufnr, desc = "Line diagnostics" })

    -- <leader>i* — Intelligence/LSP group (all lowercase, no shift). fzf pickers
    -- complement the built-in gr* family; ix covers the grx codelens gap.
    map("n", "<leader>ia", fzf.lsp_code_actions,      { buffer = bufnr, desc = "Code actions" })
    map("n", "<leader>in", vim.lsp.buf.rename,         { buffer = bufnr, desc = "Rename symbol" })
    map("n", "<leader>if", vim.lsp.buf.format,         { buffer = bufnr, desc = "Format buffer" })
    map("n", "<leader>id", vim.diagnostic.open_float,  { buffer = bufnr, desc = "Line diagnostics" })
    map("n", "<leader>is", fzf.lsp_workspace_symbols,  { buffer = bufnr, desc = "Workspace symbols" })
    map("n", "<leader>ic", fzf.lsp_incoming_calls,     { buffer = bufnr, desc = "Incoming calls" })
    map("n", "<leader>ig", fzf.lsp_outgoing_calls,     { buffer = bufnr, desc = "Outgoing calls" })
    map("n", "<leader>ir", fzf.lsp_references,         { buffer = bufnr, desc = "References" })
    map("n", "<leader>ii", fzf.lsp_implementations,    { buffer = bufnr, desc = "Implementations" })
    map("n", "<leader>it", fzf.lsp_typedefs,           { buffer = bufnr, desc = "Type definition" })
    map("n", "<leader>io", fzf.lsp_document_symbols,   { buffer = bufnr, desc = "Document symbols (outline)" })
    map("n", "<leader>ix", vim.lsp.codelens.run,       { buffer = bufnr, desc = "Run codelens" })
  end,
})

