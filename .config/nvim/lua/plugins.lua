-- ~/.config/nvim/lua/plugins.lua
return require("lazy").setup({
  spec = {
    -- 核心依赖
    { "folke/plenary.nvim" },
    { "MunifTanjim/nui.nvim" },

    -- 代码补全
    {
      "hrsh7th/nvim-cmp",
      event = "InsertEnter",
      dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "saadparwaiz1/cmp_luasnip",
        "onsails/lspkind.nvim",
      },
      config = function()
        local cmp = require("cmp")
        local luasnip = require("luasnip")
        local lspkind = require("lspkind")

        require("luasnip").config.setup({})

        cmp.setup({
          snippet = {
            expand = function(args)
              luasnip.lsp_expand(args.body)
            end,
          },
          mapping = cmp.mapping.preset.insert({
            ["<C-b>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<C-x>"] = cmp.mapping.complete(),
            ["<C-e>"] = cmp.mapping.abort(),
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
            ["<Tab>"] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
              else
                fallback()
              end
            end, { "i", "s" }),
            ["<S-Tab>"] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
              else
                fallback()
              end
            end, { "i", "s" }),
          }),
          sources = cmp.config.sources({
            { name = "nvim_lsp" },
            { name = "luasnip" },
            { name = "path" },
          }, {
            { name = "buffer" },
          }),
          formatting = {
            format = lspkind.cmp_format({
              mode = "symbol_text",
              maxwidth = 50,
              ellipsis_char = "...",
            }),
          },
          window = {
            completion = {
              winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
              col_offset = -3,
              side_padding = 0,
            },
          },
          experimental = {
            ghost_text = true,
          },
        })
      end,
    },

    { "hrsh7th/cmp-nvim-lsp" },

    -- 📦 代码片段引擎：LuaSnip
    {
      "L3MON4D3/LuaSnip",
      version = "2.*",
      config = function()
        require("luasnip").config.setup({
          enable_autosnippets = true,
        })
      end,
    },

    -- 🎨 补全图标美化：lspkind.nvim
    {
      "onsails/lspkind.nvim",
      config = function()
        require("lspkind").init()
      end,
    },

    -- LSP 配置
    {
      "neovim/nvim-lspconfig",
      lazy = false,
      dependencies = { "hrsh7th/cmp-nvim-lsp" },
      config = function()
        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        local opts = { noremap = true, silent = true }
        vim.keymap.set("n", ",l", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "lp", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)

        -- Go
        vim.lsp.config.gopls = {
          cmd = { "gopls" },
          filetypes = { "go", "gomod", "gowork", "gotmpl" },
          root_markers = { ".git", "go.mod" },
          capabilities = capabilities,
          settings = {
            gopls = {
              completeUnimported = true,
              usePlaceholders = true,
            },
          },
        }
        vim.lsp.enable("gopls")

        -- C/C++
        vim.lsp.config.clangd = {
          cmd = { "clangd", "--background-index", "--clang-tidy" },
          filetypes = { "c", "cpp", "objc", "objcpp" },
          root_markers = { ".git", "compile_commands.json", "Makefile" },
          capabilities = capabilities,
        }
        vim.lsp.enable("clangd")

        -- Bash/Shell
        vim.lsp.config.bashls = {
          cmd = { "bash-language-server", "start" },
          filetypes = { "sh", "bash", "zsh" },
          capabilities = capabilities,
        }
        vim.lsp.enable("bashls")
      end,
    },

    -- nvim-tree
    {
      "nvim-tree/nvim-tree.lua",
      lazy = false,
      dependencies = { "nvim-tree/nvim-web-devicons" },
      config = function()
        require("nvim-tree").setup({
          view = {
            width = 30,
            side = "left",
          },
          -- ✅ 新增：启动时自动打开目录
          view = {
            width = 30,
            side = "left",
          },
          renderer = {
            icons = {
              show = {
                file = true,
                folder = true,
                folder_arrow = true,
              },
            },
          },
          actions = {
            open_file = {
              resize_window = true,
            },
          },
        })
        -- 2. ✅ 简单粗暴的自动打开命令
        -- 只要 nvim-tree 加载，就强制执行打开命令
        vim.cmd("NvimTreeOpen")
      end,
    },

    -- 主题
    {
      "catppuccin/nvim",
      name = "catppuccin",
      config = function()
        require("catppuccin").setup({
          flavour = "mocha",
        })
        vim.cmd("colorscheme catppuccin")
      end,
    },

    -- 缩进线
    {
      "lukas-reineke/indent-blankline.nvim",
      main = "ibl",
      lazy = false,
      config = function()
        require("ibl").setup({
          indent = {
            char = "▏",
            tab_char = "▏",
          },
          scope = {
            enabled = true,
            show_start = true,
            show_end = true,
            highlight = "IblScope",
          },
          exclude = {
            filetypes = {
              "help", "dashboard", "neo-tree", "NvimTree",
              "Trouble", "alpha", "lir", "Outline",
              "spectre_panel", "toggleterm", "terminal",
            },
            buftypes = { "terminal", "prompt" },
          },
        })
        vim.cmd("highlight IblScope guifg=#b4befe gui=nocombine")
      end,
    },

    -- Tree-sitter
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      lazy = false,
      config = function()
        vim.env.HTTP_PROXY = "http://httpproxy-headless.kubebrain.svc.pjlab.local:3128"
        vim.env.HTTPS_PROXY = "http://httpproxy-headless.kubebrain.svc.pjlab.local:3128"

        require("nvim-treesitter").setup({
          ensure_installed = { "bash", "go", "python", "c", "cpp" },
          auto_install = true,
          highlight = { enable = true },
          indent = { enable = true },
          incremental_selection = { enable = true },
        })
      end,
    },

    -- dressing.nvim（UI 增强）
    {
      "stevearc/dressing.nvim",
      version = "v1.0.0",
      opts = {
        input = { enabled = true },
        select = { enabled = true },
      },
    },

    -- ✅ 修正后的 Avante 配置（仅用于测试）
    {
      "yetone/avante.nvim",
      build = "make",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        "nvim-tree/nvim-web-devicons",
      },
      config = function()
        require("avante").setup({
          provider = "openai", -- 必须为 "openai"
          providers = {
            openai = {
              __inherited_from = "openai",
              endpoint = "http://s-20260427120216-k5vmr-decode.ailab-zskj.svc:8000/v1",
              api_key = "sk-mpp-admin-a54294fdf58981bd9fd1f6e225f28e198eb9711965601f30aa2f73f94e209ec3",
              model = "glm-5.1-fp8", -- 对应你提供的模型 ID
              -- ✅ 关键：DashScope 需要指定模型
              timeout = 120,
              options = {
                max_tokens = 3000,
                temperature = 0.3,
              },
            },
          },
          float = true,
          -- 🎨 在这里添加窗口大小和位置的配置
          windows = {
            position = "right",   -- 侧边栏位置：可选 "right", "left", "top", "bottom"
            width = 50,           -- 垂直布局时的宽度（屏幕宽度的50%）
            height = 30,          -- 水平布局时的高度（屏幕高度的 30%）
            sidebar_header = {
              enabled = true,     -- 启用顶部标题栏
              align = "center",   -- 标题居中
              rounded = true,     -- 圆角边框
            },
            input = {
              height = 10,        -- 底部输入框的高度
            },
          },
          mappings = {
            submit = {
              normal = "<leader>s",
              insert = "<S-CR>", -- ✅ 改为 <CR> 避免 E382
            },
          },
        })
        -- ✅ 新增：绑定快捷键 ai 来打开 Avante
        -- 注意：这需要在 setup 之后或者外部定义
        vim.keymap.set("n", "aa", "<cmd>AvanteChat<cr>", { desc = "Open Avante Chat" })
      end,
    },
  },

  defaults = { lazy = false },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip", "matchit", "matchparen", "netrwPlugin",
        "tarPlugin", "tohtml", "tutor", "zipPlugin",
      },
    },
  },
})
