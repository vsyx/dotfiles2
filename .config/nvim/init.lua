require('impatient')
require('user.plugins')

vim.g.do_filetype_lua = 1
vim.opt.termguicolors = true
vim.opt.background = 'dark'
vim.cmd [[ 
	colorscheme gruvbox
	highlight Normal guibg=black
]]
