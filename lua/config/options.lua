-- Set leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Disable netrw early
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Only set the most essential options
vim.cmd([[
  set number
  set relativenumber
  set tabstop=2
  set shiftwidth=2
  set expandtab
  set autoindent
  set smartindent
  set nowrap
  set ignorecase
  set smartcase
  set hlsearch
  set incsearch
  set cursorline
  set termguicolors
  set background=dark
  set signcolumn=yes
  set noshowmode
  set splitright
  set splitbelow
  set noswapfile
  set nobackup
  set undofile
  set updatetime=50
  set scrolloff=8
  set sidescrolloff=8
  set cmdheight=1
  set encoding=utf-8
  set mouse=a
  set pumheight=10
  set backspace=indent,eol,start
  set clipboard=unnamedplus
  set completeopt=menuone,noselect
  set iskeyword+=-
]])

-- Create undodir safely
local undodir = vim.fn.expand("~/.vim/undodir")
if vim.fn.isdirectory(undodir) == 0 then
  vim.fn.mkdir(undodir, "p")
end
vim.cmd("set undodir=" .. undodir)
