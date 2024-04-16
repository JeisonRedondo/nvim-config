local telescope = require('telescope')

telescope.setup {}

-- Para cargar fzf y trabajar con el telescopio,
-- necesitas llamar a load_extension, en algún lugar después
-- la función de configuración.

telescope.load_extension('fzf')
require("telescope").load_extension("scope")

