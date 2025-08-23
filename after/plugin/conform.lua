require("conform").setup {
    notify_on_error = true,
    format_after_save = function(bufnr)
        local disable_filetypes = { c = true, cpp = true }

        return {
            timeout_ms = 500,
            lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
        }
    end,
    formatters_by_ft = {
        lua = { "stylua" },
        nix = { "nixfmt" },
        html = { "prettierd", "prettier", stop_after_first = true },
        css = { "prettierd", "prettier", stop_after_first = true },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        javascriptreact = { "prettierd", "prettier", stop_after_first = true },
        typescriptreact = { "prettierd", "prettier", stop_after_first = true },
        json = { "prettierd", "prettier", stop_after_first = true },
        yaml = { "prettierd", "prettier", stop_after_first = true },
        python = { "black" },
        c = { "clang-format" },
        zig = { lsp_format = "first" },
    },
}
