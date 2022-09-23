local opt = vim.opt
opt.hidden = true

opt.encoding      = 'utf-8' 
opt.fileencoding  = 'utf-8'
opt.fileencodings = 'utf-8'

opt.bomb = false

-- backspace動作をindentと改行とinsertの開始に許す
opt.backspace = "indent,eol,start"

-- backup系
opt.backup = false
opt.swapfile = false

opt.fileformats = "unix,dos,mac"

opt.expandtab  = true
opt.tabstop    = 4
opt.shiftwidth = 4

opt.clipboard:append('unnamedplus')

opt.mouse = 'a'

opt.number = true

opt.signcolumn = 'yes'
