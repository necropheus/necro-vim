require("img-clip").setup {
    default = {
        embed_image_as_base64 = false,
        prompt_for_file_name = false,
        drag_and_drop = {
            insert_mode = true,
        },
    },
}

require("render-markdown").setup {
    file_types = { "markdown", "Avante" },
}

-- TODO: Fix the build to be able to just use rock's version. When you do, uninstall nui.nvim
require("avante").setup {
    provider = "copilot",
    auto_suggestions_provider = "copilot",
    behaviour = {
        -- TODO: Enable this when it leaves experimental stage
        auto_suggestions = false,
        enable_token_counting = false,
        enable_pasting_from_clipboard = true,
    },
    input = {
        provider = "snacks",
        provider_opts = {
            title = "Avante Input",
        },
    },
    windows = {
        input = {
            prefix = "» ",
            height = 8,
        },
    },
    selector = {
        provider = "snacks",
    },
    file_selector = {
        provider = "telescope",
    },
}

-- views can only be fully collapsed with the global statusline
vim.opt.laststatus = 3
