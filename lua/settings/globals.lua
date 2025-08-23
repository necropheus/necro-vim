local globals = {
    mapleader = " ",
    maplocalLeader = " ",

    have_nerd_font = true,

    -- This is for nvim-tree
    loaded_netrw = 1,
    loaded_netrwPlugin = 1,

    zig_fmt_autosave = 1,
}

for name, value in pairs(globals) do
    vim.g[name] = value
end
