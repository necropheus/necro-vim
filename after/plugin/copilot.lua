require("copilot").setup {
    server = {
        type = "binary",
        custom_server_filepath = "/home/necropheus/.local/share/nvim/mason/bin/copilot-language-server",
    },
    filetypes = {
        rust = false,
        haskell = false,
        python = false,
        c = false,
        cpp = false,
        zig = false,
        asm = false,
        markdown = false,
    },
    suggestion = {
        auto_trigger = true,
        keymap = {
            accept = "<M-l>",
        },
    },
}
