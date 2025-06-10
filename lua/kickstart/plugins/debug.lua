-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',
    'theHamsta/nvim-dap-virtual-text', -- recommended
    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    -- Installs the debug adapters for you
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',
  },
  keys = function(_, keys)
    local dap = require 'dap'
    local dapui = require 'dapui'

    return {
      { '<F1>', dap.continue, desc = 'Debug: Start/Continue' },
      { '<F2>', dap.step_back, desc = 'Debug: Step Back' },
      { '<F3>', dap.step_into, desc = 'Debug: Step Into' },
      { '<F4>', dap.step_over, desc = 'Debug: Step Over' },
      { '<F5>', dap.step_out, desc = 'Debug: Step Out' },
      { '<F9>', dap.restart, desc = 'Debug: Restart' },
      { '<F10>', dap.terminate, desc = 'Debug: Terminate' },
      { '<leader>bp', dap.toggle_breakpoint, desc = 'Debug: Toggle Breakpoint' },
      {
        '<leader>B',
        function()
          dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
        end,
        desc = 'Debug: Set Breakpoint',
      },
      { '<F7>', dapui.toggle, desc = 'Debug: See last session result.' },
      {
        '<leader>?',
        function()
          require('dapui').eval(nil, { enter = true })
        end,
      },
      unpack(keys),
    }
  end,
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      automatic_installation = true,
      handlers = {},

      ensure_installed = {
        'gdb',
        'lldb',
      },
    }

    dapui.setup {
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    dap.adapters.gdb = {
      type = 'executable',
      command = 'gdb',
      args = {
        '--interpreter=dap',
        '--eval-command',
        'set print pretty on',
      },
    }

    dap.adapters.lldb = {
      type = 'executable',
      command = 'lldb',
      -- args = { '--interpreter=dap', '--eval-command=set print pretty on' },
    }

    dap.configurations.c = {
      {
        name = 'Launch',
        type = 'gdb',
        request = 'launch',
        program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/debug/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopAtBeginningOfMainSubprogram = false,
      },
    }
    dap.configurations.zig = {
      {
        name = 'Launch',
        type = 'lldb',
        request = 'launch',
        program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/zig-out/bin/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopAtBeginningOfMainSubprogram = false,
      },
    }
  end,
}
