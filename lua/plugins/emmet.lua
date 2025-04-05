return {
    {
        "mattn/emmet-vim",
        config = function()
            -- Desactivar atajos predeterminados
            vim.g.user_emmet_leader_key = ""
            vim.g.user_emmet_expandabbr_key = ""

            -- Crear un mapeo para expandir abreviaturas al presionar "--"
            vim.api.nvim_set_keymap(
                "i",         -- Modo de inserción
                "--",        -- Activador (doble guion)
                "<C-O>:call emmet#expandAbbr(0, '')<CR>", -- Expande la abreviatura
                { noremap = true, silent = true }
            )
        end,
    },
}

