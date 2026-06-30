-- REQUIREMENTS: - You need treesitter client installed via your package manager (not npm). For Fedora, The tree-sitter package was manually downloaded and installed at `/usr/local/bin/tree-sitter` from https://github.com/tree-sitter/tree-sitter/releases since nvim.treesitter needed 0.26 version of tree-sitter.  This has to be updated manually or need to change it to a build from the `dnf` repo tree-sitter-cli, which currently ships only the 0.25 version
local treesitter = require("nvim-treesitter")

local ensure_installed = {
    -- "go", 
    -- "rust", 
    "typescript",
    "javascript",
    "tsx",
    "html",
    "css",
    "json",
    "bash",
    "http",
    "dart",
    "python",
    "markdown",
    "markdown_inline",
    -- "dockerfile",
}
-- Make sure that the above parsers are installed
-- or use TSInstall command to install parsers manually
-- To check the status of each parser, use `:che nvim-treesitter`
treesitter.install(ensure_installed)

vim.api.nvim_create_autocmd("FileType", { -- This auto command fires everytime a buffer is set
	pattern = "*", -- fire for all the file types
	callback = function(args)
        -- Locally store the buffer number and file type of that buffer
		local buf = args.buf
		local ft = vim.bo[buf].filetype

        -- Get the treesitter language name for the current file type
		local lang = vim.treesitter.language.get_lang(ft)
        -- If no matching parser found, fall back to the default, which is the nvim regex based highlights
		if not lang then
			return
		end

        -- Try to load the parser
		local ok_add = pcall(vim.treesitter.language.add, lang)
        -- Fallback if the parser is not found
		if not ok_add then
			return
		end

        -- Start treesitter highlights on the buffer
        -- Without this call, you would only get the nvim basic highlights, which misses many syntax groups (like class name in Flutter?)
		pcall(vim.treesitter.start, buf, lang)
	end,
})
