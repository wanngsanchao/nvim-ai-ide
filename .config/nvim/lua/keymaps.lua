-- ~/.config/nvim/lua/core/keymaps.lua
local function map(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = opts.silent ~= false
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- LSP 快捷键（按需加载，在 LSP attach 时绑定更佳，此处简化）
-- map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
-- map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
-- map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
-- map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
-- map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
-- map("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
-- map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>")

-- ~/.config/nvim/lua/keymaps.lua
local opts = { noremap = true, silent = true }
local iopts = { silent = true }  -- Insert 模式通常不设 noremap

-- === Normal 模式 (n) ===
vim.keymap.set("n", "<leader>l", vim.lsp.buf.definition, opts)
vim.keymap.set("n", ",l", vim.lsp.buf.definition, opts)
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
vim.keymap.set("n", "lp", vim.lsp.buf.references, opts)
vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)

-- 基础编辑（Normal）
vim.keymap.set("n", "<C-s>", ":w!<CR>", opts)           -- 保存
vim.keymap.set("n", "<C-q>", ":q!<CR>", opts)           -- 退出
vim.keymap.set("n", "<C-a>", "<S-^>", opts)         -- 行首
vim.keymap.set("n", "<C-e>", "<S-$>", opts)          -- 行尾
vim.keymap.set("n", "<C-c>", "yy", opts)          -- 复制
vim.keymap.set("n", "<C-v>", "p", opts)          -- 黏贴
vim.keymap.set("n", "<C-z>", "u", opts)          -- 撤销
vim.keymap.set("n", "<s-f>", "1G", opts)          -- 文件第一行
vim.keymap.set("n", "<C-d>", "dd", opts)          -- 使用ctrl+d 来代替dd删除当前行
vim.keymap.set("n", "<C-u>", "d0", opts)          -- d0 字母d+数字0删除光标到行首的部分
vim.keymap.set("n", "<C-j>", "d$", opts)          -- d$ 字母d+特殊字符$删除光标到行尾
vim.keymap.set("n", "<tab>", "<s->>>", opts)          -- 使用tab建，代替shift+>> 进行向右缩进
vim.keymap.set("n", "<s-tab>", "<s-<><", opts)          -- "使用shift+tab建，代替shift+<< 进行向左缩进

-- vim.keymap.set("n", "<C-e>", ":e!<CR>", opts)          -- 重载
vim.keymap.set("n", "<C-t>", ":tabnew<CR>", opts)      -- 新标签页
vim.keymap.set("n", "<Tab>", ":tabnext<CR>", opts)     -- 下一个标签
vim.keymap.set("n", "<S-Tab>", ":tabprev<CR>", opts)   -- 上一个标签

-- === Insert 模式 (i) ===
vim.keymap.set("i", "<C-s>", "<Esc>:w!<CR>", iopts)    -- Insert 模式下 Ctrl+s 保存并继续输入
vim.keymap.set("i", "<C-q>", "<Esc>:q!<CR>", iopts)     -- Insert 模式下退出
vim.keymap.set("i", "<C-d>", "<C-u>", iopts)           -- 删除当前行前面的内容（原生行为）

-- === Visual 模式 (v) ===
vim.keymap.set("v", "<C-c>", '"+y', opts)              -- Visual 模式下复制到系统剪贴板
vim.keymap.set("v", "<C-x>", '"+d', opts)              -- Visual 模式下剪切到系统剪贴板

-- === Terminal 模式 (t) ===
vim.keymap.set("t", "<C-\\><C-n>", "<C-\\><C-n>", opts) -- Terminal 模式下按 Ctrl+\ Ctrl+n 退出到 Normal
