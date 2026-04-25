-- ~/.config/nvim/init.lua
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = " "

-- 设置 HTTP 代理（用于插件下载）
vim.env.HTTP_PROXY = "http://httpproxy-headless.kubebrain.svc.pjlab.local:3128"
vim.env.HTTPS_PROXY = "http://httpproxy-headless.kubebrain.svc.pjlab.local:3128"

-- 加载基础设置
require("core.settings")
-- 加载插件系统
require("plugins")
-- 加载快捷键配置
require("keymaps")

-- （可选）加载快捷键和自动命令
-- require("core.keymaps")
-- require("core.autocmds")
-- 禁用 JIT 编译缓存（防止写入 /tmp）
vim.o.joinspaces = false
vim.o.hidden = true
vim.o.lazyredraw = true
vim.o.updatetime = 300
vim.o.shortmess = vim.o.shortmess .. 'c'

-- ============================
-- 折叠最终版：零报错 za 直接用
-- ============================
vim.o.foldmethod = "syntax"
vim.o.foldlevel = 99
vim.o.foldenable = true
vim.opt.fillchars:append({ fold = " " })

