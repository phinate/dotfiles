-- style & admin
vim.opt.termguicolors = true
vim.opt.tabstop = 4 -- A TAB character looks like 4 spaces
vim.opt.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
vim.opt.softtabstop = 4 -- Number of spaces inserted instead of a TAB character
vim.opt.shiftwidth = 4 -- Number of spaces inserted when indentingim.opt.tabstop = 4
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


-- core helper: find and return {start_line, end_line}
local function get_python_def_range()
  -- nearest def above
  local found = vim.fn.search([[^\s*def\s\+\k\+]], 'bW')
  if found == 0 then
    return nil, "No def found above"
  end

  local start_line   = vim.fn.line('.')
  local start_indent = vim.fn.indent(start_line)
  local last_line    = vim.fn.line('$')

  local end_line = start_line
  local last_nonblank_in_block = start_line

  for l = start_line + 1, last_line do
    local text = vim.fn.getline(l)
    if text:match('%S') then
      local ind = vim.fn.indent(l)
      if ind <= start_indent then
        end_line = last_nonblank_in_block
        break
      else
        end_line = l
        last_nonblank_in_block = l
      end
    else
      end_line = l
    end
  end

  if end_line == last_line and end_line > last_nonblank_in_block then
    end_line = last_nonblank_in_block
  end

  return start_line, end_line
end

-- [m: select method
local function select_python_def()
  local s, e = get_python_def_range()
  if not s then
    vim.notify(e, vim.log.levels.INFO)
    return
  end
  vim.api.nvim_win_set_cursor(0, { s, 0 })
  vim.cmd('normal! V')
  vim.api.nvim_win_set_cursor(0, { e, 0 })
end

-- <leader>ym: yank method
local function yank_python_def()
  local s, e = get_python_def_range()
  if not s then
    vim.notify(e, vim.log.levels.INFO)
    return
  end
  vim.cmd(string.format("%d,%dy", s, e))
end

-- <leader>dm: delete method
local function delete_python_def()
  local s, e = get_python_def_range()
  if not s then
    vim.notify(e, vim.log.levels.INFO)
    return
  end
  vim.cmd(string.format("%d,%dd", s, e))
end

-- keymaps
vim.keymap.set('n', '<leader>vm', select_python_def, { desc = 'Select python def' })
vim.keymap.set('n', '<leader>ym', yank_python_def, { desc = 'Yank python def' })
vim.keymap.set('n', '<leader>dm', delete_python_def, { desc = 'Delete python def' })
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

vim.lsp.enable({ "lua_ls", "ty",  "yamlls" })

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
