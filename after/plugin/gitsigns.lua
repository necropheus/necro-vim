require("gitsigns").setup {
    signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
    },
    on_attach = function(bufnr)
        local gitsigns = require "gitsigns"

        require("utils.keymaps").buf_apply(
            bufnr,
            {
                {
                    "n",
                    "<leader>hD",
                    function()
                        gitsigns.diffthis "@"
                    end,
                    { desc = "git [D]iff against last commit" },
                },
            }
        )
    end,
}
