require("barbar").setup()

require("utils.keymaps").apply {
    { "n", "<S-Left>", ":BufferPrevious<CR>" },
    { "n", "<S-Right>", ":BufferNext<CR>" },
    { "n", "<S-Tab>", ":BufferMovePrevious<CR>" },
    { "n", "<Tab>", ":BufferMoveNext<CR>" },
    { "n", "<leader>bc", ":BufferClose<CR>" },
}
