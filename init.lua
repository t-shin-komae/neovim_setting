require("basic")
require("plugins")

vim.g.mapleader = ' '


-- 1. LSP Server management

local on_attach = function(client, bufnr)
    local bufopts = { noremap = true, silent = true, buffer = bufnr }

    vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', bufopts)
    vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', bufopts)
    vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', bufopts)
    vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', bufopts)
    vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', bufopts)
    vim.keymap.set('n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', bufopts)
    vim.keymap.set('n', 'gn', '<cmd>lua vim.lsp.buf.rename()<CR>', bufopts)
    vim.keymap.set('n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<CR>', bufopts)
    if client.resolved_capabilities.document_formatting then
        vim.keymap.set("n", "<Leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", bufopts)
    elseif client.resolved_capabilities.document_range_formatting then
        vim.keymap_set("v", "<Leader>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", bufopts)
    end

    local opts = { noremap = true, silent = true }
    vim.keymap.set('n', 'ge', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
    vim.keymap.set('n', 'g]', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
    vim.keymap.set('n', 'g[', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
end

-- Reference highlight
vim.cmd [[
augroup lsp_document_highlight
  autocmd!
  autocmd CursorHold,CursorHoldI * lua vim.lsp.buf.document_highlight()
  autocmd CursorMoved,CursorMovedI * lua vim.lsp.buf.clear_references()
augroup END
]]

local capabilities = require('cmp_nvim_lsp').update_capabilities(
    vim.lsp.protocol.make_client_capabilities()
)
require('mason').setup()
require('mason-lspconfig').setup_handlers({ function(server)
    local opt = {
        capabilities = capabilities,
        on_attach = on_attach
    }
    require('lspconfig')[server].setup(opt)
end })

require('lspconfig').sumneko_lua.setup {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
        Lua = {
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { 'vim' },
            },
        },
    },
}


local cmp = require 'cmp'
local luasnip = require 'luasnip'
local lspkind = require('lspkind')

cmp.setup {
    formatting = {
        format = lspkind.cmp_format({
            mode = 'symbol_text', -- show only symbol annotations
            maxwidth = 60, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
            ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)

        })
    },

    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },
        ['<C-k>'] = cmp.mapping(function(fallback)
            if luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { 'i', 's' }),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'nvim_lsp_signature_help' },
    }, {
        { name = 'buffer' },
    }),
}

cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    })
})


-- -- 2. build-in LSP function
-- LSP handlers
-- vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
--     vim.lsp.diagnostic.on_publish_diagnostics, opts
-- )


-- キーマッピング


vim.keymap.set('n', 'j', 'gj')
vim.keymap.set('n', 'gj', 'j')
vim.keymap.set('n', 'k', 'gk')
vim.keymap.set('n', 'gk', 'k')


vim.keymap.set('n', '<Leader>h', ':<C-u>split<CR><C-w>j')
vim.keymap.set('n', '<Leader>v', ':<C-u>vsplit<CR><C-w>l')

vim.keymap.set('t', '<ESC>', '<C-\\><C-n>')


local telescope = require('telescope.builtin')
vim.keymap.set('n', '#ff', telescope.find_files)
vim.keymap.set('n', '#gf', telescope.git_files)
vim.keymap.set('n', '#lg', telescope.live_grep)
vim.keymap.set('n', '#b', telescope.buffers)
vim.keymap.set('n', '#h', telescope.help_tags)

local actions = require("telescope.actions")
require('telescope').setup {
    defaults = {
        mappings = {
            n = {
                ["q"] = actions.close
            }
        }
    }
}
--
vim.cmd('colorscheme tokyonight')
-- require"fidget".setup{}
require('lualine').setup()
require('bufferline').setup {}
require('nvim-autopairs').setup {} -- ちゃんと設定しろ
require('neogit').setup {}
require('diffview').setup {}
require('gitsigns').setup()
-- opt.termguicolors = true
