{ pkgs, config, ... }:

let
  c = config.lib.stylix.colors.withHashtag;
in
{

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    plugins = with pkgs.vimPlugins; [

      (nvim-treesitter.withPlugins (p: with p; [
        nix
        lua
        vim
        bash
        json
        yaml
        markdown
        python
        rust
        go
      ]))

      nvim-lspconfig

      base16-nvim

      telescope-nvim
      plenary-nvim
      nvim-web-devicons
      lualine-nvim
      gitsigns-nvim

      vim-sleuth
    ];

    initLua = ''
      -- Stylix-driven colorscheme (base16), interpolated at build time —
      -- see ../style/stylix.nix for how the underlying palette is
      -- generated, and its comment for what "dynamic" means with Stylix
      -- (regenerates per-rebuild, not live).
      require('base16-colorscheme').setup({
        base00 = "${c.base00}", base01 = "${c.base01}", base02 = "${c.base02}",
        base03 = "${c.base03}", base04 = "${c.base04}", base05 = "${c.base05}",
        base06 = "${c.base06}", base07 = "${c.base07}", base08 = "${c.base08}",
        base09 = "${c.base09}", base0A = "${c.base0A}", base0B = "${c.base0B}",
        base0C = "${c.base0C}", base0D = "${c.base0D}", base0E = "${c.base0E}",
        base0F = "${c.base0F}",
      })

      -- Don't let Neovim paint its own opaque background — the terminal
      -- (Ghostty/Kitty/Alacritty) already supplies transparency via
      -- background-opacity, and niri blurs behind it.
      vim.api.nvim_create_autocmd('ColorScheme', {
        callback = function()
          for _, group in ipairs({ 'Normal', 'NormalNC', 'NormalFloat', 'SignColumn', 'LineNr', 'EndOfBuffer' }) do
            vim.api.nvim_set_hl(0, group, { bg = 'none' })
          end
        end,
      })

      -- Set mapleader to space before anything else
      vim.g.mapleader = ' '
      vim.g.maplocalleader = ' '

      -- Options
      local opt = vim.opt
      opt.number = true
      opt.relativenumber = true
      opt.mouse = 'a'
      opt.showmode = false
      opt.clipboard = 'unnamedplus' -- Use Wayland clipboard
      opt.breakindent = true
      opt.undofile = true
      opt.ignorecase = true
      opt.smartcase = true
      opt.signcolumn = 'yes'
      opt.updatetime = 250
      opt.timeoutlen = 300
      opt.splitright = true
      opt.splitbelow = true
      opt.list = true
      opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
      opt.inccommand = 'split'
      opt.cursorline = true
      opt.scrolloff = 10
      opt.termguicolors = true
      opt.tabstop = 2
      opt.shiftwidth = 2
      opt.expandtab = true

      -- Keymaps
      local keymap = vim.keymap.set
      keymap('n', '<Esc>', '<cmd>nohlsearch<CR>')
      keymap('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic' })
      keymap('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic' })
      keymap('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic error' })

      -- Telescope Keybindings
      local builtin = require('telescope.builtin')
      keymap('n', '<leader>ff', builtin.find_files, { desc = 'Find Files' })
      keymap('n', '<leader>fg', builtin.live_grep, { desc = 'Find by Grep' })
      keymap('n', '<leader>fb', builtin.buffers, { desc = 'Find Buffers' })
      keymap('n', '<leader>fh', builtin.help_tags, { desc = 'Find Help' })

      -- Initialize Plugins
      require('gitsigns').setup()
      require('lualine').setup({
        options = {
          theme = 'auto',
          component_separators = "|",
          section_separators = "",
        }
      })

      -- LSP Configurations
      local lspconfig = require('lspconfig')

      -- Nix LSP (nixd)
      lspconfig.nixd.setup({
        cmd = { "nixd" },
        settings = {
          nixd = {
            formatting = { command = { "nixfmt" } },
          },
        },
      })

      -- Lua LSP (lua_ls)
      lspconfig.lua_ls.setup({
        settings = {
          Lua = {
            diagnostics = { globals = { 'vim' } },
            workspace = { checkThirdParty = false },
          },
        },
      })
    '';
  };
}