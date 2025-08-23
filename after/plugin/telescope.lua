require("telescope").setup {
    defaults = {
        mappings = {
            i = {
                ["<C-u>"] = false,
                ["<C-d>"] = false,
            },
        },
    },
    extensions = {
        ["ui-select"] = {
            require("telescope.themes").get_dropdown(),
        },
    },
    pickers = {
        help_tags = {
            mappings = {
                i = {
                    ["<CR>"] = "file_vsplit",
                },
            },
        },
    },
}

-- Enable Telescope extensions if they are installed
pcall(require("telescope").load_extension, "fzf")
pcall(require("telescope").load_extension, "undo")

local builtin = require "telescope.builtin"
require("utils.keymaps").apply {
    { "n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" } },
    { "n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" } },
    { "n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" } },
    { "n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" } },
    { "n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" } },
    { "n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" } },
    { "n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" } },
    { "n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" } },
    { "n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' } },
    { "n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" } },
    {
        "n",
        "<leader>/",
        function()
            -- You can pass additional configuration to Telescope to change the theme, layout, etc.
            builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown {
                winblend = 10,
                previewer = false,
            })
        end,
        { desc = "[/] Fuzzily search in current buffer" },
    },
    {
        "n",
        "<leader>s/",
        function()
            builtin.live_grep {
                grep_open_files = true,
                prompt_title = "Live Grep in Open Files",
            }
        end,
        { desc = "[S]earch [/] in Open Files" },
    },
    {
        "n",
        "<leader>sn",
        function()
            builtin.find_files { cwd = vim.fn.stdpath "config" }
        end,
        { desc = "[S]earch [N]eovim files" },
    },
}
