vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- [[ Basic setting ]]
vim.opt.autoindent = true
vim.opt.background = 'dark'
vim.opt.breakindent = true
vim.opt.clipboard = 'unnamedplus'
vim.opt.cmdheight = 2
vim.opt.colorcolumn = '100'
vim.opt.completeopt = 'menuone,noselect'
vim.opt.conceallevel = 0
vim.opt.cursorline = true
vim.opt.errorbells = false
vim.opt.expandtab = true
vim.opt.guicursor = ''
vim.opt.hlsearch = false
vim.opt.ignorecase = true
vim.opt.inccommand = 'split'
vim.opt.incsearch = true
vim.opt.laststatus = 2
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.mouse = 'a'
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.ruler = true
vim.opt.scrolloff = 8
vim.opt.shiftwidth = 4
vim.opt.showmode = false
vim.opt.signcolumn = 'yes'
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.softtabstop = 4
vim.opt.spell = true
vim.opt.spelllang = 'en_us'
vim.opt.splitbelow = false
vim.opt.splitright = true
vim.opt.syntax = 'on'
vim.opt.tabstop = 4
vim.opt.termguicolors = true
vim.opt.timeout = true
vim.opt.timeoutlen = 300
vim.opt.undofile = true
vim.opt.updatetime = 250
vim.opt.wrap = false
vim.g.zig_fmt_autosave = 0

vim.g.have_nerd_font = true

-- This is for nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- [[ Advanced settings ]]
-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- [[ Basic Keymaps ]]
vim.keymap.set({ 'n', 'v' }, '<Space>w', ':w<CR>')
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.keymap.set({ 'v' }, '>', '>gv', { silent = true })
vim.keymap.set('v', '<', '<gv', { silent = true })
vim.keymap.set('n', '<Space>t', ':NvimTreeToggle<CR>', { silent = true })
vim.keymap.set('n', '<Space>ff', ':NvimTreeFindFile<CR>', { silent = true })
vim.keymap.set('n', '<Space>vs', ':vs<CR>', { silent = true })
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.keymap.set('n', '<C-left>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-right>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-down>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-up>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
vim.keymap.set('n', '<leader>f', function()
  require('conform').format { async = true, lsp_fallback = true }
end, { desc = '[F]ormat buffer' })

-- [[ Basic Autocommands ]]
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
-- NOTE: Here is where you install your plugins.
require('lazy').setup({
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },

  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter',
    config = function()
      require('which-key').setup()
      require('which-key').add {
        { '<leader>c', group = '[C]ode' },
        { '<leader>d', group = '[D]ocument' },
        { '<leader>r', group = '[R]ename' },
        { '<leader>s', group = '[S]earch' },
        { '<leader>w', group = '[W]orkspace' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      }
    end,
  },

  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      require('telescope').setup {
        defaults = {
          mappings = {
            i = {
              ['<C-u>'] = false,
              ['<C-d>'] = false,
            },
          },
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }
      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })

      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })
    end,
  },

  -- LSP Plugins
  { -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = 'luvit-meta/library', words = { 'vim%.uv' } },
      },
    },
  },
  { 'Bilal2453/luvit-meta', lazy = true },
  { -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      { 'williamboman/mason.nvim', config = true }, -- NOTE: Must be loaded before dependants
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      {
        'j-hui/fidget.nvim',
        config = function()
          require('fidget').setup {
            integration = {
              ['nvim-tree'] = {
                enable = false,
              },
            },
          }
        end,
        opts = {},
      },

      -- Allows extra capabilities provided by nvim-cmp
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end
          --  To jump back, press <C-t>.

          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
          map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
          map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
          map('gt', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
          map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
          map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
          map('<leader>e', vim.diagnostic.open_float, 'Open floating diagnostic message')
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end
        end,
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      local servers = {
        rust_analyzer = {
          settings = {
            ['rust-analyzer'] = {
              cargo = {
                features = 'all',
              },
              checkOnSave = {
                command = 'clippy',
                allFeatures = true,
              },
            },
          },
        },
        vtsls = {},
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
      }

      require('mason').setup()

      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua',
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }
      require('mason-lspconfig').setup()

      require('mason-lspconfig').setup_handlers {
        function(server_name)
          local server = servers[server_name] or {}
          server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
          require('lspconfig')[server_name].setup(server)
        end,
        ['rust_analyzer'] = function() end,
        clangd = function() end,
        zls = function() end,
      }

      require('lspconfig').nil_ls.setup {}
      require('lspconfig').clangd.setup {}
      require('lspconfig').zls.setup {}
    end,
  },

  { -- Autoformat
    'stevearc/conform.nvim',
    config = function()
      require('conform').setup {
        log_level = vim.log.levels.DEBUG,
        notify_on_error = true,
        format_after_save = function(bufnr)
          local disable_filetypes = { c = true, cpp = true }
          return {
            timeout_ms = 500,
            lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
          }
        end,
        formatters_by_ft = {
          lua = { 'stylua' },
          nix = { 'nixfmt' },
          html = { 'prettierd', 'prettier', stop_after_first = true },
          css = { 'prettierd', 'prettier', stop_after_first = true },
          javascript = { 'prettierd', 'prettier', stop_after_first = true },
          typescript = { 'prettierd', 'prettier', stop_after_first = true },
          javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
          typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
          json = { 'prettierd', 'prettier', stop_after_first = true },
          yaml = { 'prettierd', 'prettier', stop_after_first = true },
          toml = { 'taplo' },
          python = { 'black' },
          c = { 'clang-format' },
          zig = {
            lsp_format = 'first',
          },
        },
      }
    end,
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
  },

  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          -- `friendly-snippets` contains a variety of premade snippets.
          --    See the README about individual language/framework/plugin snippets:
          --    https://github.com/rafamadriz/friendly-snippets
          -- {
          --   'rafamadriz/friendly-snippets',
          --   config = function()
          --     require('luasnip.loaders.from_vscode').lazy_load()
          --   end,
          -- },
        },
      },
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
    },
    config = function()
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      luasnip.config.setup {}

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = 'menu,menuone,noinsert' },
        -- For an understanding of why these mappings were
        -- chosen, you will need to read `:help ins-completion`
        mapping = cmp.mapping.preset.insert {
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-y>'] = cmp.mapping.confirm { select = true },
          -- Manually trigger a completion from nvim-cmp.
          ['<C-Space>'] = cmp.mapping.complete {},

          -- Think of <c-l> as moving to the right of your snippet expansion.
          --  So if you have a snippet that's like:
          --  function $name($args)
          --    $body
          --  end
          --
          -- <c-l> will move you to the right of each of the expansion locations.
          ['<C-l>'] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' }),
          ['<C-h>'] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),
        },
        sources = {
          {
            name = 'lazydev',
            -- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
            group_index = 0,
          },
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
        },
      }
    end,
  },

  -- Colorschemes
  {
    'Tsuzat/NeoSolarized.nvim',
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
  },
  {
    'craftzdog/solarized-osaka.nvim',
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      vim.cmd [[colorscheme solarized-osaka]]
    end,
  },
  -- Git integrations
  {
    'NeogitOrg/neogit',
    config = function()
      require('neogit').setup {}
      vim.keymap.set('n', '<leader>ng', '<cmd>Neogit<CR>')
    end,
    dependencies = {
      'sindrets/diffview.nvim',
    },
  },

  -- Highlight todo, notes, etc in comments
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      require('mini.ai').setup { n_lines = 500 }
      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      -- require('mini.surround').setup()

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
    end,
  },
  {
    'nvim-lualine/lualine.nvim',
    config = function()
      require('lualine').setup {
        options = {
          icons_enabled = true,
          theme = 'NeoSolarized',
        },
      }
    end,
  },
  -- this is only when nixos fails for some reason
  -- { -- Highlight, edit, and navigate code
  --   'nvim-treesitter/nvim-treesitter',
  --   opts = {
  --     highlight = {
  --       enable = true,
  --     },
  --     indent = { enable = true },
  --   },
  --   config = function(_, opts)
  --     ---@diagnostic disable-next-line: missing-fields
  --     require('nvim-treesitter.configs').setup(opts)
  --   end,
  -- },

  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    opts = {
      ensure_installed = { 'bash', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'vim', 'vimdoc' },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
    config = function(_, opts)
      -- [[ Configure Treesitter ]]

      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup(opts)
      local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
      parser_config.spec = {
        install_info = {
          url = '~/Documents/projects/treesitter/tree-sitter-spec', -- local path or git repo
          files = { 'src/parser.c' },
          requires_generate_from_grammar = true,
        },
      }
    end,
  },

  require 'kickstart.plugins.debug',
  require 'kickstart.plugins.autopairs',
  require 'kickstart.plugins.gitsigns', -- adds gitsigns recommend keymaps

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    This is the easiest way to modularize your config.
  --
  --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  --    For additional information, see `:help lazy.nvim-lazy.nvim-structuring-your-plugins`
  { import = 'custom.plugins' },
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

vim.filetype.add {
  extension = {
    spec = 'spec',
  },
}

-- [[ Abbreviations]]
-- very basic math symbols with latex like syntax for files with `spec` extension
vim.cmd [[
    autocmd FileType spec inoreabbrev <buffer> forall ∀
    autocmd FileType spec inoreabbrev <buffer> exists ∃
    autocmd FileType spec inoreabbrev <buffer> land ∧
    autocmd FileType spec inoreabbrev <buffer> lor ∨
    autocmd FileType spec inoreabbrev <buffer> lnot ¬
    autocmd FileType spec inoreabbrev <buffer> to →
    autocmd FileType spec inoreabbrev <buffer> iff ↔
    autocmd FileType spec inoreabbrev <buffer> leq ≤
    autocmd FileType spec inoreabbrev <buffer> geq ≥
    autocmd FileType spec inoreabbrev <buffer> neq ≠
    autocmd FileType spec inoreabbrev <buffer> neq ≠
    autocmd FileType spec inoreabbrev <buffer> ZZ ℤ
    autocmd FileType spec inoreabbrev <buffer> RR ℝ
    autocmd FileType spec inoreabbrev <buffer> in ∈
    autocmd FileType spec inoreabbrev <buffer> notin ∉
    autocmd FileType spec inoreabbrev <buffer> sum ∑
    autocmd FileType spec inoreabbrev <buffer> prod ∏
  ]]

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'spec',
  callback = function()
    vim.keymap.set('i', '<C-y>', '<C-]>', { buffer = true })
  end,
})
