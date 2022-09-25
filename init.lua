require("basic")
require("plugins")

vim.g.mapleader = ' '

local h = require('null-ls.helpers')

local methods = require("null-ls.methods")

local DIAGNOSTICS = methods.internal.DIAGNOSTICS

-- local pattern = "(^.+)\((\d+)\): (.+) #(\d+): (.+)"
local ifort_builtin = h.make_builtin({
    name = "ifort",
    method = DIAGNOSTICS,
    filetypes = { "fortran" },
    generator_opts = {
        command = "ifort",
        args = {
            "--syntax-only",
            "$FILENAME",
        },
        format = "line",
        to_stdin = false,
        from_stderr = true,
        to_temp_file = true,
        on_output = h.diagnostics.from_pattern(
        -- "[^:]+:(%d+): (.+)  %[(.+)%/.+%] %[%d+%]",
            "^.+%((%d+)%): (.+) #%d+: (.+)",
            { "row", "severity", "message" },
            {
                severities = {
                    ["error"] = h.diagnostics.severities["error"],
                    -- build = h.diagnostics.severities["warning"],
                    -- whitespace = h.diagnostics.severities["hint"],
                    -- runtime = h.diagnostics.severities["warning"],
                    -- legal = h.diagnostics.severities["information"],
                    -- readability = h.diagnostics.severities["information"],
                },
            }
        ),
        check_exit_code = function(code)
            return code >= 1
        end,
    },
    factory = h.generator_factory,
})


local fortran_icon = {
    icon = '',
    color = "#519aba",
    cterm_color = 67,
    name = "fortran",
}
require('nvim-web-devicons').set_icon {
    ["f90"] = fortran_icon,
    ["f03"] = fortran_icon,
    ["f08"] = fortran_icon,
    ["f#"] = fortran_icon,
    ["fortran"] = fortran_icon
}

-- 1. LSP Server management
require("aerial").setup({
    layout = {
        max_width = { 40, 0.2 },
        width = 30,
        min_width = { 20 },
        default_direction = "right"
    },
    on_attach = function(bufnr)
        -- Toggle the aerial window with <leader>a
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>a', '<cmd>AerialToggle!<CR>', {})
        -- Jump forwards/backwards with '{' and '}'
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '{', '<cmd>AerialPrev<CR>', {})
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '}', '<cmd>AerialNext<CR>', {})
        -- Jump up the tree with '[[' or ']]'
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '[[', '<cmd>AerialPrevUp<CR>', {})
        vim.api.nvim_buf_set_keymap(bufnr, 'n', ']]', '<cmd>AerialNextUp<CR>', {})
    end
})
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
    require('aerial').on_attach(client, bufnr)
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
local lspconfig = require('lspconfig')
require('mason').setup()
require('mason-lspconfig').setup()
require('mason-lspconfig').setup_handlers({ function(server)
    local opt = {
        capabilities = capabilities,
        on_attach = on_attach
    }
    lspconfig[server].setup(opt)

    -- Language server specific settings
    lspconfig.sumneko_lua.setup {
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
    -- lspconfig.gopls.setup {
    --     capabilities = capabilities,
    --     on_attach = on_attach,
    --     settings = {
    --         gopls = {
    --             analyses = {
    --                 fillstruct = true,
    --             },
    --             staticcheck = true,
    --             completeUnimported = true,
    --             usePlaceholders = true,
    --         },
    --     },
    -- }
    lspconfig.fortls.setup {
        cmd = {
            "fortls", "--notify_init", "--hover_signature", "--hover_language=fortran", "--lowercase_intrinsics"
        },
        capabilities = capabilities,
        on_attach = on_attach,
    }
end })

local null_ls = require('null-ls')
require('mason-null-ls').setup()
require('mason-null-ls').setup_handlers {
    -- cpplint = function ()
    --     null_ls.register(null_ls.builtins.diagnostics.cpplint)
    -- end
}
null_ls.setup {
    sources = {
        null_ls.builtins.formatting.fprettify.with({
            extra_args = {
                "--indent", "4",
                "--whitespace", "3",
                "--strict-indent",
                "--enable-decl",
                "--case", "1", "1", "1", "0"
            }
        }),
        ifort_builtin,
    },
    capabilities = capabilities,
    on_attach = on_attach
}


local cmp = require 'cmp'
local luasnip = require 'luasnip'
local lspkind = require('lspkind')

local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup {
    formatting = {
        format = lspkind.cmp_format({
            mode = 'symbol_text', -- show only symbol annotations
            maxwidth = 60, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
            ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
            before = function(entry, vim_item)
                vim_item.menu = entry.source.name
                return vim_item
            end
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
        ['<C-j>'] = cmp.mapping(function(fallback)
            if luasnip.expand_or_jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<C-k>'] = cmp.mapping(function(fallback)
            if luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif has_words_before() then
                cmp.complete()
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

-- vim.cmd("imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>'")
-- vim.cmd("inoremap <silent> <S-Tab> <cmd>lua require'luasnip'.jump(-1)<Cr>")
-- vim.cmd("snoremap <silent> <Tab> <cmd>lua require('luasnip').jump(1)<Cr>")
-- vim.cmd("snoremap <silent> <S-Tab> <cmd>lua require('luasnip').jump(-1)<Cr>")
-- vim.cmd("imap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'")
-- vim.cmd("smap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'")


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

require('Comment').setup()

local cb = require("comment-box")
vim.keymap.set({ "n", "v" }, "<Leader>bb", function() cb.cbox(20) end, {})
vim.keymap.set("n", "<Leader>e", ":Neotree filesystem toggle left<CR>")
require("luasnip.loaders.from_vscode").lazy_load()
-- opt.termguicolors = true
