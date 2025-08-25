require("blink.cmp").setup {
    completion = {
        accept = {
            -- TODO: Enable this later to see if it works
            auto_brackets = { enabled = false },
        },
    },
    sources = {
        default = { "avante", "lsp", "path", "buffer" },
        providers = {
            avante = {
                module = "blink-cmp-avante",
                name = "Avante",
                opts = {
                    -- options for blink-cmp-avante
                },
            },
        },
    },
}
