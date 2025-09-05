-- style & admin
vim.opt.termguicolors = true
vim.opt.tabstop = 4
vim.opt.winborder = "rounded"
vim.opt.clipboard = "unnamedplus"
vim.opt.signcolumn = "yes"
vim.opt.swapfile = false
vim.opt.cursorcolumn = false
vim.opt.number = true

-- leader & keybinds
vim.g.mapleader = " "
vim.keymap.set('n', '<leader>o', ':update<CR> :source<CR>')
vim.keymap.set('n', '<leader>w', ':write<CR>')
vim.keymap.set('n', '<leader>q', ':quit<CR>')
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>y', '"*y<CR>')
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>v', ':e $MYVIMRC<CR>')
-- toggle between two files
vim.keymap.set('n', '<leader>s', ':e #<CR>')

-- don't start new comment paragraph with 'o' or 'O'
-- when in comment context (enter still works)
-- okay apparently this needs to be sourced to work? idk...
vim.opt.formatoptions:remove({ "o" })

-- plugins
vim.pack.add({
	{ src = "https://github.com/ellisonleao/gruvbox.nvim" },
	{ src = "https://github.com/echasnovski/mini.pick" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/echasnovski/mini.extra" },
	{ src = "https://github.com/stevearc/oil.nvim" },
})

require "mini.pick".setup()
require "mini.extra".setup()
require "mason".setup()
require "nvim-treesitter.configs".setup({
	ensure_installed = { "python" },
	highlight = { enable = true }
})
require "oil".setup()

-- plugin-specific maps
vim.keymap.set('n', '<leader>f', ":Pick files tool='rg'<CR>")
vim.keymap.set('n', '<leader>h', ":Pick help<CR>")
vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format)
vim.keymap.set('n', '<leader>O', ":Oil<CR>")

-- map: fuzzy-find symbols (functions/classes/etc.) across the project,
--    <CR> opens the file at the symbol's definition.
vim.keymap.set("n", "<leader>F", function()
	require("mini.extra").pickers.lsp({ scope = "workspace_symbol" })
end, { desc = "Search symbols (workspace)" })

vim.keymap.set('n', '<leader>/', function()
  require("mini.pick").builtin.grep_live({
    tool = 'rg',
  })
end)

vim.keymap.set('n', '<leader>?', function()
  require("mini.pick").builtin.grep_live({
    tool = 'rg',
	pattern = vim.fn.expand('<cword>'),
  })
end)

-- lsp
vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client:supports_method('textDocument/completion') then
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		end
	end,
})
vim.cmd("set completeopt+=noselect")

-- set some keymaps (overwriting built-ins) that actually go to definitions etc
vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('lsp_keys', { clear = true }),
	callback = function(ev)
		local buf = ev.buf
		vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = buf, desc = 'LSP: definition' })
		vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = buf, desc = 'LSP: declaration' })
		vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { buffer = buf, desc = 'LSP: implementation' })
		vim.keymap.set('n', 'gr', vim.lsp.buf.references, { buffer = buf, desc = 'LSP: references' })
	end,
})

vim.lsp.enable({ "lua_ls", "ty", "ruff", "yamlls" })

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
			}
		}
	}
})

require "gruvbox".setup({ transparent_mode = true })
vim.cmd("colorscheme gruvbox")
