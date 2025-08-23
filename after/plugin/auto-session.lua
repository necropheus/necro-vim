require("auto-session").setup {
    pre_save_cmds = {
        function()
            pcall(function()
                require("nvim-tree.api").tree.close()
            end)
            pcall(vim.cmd, "silent! NvimTreeClose")
        end,
    },
    post_restore_cmds = {
        function()
            local function my_on_attach(bufnr)
                local api = require "nvim-tree.api"

                api.config.mappings.default_on_attach(bufnr)
            end

            require("nvim-tree").setup { on_attach = my_on_attach }
        end,
    },
}

require("utils.keymaps").apply {
    { "n", "<leader>t", ":NvimTreeToggle<CR>", { desc = "Toggle file explorer" } },
    { "n", "<leader>ff", ":NvimTreeFindFile<CR>", { desc = "Focus current file in file explorer" } },
}
