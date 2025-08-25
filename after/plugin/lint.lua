local lint = require "lint"
lint.linters_by_ft = {}

local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
    group = lint_augroup,
    callback = function()
        local ft = vim.bo.filetype

        if lint.linters_by_ft[ft] ~= nil then
            lint.try_lint()
        end
    end,
})
