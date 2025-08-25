require("hlchunk").setup {
    chunk = {
        enable = true,
        notify = true,
        exclude_filetypes = { AvanteInput = true, AvantePromptInput = true },
    },
    indent = {
        enable = true,
        notify = true,
        exclude_filetypes = { AvanteInput = true, AvantePromptInput = true },
    },
    line_num = {
        enable = true,
        notify = true,
        exclude_filetypes = { AvanteInput = true, AvantePromptInput = true },
    },
}
