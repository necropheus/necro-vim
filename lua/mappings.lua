require("utils.keymaps").apply {
    { { "n", "v" }, "<Leader>w", ":w<CR>" },
    { { "n", "v" }, "<Leader>", "<Nop>" },
    { { "v" }, ">", ">gv" },
    { "v", "<", "<gv" },
    { "n", "<Leader>vs", ":vs<CR>", { desc = "Split window vertically" } },
    { "n", "<Esc>", "<cmd>nohlsearch<CR>" },
    { "n", "<Leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" } },
    { "t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" } },
    { "n", "<C-left>", "<C-w><C-h>", { desc = "Move focus to the left window" } },
    { "n", "<C-right>", "<C-w><C-l>", { desc = "Move focus to the right window" } },
    { "n", "<C-down>", "<C-w><C-j>", { desc = "Move focus to the lower window" } },
    { "n", "<C-up>", "<C-w><C-k>", { desc = "Move focus to the upper window" } },
    {
        "n",
        "<Leader>fb",
        function()
            require("conform").format { async = true, lsp_fallback = true }
        end,
        { desc = "[F]ormat buffer" },
    },
}
