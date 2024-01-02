-- Constants
vim.env.NVIM_SERVERNAME = vim.v.servername
vim.env.ZSH_VI_MODE_ENABLED = 0

-- Disable netrw

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwSettings = 1
vim.g.loaded_netrwFileHandlers = 1

-- Options
local set = vim.opt
set.termguicolors = true
set.expandtab = true
set.autoindent = true
set.copyindent = true
set.number = true
set.rnu = true
set.ignorecase = true
set.splitbelow = true
set.splitright = true
set.hidden = true
set.joinspaces = false
set.showmatch = false
set.backup = false
set.writebackup = false

--set.tabstop = 2
set.shiftwidth = 2
set.softtabstop = -1
set.scrolloff = 5
set.numberwidth = 1
set.cmdheight = 1
set.laststatus = 0
set.updatetime = 300
set.pumblend = 15
set.winblend = 15

set.mouse = 'a'
set.signcolumn = 'number'
set.background = 'dark'

set.formatoptions:append('nt')
set.formatoptions:remove('cro')
set.mps:append('<:>')
set.shortmess:append('c')
set.fillchars:append([[eob: ]])
function Modified_color_prefix() return vim.bo.modified and '%1*' or '%0*' end -- Highlight User0 / User1
set.rulerformat=[[%70(%=%{%v:lua.Modified_color_prefix()%}%F %([%{&ff}|%{(&fenc==""?&enc:&fenc).((exists("+bomb") && &bomb)?",B":"")}%k|%Y]%) %([%l,%v][%p%%] %)%)]]

local function terminal_options()
  vim.opt_local.number = false
  vim.opt_local.relativenumber = false
end

-- Options end

-- Auto commands
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

augroup('YankHighlight', { clear = true })
autocmd('TextYankPost', {
  group = 'YankHighlight',
  callback = function()
    vim.highlight.on_yank({ higroup = 'IncSearch', timeout = '1000' })
  end
})

augroup('RememberFolds', { clear = true })
autocmd('BufWinLeave', {
  group = 'RememberFolds',
  pattern = '*.*',
  callback = function()
    vim.cmd.mkview()
  end
})
autocmd('BufWinEnter', {
  group = 'RememberFolds',
  pattern = '*.*',
  command = 'silent! loadview'
})

augroup('TerminalOptions', { clear = true })
autocmd('TermOpen', {
  group = 'TerminalOptions',
  pattern = '*',
  callback = terminal_options
})

-- Auto commands end

-- Keymaps
vim.keymap.set('', '<space>', '<leader>', { remap = true }) -- Leader, remap so that it shows up in showcmd
vim.keymap.set('n', '<leader><space>', '<Nop>')

local function cursor_move(direction)
  if vim.fn.winnr() ~= vim.fn.winnr(direction) then
    vim.cmd.wincmd(direction)
  elseif direction == 'l' then
    vim.cmd.tabnext()
  elseif direction == 'h' then
    vim.cmd.tabprevious()
  end
end

 -- Move to pane (up/down/right/left) or tab (right/left), also in term
vim.keymap.set({'n', 't'}, '<C-J>', function() cursor_move('j') end)
vim.keymap.set({'n', 't'}, '<C-K>', function() cursor_move('k') end)
vim.keymap.set({'n', 't'}, '<C-L>', function() cursor_move('l') end)
vim.keymap.set({'n', 't'}, '<C-H>', function() cursor_move('h') end)
vim.keymap.set({'n', 't'}, '<M-l>', 'gt')
vim.keymap.set({'n', 't'}, '<M-h>', 'gT')

-- Yanking
vim.keymap.set({'n', 'v'}, '<M-y>', '"+y')
vim.keymap.set({'n', 'v'}, '<M-p>', '"+p')
vim.keymap.set('n', 'gp', [['`[' . strpart(getregtype(), 0, 1) . '`]']], { expr = true }) -- select previously pasted text
vim.keymap.set('n', '<M-i>', '"+yi')
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]])

-- Navigating tabs
for i=1,10 do
  vim.keymap.set({'n', 't'}, '<M-'.. tostring(i):sub(-1) ..'>', function() vim.cmd.tabnext(i) end)
end
-- Keymaps end

-- Plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- start (color scheme)
-- before doing anything (CursorHold)
-- when splitting panes (WinEnter)
-- when opening a file (BufReadPre)
-- when issuing the corresponding cmd for that plugin

require('lazy').setup({
  -- Colorschemes
  {
    'tanvirtin/monokai.nvim',
    lazy = false,
    config = function()
      require('monokai').setup {
        palette = {
          name = 'monokaime',
          base2 = '#000000',
          base5 = '#bebebe',
        }
      }
    end,
  },
  {
    'nvim/oxocarbon.nvim',
    dev = true,
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme('oxocarbon')
    end,
  },
  'ellisonleao/gruvbox.nvim',
  -- Colorschemes end
  {
    'rktjmp/hotpot.nvim', -- fennel compiler
    cmd = 'Fnlfile',
  },
  {
    'uga-rosa/ccc.nvim',
    event = 'VeryLazy',
  },
  {
    'nvim-treesitter/nvim-treesitter',
    event = 'BufReadPre',
    build = function()
      require("nvim-treesitter.install").update({ with_sync = true })
    end,
  },
  {
    'neovim/nvim-lspconfig',
    --event = 'VeryLazy',
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { 'williamboman/mason-lspconfig.nvim', 'hrsh7th/nvim-cmp', 'folke/neodev.nvim' },
    config = function()
      local opts = { noremap=true, silent=true }
      vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
      vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)

      local on_attach = function(client, bufnr)
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
        local bufopts = { noremap=true, silent=true, buffer=bufnr }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
        vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
        vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
        vim.keymap.set('n', '<leader>wl', function()
          print(vim.inspect(vim.lsp.buf.list_workleader_folders()))
        end, bufopts)
        vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, bufopts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
        vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, bufopts)
      end

      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      require('lspconfig').pyright.setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })
      require('lspconfig').lua_ls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })
      require('lspconfig').jdtls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })
      require('lspconfig').tsserver.setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })
    end
  },
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = { 'williamboman/mason.nvim' },
    opts = {
      ensure_installed = {
        'lua_ls',
        'pyright',
        'jdtls',
        'tsserver',
      }
    }
  },
  {
    'williamboman/mason.nvim',
    config = true,
  },
  {
    'folke/neodev.nvim',
    config = true,
  },
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-vsnip',
      'hrsh7th/vim-vsnip',
    },
    opts = function()
    local cmp = require('cmp')
      return {
        snippet = {
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'vsnip' },
        }, {
          { name = 'buffer' },
        }),
      }
    end,
  },
  {
    'glacambre/firenvim',
    cond = not not vim.g.started_by_firenvim,
    lazy = false,
    build = function()
      require("lazy").load({ plugins = { 'firenvim' }, wait = true })
      vim.fn["firenvim#install"](0)
    end,
    init = function()
      if not vim.g.started_by_firenvim then return end
      vim.g.firenvim_config = {
        localSettings = {
            [".*"] = {
                takeover = 'never'
            }
        }
      }
      vim.opt.background = 'light'
    end
  },
  {
    'alderz/smali-vim',
    ft = 'smali',
    init = function()
      vim.filetype.add {
        extension = { smali = 'smali' }
      }
    end,
  },
  {
    'ibhagwan/fzf-lua',
    cond = not not vim.fn.has('unix'),
    keys = {
      {--[['n',--]] '<C-s>', function() require('fzf-lua').files({ cmd = vim.env.FZF_DEFAULT_COMMAND }) end, { silent = true }},
      {--[['n',--]] '<C-b>', function() require('fzf-lua').buffers() end, { silent = true }},
    },
    cmd = {'GFiles', 'Grep', 'Help', 'Manpages', 'Colorschemes' },
    config = function()
      local fzf_lua = require('fzf-lua')
      local create_command = vim.api.nvim_create_user_command
      create_command('GFiles', function() fzf_lua.git_files() end, {})
      create_command('Grep', function() fzf_lua.live_grep() end, {})
      create_command('Help', function() fzf_lua.help_tags() end, {})
      create_command('Manpages', function() fzf_lua.man_pages() end, {})
      create_command('Colorschemes', function() fzf_lua.colorschemes() end, {})
    end
  },
  {
    'gbprod/substitute.nvim',
    lazy = false,
    keys = {
      { --[["n",--]] "s", "<cmd>lua require('substitute').operator()<cr>" },
      { --[["n",--]] "ss", "<cmd>lua require('substitute').line()<cr>" },
      { --[["n",--]] "S", "<cmd>lua require('substitute').eol()<cr>" },
      { --[["x",--]] "s", "<cmd>lua require('substitute').visual()<cr>",  mode = 'x' },
    },
  },
  {
    'numToStr/Comment.nvim',
    event = 'VeryLazy',
    config = true,
  },
  {
    'echasnovski/mini.nvim',
    lazy = false,
    config = function()
      require('mini.cursorword').setup()
      vim.g.miniindentscope_disable = true
      require('mini.indentscope').setup()
      require('mini.jump2d').setup()
      --require('mini.starter').setup()
      require('mini.surround').setup()
      require('mini.ai').setup()
      require('mini.trailspace').setup()
      require('mini.jump').setup()
      require('mini.jump2d').setup()
    end,
  },
  {
    'cbochs/portal.nvim',
    event = 'VeryLazy',
    config = function()
      require("portal").setup()
      vim.keymap.set("n", "<leader>o", "<cmd>Portal jumplist backward<cr>")
      vim.keymap.set("n", "<leader>i", "<cmd>Portal jumplist forward<cr>")
    end
  },
  {
    'samjwill/nvim-unception',
    event = 'VeryLazy',
  },
  {
    'nvim-tree/nvim-tree.lua',
    lazy = false,
    config = function()
      require("nvim-tree").setup({
        hijack_netrw = true,
        actions = {
          open_file = {
            quit_on_open = true,
          },
        },
      })
      local function open_nvim_tree(data)
        -- buffer is a directory
        --
        if vim.fn.isdirectory(data.file) == 1 then
          vim.cmd.cd(data.file)
        --elseif data.file == "" and vim.bo[data.buf].buftype == "" then
        else
          return
        end
        require("nvim-tree.api").tree.open()
      end

      vim.keymap.set("n", "<C-q>", function()
        require("nvim-tree.api").tree.toggle()
        local keys = vim.api.nvim_replace_termcodes('<C-W><C-O>', true, false, true)
        vim.api.nvim_feedkeys(keys, 'n', false)
      end)

      vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })
    end
  },
  {
    'chomosuke/term-edit.nvim',
    event = 'VeryLazy',
    opts = {
      prompt_end = '~ ❯ '
    }
  },
  {
    'tpope/vim-dadbod',
    event = 'VeryLazy',
  },
},
{
  defaults = { lazy = true },
  dev = { path = vim.fn.stdpath('config') .. '/local_plugins' }
})

