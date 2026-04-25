local M = {}

function M.apply(mappings, default_opts)
  vim.validate("mappings", mappings, "table")
  vim.validate("default_opts", default_opts, "table", true)

  local base = vim.tbl_extend("force", { noremap = true, silent = true }, default_opts or {})

  for _, map in ipairs(mappings) do
    local modes, lhs, rhs, user_opts = map[1], map[2], map[3], map[4]
    if type(modes) == "string" then modes = { modes } end
    local opts = user_opts and vim.tbl_extend("force", vim.deepcopy(base), user_opts) or base
    for _, mode in ipairs(modes) do
      vim.keymap.set(mode, lhs, rhs, opts)
    end
  end
end

function M.buf_apply(bufnr, mappings, default_opts)
  default_opts = default_opts or {}
  default_opts.buffer = bufnr
  return M.apply(mappings, default_opts)
end

return M
