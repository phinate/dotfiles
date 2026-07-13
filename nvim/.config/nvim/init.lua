-- ============================================================
-- options
-- ============================================================
vim.g.mapleader = " "

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.number = true
vim.opt.signcolumn = "yes"
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.cursorcolumn = false
vim.opt.termguicolors = true
vim.opt.clipboard = "unnamedplus"
vim.opt.winborder = "rounded"
vim.opt.pumheight = 10
vim.opt.completeopt = "menu,menuone,noselect,popup"
vim.opt.formatoptions:remove({ "o" })

-- black-style paren indenting: single indent for continuations,
-- closing bracket dedented to the opening line (not the PEP8 hanging indent)
vim.g.python_indent = {
    open_paren = "shiftwidth()",
    nested_paren = "shiftwidth()",
    continue = "shiftwidth()",
    closed_paren_align_last_line = false,
}

-- ============================================================
-- plugins
-- ============================================================
vim.pack.add({
    { src = "https://github.com/ellisonleao/gruvbox.nvim" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = "https://github.com/mason-org/mason.nvim" },
    { src = "https://github.com/echasnovski/mini.pick" },
    { src = "https://github.com/echasnovski/mini.extra" },
    { src = "https://github.com/echasnovski/mini.pairs" },
    { src = "https://github.com/OXY2DEV/markview.nvim"},
    { src = "https://github.com/stevearc/oil.nvim" },
})

require("gruvbox").setup({ transparent_mode = true })
vim.cmd("colorscheme gruvbox")

require("mini.pick").setup()
require("mini.extra").setup()
require("mini.pairs").setup()
require("mason").setup()
require("oil").setup({
    lsp_file_methods = { enabled = true, timeout_ms = 1000, autosave_changes = true },
    columns = { "permissions", "icon" },
    float = { max_width = 0.7, max_height = 0.6, border = "rounded" },
    view_options = { show_hidden = true },
})

-- ============================================================
-- treesitter (0.12 / main branch idiom)
-- ============================================================
local ts_langs = { "python", "lua", "yaml", "haskell", "markdown", "bash", "json" }
require("nvim-treesitter").install(ts_langs)
vim.api.nvim_create_autocmd("FileType", {
    pattern = ts_langs,
    callback = function() pcall(vim.treesitter.start) end,
})

-- ============================================================
-- LSP
-- ============================================================
vim.lsp.config("lua_ls", {
    settings = { Lua = { workspace = { library = vim.api.nvim_get_runtime_file("", true) } } },
})

vim.lsp.config(
    "ty", {
        root_markers = {"uv.lock", "pyproject.toml", "ty.toml", ".git"}
    }
)

vim.lsp.enable({ "lua_ls", "ty", "yamlls", "hls" })

vim.diagnostic.config({
    virtual_text = true,
    severity_sort = true,
    float = { border = "rounded" },
})

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("user_lsp", { clear = true }),
    callback = function(ev)
        local buf = ev.buf
        local client = vim.lsp.get_client_by_id(ev.data.client_id)

        if client and client:supports_method("textDocument/completion") then
            vim.lsp.completion.enable(true, client.id, buf, { autotrigger = true })
        end

        -- <CR> accepts the selected completion if the popup is visible
        vim.keymap.set("i", "<CR>", function()
            if vim.fn.pumvisible() == 1 then
                return vim.fn.complete_info({ "selected" }).selected ~= -1
                    and "<C-y>" or "<C-y>" .. MiniPairs.cr()
            end
            return MiniPairs.cr()
        end, { expr = true, buffer = buf })

        local opts = { buffer = buf }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition,     opts)
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration,    opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references,     opts)
    end,
})

-- ============================================================
-- keymaps
-- ============================================================
local map = vim.keymap.set

map("n", "<leader>o", ":update<CR>:source<CR>")
map("n", "<leader>w", ":write<CR>")
map("n", "<leader>q", ":quit<CR>")
map({ "n", "v", "x" }, "<leader>y", '"*y')
map("n", "<leader>e", vim.diagnostic.open_float)
map("n", "<leader>v", ":e $MYVIMRC<CR>")
map("n", "<leader>s", ":e #<CR>")
map("n", "<leader>lf", vim.lsp.buf.format)
map("n", "<leader>r", ":e<CR>")  -- reload page

map("n", "<leader>f", ":Pick files tool='rg'<CR>")
map("n", "<leader>h", ":Pick help<CR>")
map("n", "<leader>O", ":Oil<CR>")
map("n", "<leader>F", function()
    require("mini.extra").pickers.lsp({ scope = "workspace_symbol" })
end)
map("n", "<leader>/", function()
    require("mini.pick").builtin.grep_live({ tool = "rg" })
end)
map("n", "<leader>?", function()
    require("mini.pick").builtin.grep_live({ tool = "rg", pattern = vim.fn.expand("<cword>") })
end)

-- centred jumps + clear search
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- ============================================================
-- python: select / yank / delete the def above the cursor
-- ============================================================
local function get_python_def_range()
    if vim.fn.search([[^\s*def\s\+\k\+]], "bW") == 0 then
        return nil, "No def found above"
    end
    local s, indent, last = vim.fn.line("."), vim.fn.indent(vim.fn.line(".")), vim.fn.line("$")
    local e, last_nonblank = s, s
    for l = s + 1, last do
        local text = vim.fn.getline(l)
        if text:match("%S") then
            if vim.fn.indent(l) <= indent then e = last_nonblank; break end
            e, last_nonblank = l, l
        else
            e = l
        end
    end
    if e == last and e > last_nonblank then e = last_nonblank end
    return s, e
end

local function with_def_range(action)
    return function()
        local s, e = get_python_def_range()
        if not s then vim.notify(e, vim.log.levels.INFO); return end
        action(s, e)
    end
end

map("n", "<leader>vm", with_def_range(function(s, e)
    vim.api.nvim_win_set_cursor(0, { s, 0 })
    vim.cmd("normal! V")
    vim.api.nvim_win_set_cursor(0, { e, 0 })
end))
map("n", "<leader>ym", with_def_range(function(s, e) vim.cmd(s .. "," .. e .. "y") end))
map("n", "<leader>dm", with_def_range(function(s, e) vim.cmd(s .. "," .. e .. "d") end))
