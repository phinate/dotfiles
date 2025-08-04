-- style & admin
vim.opt.termguicolors = true
vim.opt.tabstop = 4
vim.opt.winborder = "rounded"
vim.opt.clipboard = "unnamedplus"
vim.opt.signcolumn = "yes"
vim.opt.swapfile = false
vim.opt.cursorcolumn = false

-- leader & keybinds
vim.g.mapleader = " "
vim.keymap.set('n', '<leader>o', ':update<CR> :source<CR>')
vim.keymap.set('n', '<leader>w', ':write<CR>')
vim.keymap.set('n', '<leader>q', ':quit<CR>')
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>y', '"*y<CR>')
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
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
})

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

-- ruff
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup('lsp_attach_disable_ruff_hover', { clear = true }),
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client == nil then
			return
		end
		if client.name == 'ruff' then
			-- Disable hover in favor of Pyright
			client.server_capabilities.hoverProvider = false
		end
	end,
	desc = 'LSP: Disable hover capability from Ruff',
})

vim.lsp.enable({ "lua_ls", "pyright", "ruff" })
vim.lsp.config("pyright", {
	settings = {
		pyright = {
			-- Using Ruff's import organizer
			disableOrganizeImports = true,
		},
		python = {
			analysis = {
				-- Ignore all files for analysis to exclusively use Ruff for linting
				ignore = { '*' },
			},
		},
	},
})

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
			}
		}
	}
})

require "mini.pick".setup()
require "nvim-treesitter.configs".setup({
	ensure_installed = { "python" },
	highlight = { enable = true }
})

vim.keymap.set('n', '<leader>f', ":Pick files<CR>")
vim.keymap.set('n', '<leader>h', ":Pick help<CR>")
vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format)

require "gruvbox".setup({ transparent_mode = true })
vim.cmd("colorscheme gruvbox")
