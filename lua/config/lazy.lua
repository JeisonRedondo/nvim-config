local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  -- bootstrap lazy.nvim
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

require("lazy").setup({
  spec = {
    -- add LazyVim and import its plugins
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- import any extras modules here
    { import = "lazyvim.plugins.extras.lang.typescript" },
    { import = "lazyvim.plugins.extras.lang.json" },
    --  { import = "lazyvim.plugins.extras.ui.mini-animate" },
    -- import/override with your plugins
    {
      "rcarriga/nvim-notify",
      config = function()
        vim.notify = require("notify")
        vim.notify.setup({
          level = vim.log.levels.INFO,
          timeout = 5000,
          max_width = 80,
          max_height = 20,
          stages = "fade_in_slide_out",
          background_colour = "NotifyBackground",
          icons = {
            DEBUG = "",
            ERROR = "",
            INFO = "",
            TRACE = "✎",
            WARN = "",
          },
          on_open = function(win)
            vim.api.nvim_win_set_config(win, { zindex = 100 })
          end,
          time_formats = {
            ["%H:%M"] = 3000,
            ["%I:%M %p"] = 4000,
          },
          on_close = function()
            --print("Notification closed")
          end,
          render = "default",
          minimum_width = 50,
          fps = 30,
          top_down = true,
        })
      end,
    },
    { import = "plugins" },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = { colorscheme = { "fluoromachine" } },
  checker = { enabled = true }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
