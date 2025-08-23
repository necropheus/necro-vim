local dap = require "dap"
local dapui = require "dapui"

dapui.setup {
    icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
    controls = {
        element = "repl",
        enabled = true,
        icons = {
            pause = "⏸",
            play = "▶",
            step_into = "⏎",
            step_over = "⏭",
            step_out = "⏮",
            step_back = "b",
            run_last = "▶▶",
            terminate = "⏹",
            disconnect = "⏏",
        },
    },
    element_mappings = {},
    expand_lines = true,
    floating = {
        border = "single",
        mappings = {
            close = { "q", "<Esc>" },
        },
    },
    force_buffers = true,
    layouts = {
        {
            elements = {
                {
                    id = "scopes",
                    size = 0.25,
                },
                {
                    id = "breakpoints",
                    size = 0.25,
                },
                {
                    id = "stacks",
                    size = 0.25,
                },
                {
                    id = "watches",
                    size = 0.25,
                },
            },
            position = "left",
            size = 40,
        },
        {
            elements = {
                {
                    id = "repl",
                    size = 0.5,
                },
                {
                    id = "console",
                    size = 0.5,
                },
            },
            position = "bottom",
            size = 10,
        },
    },
    mappings = {
        edit = "e",
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        repl = "r",
        toggle = "t",
    },
    render = {
        indent = 1,
        max_value_lines = 100,
    },
}

dap.listeners = {
    after = {
        event_initialized = {
            dapui_config = dapui.open,
        },
    },
    before = {
        event_terminated = {
            dapui_config = dapui.close,
        },
        event_exited = {
            dapui_config = dapui.close,
        },
    },
}

-- TODO: Check if this is needed or codelldb just works
-- dap.adapters = {
--     gdb = {
--         type = "executable",
--         command = "gdb",
--         args = {
--             "--interpreter=dap",
--             "--eval-command",
--             "set print pretty on",
--         },
--     },
--     lldb = {
--         type = "executable",
--         command = "lldb",
--     },
-- }

-- TODO: Check if this is needed or codelldb just works
-- dap.configurations = {
--     c = {
--         {
--             name = "Launch",
--             type = "gdb",
--             request = "launch",
--             program = function()
--                 return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/debug/", "file")
--             end,
--             cwd = "${workspaceFolder}",
--             stopAtBeginningOfMainSubprogram = false,
--         },
--     },
--     zig = {
--         {
--             name = "Launch",
--             type = "lldb",
--             request = "launch",
--             program = function()
--                 return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/zig-out/bin/", "file")
--             end,
--             cwd = "${workspaceFolder}",
--             stopAtBeginningOfMainSubprogram = false,
--         },
--     },
-- }

require("utils.keymaps").apply {
    { "n", "<F1>", dap.continue, desc = "Debug: Start/Continue" },
    { "n", "<F2>", dap.step_back, desc = "Debug: Step Back" },
    { "n", "<F3>", dap.step_into, desc = "Debug: Step Into" },
    { "n", "<F4>", dap.step_over, desc = "Debug: Step Over" },
    { "n", "<F5>", dap.step_out, desc = "Debug: Step Out" },
    { "n", "<F9>", dap.restart, desc = "Debug: Restart" },
    { "n", "<F10>", dap.terminate, desc = "Debug: Terminate" },
    { "n", "<leader>bp", dap.toggle_breakpoint, desc = "Debug: Toggle Breakpoint" },
    {
        "n",
        "<leader>B",
        function()
            dap.set_breakpoint(vim.fn.input "Breakpoint condition: ")
        end,
        desc = "Debug: Set Breakpoint",
    },
    { "n", "<F7>", dapui.toggle, desc = "Debug: See last session result." },
    {
        "n",
        "<leader>?",
        function()
            dapui.eval(nil, { enter = true })
        end,
    },
}
