-- plugins
local use = require('packer').use
require("packer").startup(function()
    use 'wbthomason/packer.nvim' -- パッケージマネージャー

    use 'neovim/nvim-lspconfig' -- ネイティブのLSPプラグイン用の設定
    use 'williamboman/mason.nvim' -- LSPサーバー、Linter、Formatterなどを簡単にインストール＆管理する
    use 'williamboman/mason-lspconfig.nvim' -- masonとnvim-lspconfigをつなぐ役割

    use 'hrsh7th/nvim-cmp' -- 補完プラグイン
    use 'hrsh7th/cmp-nvim-lsp' -- lsp用の補完ソース
    use 'hrsh7th/cmp-nvim-lsp-signature-help' -- 関数の補完の表示をかっこよくする
    use 'hrsh7th/cmp-path' -- パス補完用の補完ソース
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-cmdline' -- vimのコマンドライン用の補完ソース
    use 'saadparwaiz1/cmp_luasnip'
    use 'L3MON4D3/LuaSnip'


    use 'folke/tokyonight.nvim' -- おしゃれなカラースキーム
    use 'kyazdani42/nvim-web-devicons' -- おしゃれなアイコンフォントを使う
    use 'onsails/lspkind.nvim' -- うまく使えない
    use 'j-hui/fidget.nvim' -- 右下のほうにLSPの解析状況の進捗を表示するおしゃれなやつ
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.0',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }
    use { 'akinsho/bufferline.nvim', tag = "v2.*" }

    use 'windwp/nvim-autopairs'
    use { 'TimUntersberger/neogit', requires = 'nvim-lua/plenary.nvim' }

    use 'tikhomirov/vim-glsl'

    use 'tpope/vim-surround'
    -- use 'tpope/vim-fugitive'
    -- use 'airblade/vim-gitgutter'
    use 'TimUntersberger/neogit'
    use 'sindrets/diffview.nvim'
    use 'lewis6991/gitsigns.nvim'
end)
