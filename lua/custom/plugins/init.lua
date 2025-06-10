-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  'pixelastic/vim-undodir-tree', -- Will this work? It's really old
  { -- session management
    'rmagatti/auto-session',
    lazy = false,

    ---enables autocomplete for opts
    ---@module "auto-session"
    ---@type AutoSession.Config
    opts = {
      suppressed_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
      -- log_level = 'debug',
    },
  },
  { -- File tree
    'nvim-tree/nvim-tree.lua',
    lazy = true,
    cmd = {
      'NvimTreeOpen',
      'NvimTreeClose',
      'NvimTreeToggle',
      'NvimTreeFocus',
      'NvimTreeRefresh',
      'NvimTreeFindFile',
      'NvimTreeFindFileToggle',
      'NvimTreeClipboard',
      'NvimTreeResize',
      'NvimTreeCollapse',
      'NvimTreeCollapseKeepBuffers',
      'NvimTreeHiTest',
    },
    config = function()
      local function my_on_attach(bufnr)
        local api = require 'nvim-tree.api'

        api.config.mappings.default_on_attach(bufnr)
      end

      require('nvim-tree').setup {
        on_attach = my_on_attach,
      }
    end,
  },

  { -- Buffer line
    'akinsho/bufferline.nvim',
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      require('bufferline').setup {}

      vim.keymap.set('n', '<S-Left>', ':BufferLineCyclePrev<CR>', { silent = true })
      vim.keymap.set('n', '<S-Right>', ':BufferLineCycleNext<CR>', { silent = true })
      vim.keymap.set('n', '<S-Tab>', ':BufferLineMovePrev<CR>', { silent = true })
      vim.keymap.set('n', '<Tab>', ':BufferLineMoveNext<CR>', { silent = true })
      vim.keymap.set('n', '<leader>bc', ':bd<CR>')
    end,
  },

  { -- Copilot
    'zbirenbaum/copilot.lua',
    config = function()
      require('copilot').setup {
        filetypes = {
          rust = false,
          haskell = false,
          python = false,
          c = false,
          cpp = false,
          zig = false,
          spec = false,
        },
        suggestion = {
          auto_trigger = true,
          keymap = {
            accept = '<M-l>',
          },
        },
      }
    end,
  },

  { -- Rust utilities
    'mrcjkb/rustaceanvim',
    version = '^5', -- Recommended
    lazy = false, -- This plugin is already lazy
    dependencies = {
      {
        'saecki/crates.nvim',
        tag = 'stable',
        event = { 'BufRead Cargo.toml' },
        config = function()
          require('crates').setup {}
        end,
      },
    },
  },
  -- Java
  {
    'mfussenegger/nvim-jdtls',
    config = function()
      local config = {
        cmd = { '~/.local/share/nvim/mason/bin/jdtls' },
        root_dir = vim.fs.dirname(vim.fs.find({ 'gradlew', '.git', 'mvnw' }, { upward = true })[1]),
      }
      require('jdtls').start_or_attach(config)
    end,
  },
  {
    'rcasia/neotest-java',
    ft = 'java',
    dependencies = {
      'mfussenegger/nvim-jdtls',
    },
  },
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      'antoinemadec/FixCursorHold.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    opts = {
      adapters = {
        ['neotest-java'] = {},
      },
    },
    config = function()
      local neotest = require 'neotest'
      neotest.setup {
        adapters = {
          require 'neotest-java',
        },
      }
      vim.keymap.set('n', '<leader>tn', neotest.run.run, { desc = 'Run [T]est [F]ile' })
      vim.keymap.set('n', '<leader>tf', function()
        neotest.run.run(vim.fn.expand '%')
      end, { desc = 'Run [T]est [F]ile' })
    end,
  },
}
