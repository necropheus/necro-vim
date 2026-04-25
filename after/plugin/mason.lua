local servers = {
    rust_analyzer = {
        settings = {
            ["rust-analyzer"] = {
                cargo = {
                    features = "all",
                },
                checkOnSave = {
                    command = "clippy",
                    allFeatures = true,
                },
            },
        },
    },
    lua_ls = {
        settings = {
            Lua = {
                completion = {
                    callSnippet = "Replace",
                },
                diagnostics = { disable = { "missing-fields" } },
            },
        },
    },
}

local standalone_servers = {
    "nil_ls",
    "clangd",
    "zls",
    "hls",
}

require("mason").setup()
require("mason-nvim-dap").setup()

local ensure_installed = vim.tbl_keys(servers or {})
vim.list_extend(ensure_installed, {
    "stylua",
})

require("mason-tool-installer").setup { ensure_installed = ensure_installed }

for server_name, config in pairs(servers) do
    vim.lsp.config(server_name, config)
end

require("mason-lspconfig").setup {
    ensure_installed = {},
    automatic_enable = false,
}

for _, server_name in ipairs(vim.list_extend(vim.tbl_keys(servers), standalone_servers)) do
    vim.lsp.enable(server_name)
end

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
    callback = function(event)
        local builtin = require "telescope.builtin"

        require("utils.keymaps").buf_apply(event.buf, {
            { "n", "gd", builtin.lsp_definitions, { desc = "[G]oto [D]efinition" } },
            { "n", "gr", builtin.lsp_references, { desc = "[G]oto [R]eferences" } },
            { "n", "gI", builtin.lsp_implementations, { desc = "[G]oto [I]mplementation" } },
            { "n", "gt", builtin.lsp_type_definitions, { desc = "Type [D]efinition" } },
            { "n", "<leader>ds", builtin.lsp_document_symbols, { desc = "[D]ocument [S]ymbols" } },
            { "n", "<leader>ws", builtin.lsp_dynamic_workspace_symbols, { desc = "[W]orkspace [S]ymbols" } },
            { "n", "<Leader>rn", vim.lsp.buf.rename, { desc = "[R]e[n]ame" } },
            { "n", "<Leader>ca", vim.lsp.buf.code_action, { desc = "[C]ode [A]ction" } },
            { "n", "<Leader>e", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" } },
            { "n", "gD", vim.lsp.buf.declaration, { desc = "[G]oto [D]eclaration" } },
        })

        -- The following two autocommands are used to highlight references of the
        -- word under your cursor when your cursor rests there for a little while.
        --    See `:help CursorHold` for information about when this is executed
        --
        -- When you move your cursor, the highlights will be cleared (the second autocommand).
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                buffer = event.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                buffer = event.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd("LspDetach", {
                group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
                callback = function(event2)
                    vim.lsp.buf.clear_references()
                    vim.api.nvim_clear_autocmds { group = "lsp-highlight", buffer = event2.buf }
                end,
            })
        end
    end,
})
