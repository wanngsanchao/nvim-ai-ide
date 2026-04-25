-- ~/.config/nvim/lua/core/settings.lua
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.encoding = "utf-8"
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.mouse = "a"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.termguicolors = true  -- 启用真彩色（对 Tree-sitter 高亮很重要）

-- 兼容 Vimscript 风格
vim.cmd("syntax on")
vim.cmd("filetype plugin indent on")
