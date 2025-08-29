vim.opt.autoread = true

require("opencode").setup {
    terminal = {
        start_insert = true,
    },
}

require("utils.keymaps").apply {
    {
        "n",
        "<leader>oA",
        function()
            require("opencode").ask()
        end,
        { desc = "Ask opencode" },
    },
    {
        "n",
        "<leader>oa",
        function()
            require("opencode").ask "@cursor: "
        end,
        { desc = "Ask opencode about this" },
    },
    {
        "v",
        "<leader>oa",
        function()
            require("opencode").ask "@selection: "
        end,
        { desc = "Ask opencode about selection" },
    },
    {
        "n",
        "<leader>ot",
        function()
            require("opencode").toggle()
        end,
        { desc = "Toggle embedded opencode" },
    },
    {
        "n",
        "<leader>on",
        function()
            require("opencode").command "session_new"
        end,
        { desc = "New session" },
    },
    {
        "n",
        "<leader>oy",
        function()
            require("opencode").command "messages_copy"
        end,
        { desc = "Copy last message" },
    },
    {
        "n",
        "<S-C-up>",
        function()
            require("opencode").command "messages_half_page_up"
        end,
        { desc = "Scroll messages up" },
    },
    {
        "n",
        "<S-C-down>",
        function()
            require("opencode").command "messages_half_page_down"
        end,
        { desc = "Scroll messages down" },
    },
    {
        { "n", "v" },
        "<leader>op",
        function()
            require("opencode").select_prompt()
        end,
        { desc = "Select prompt" },
    },
}
