{ pkgs, ... }:

{
  # -------------------------------------------------------------------------
  # Declarative Neovim Configuration
  # -------------------------------------------------------------------------
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    # -----------------------------------------------------------------------
    # Neovim Plugins
    # -----------------------------------------------------------------------
    plugins = with pkgs.vimPlugins; [
      # Syntax Highlighting & Parsing
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

      # LSP & Completion
      nvim-lspconfig

      # Colorscheme — colors come from a Matugen-generated Lua file
      # loaded at the top of initLua below.
      base16-nvim

      # Navigation & UI Tools
      telescope-nvim
      plenary-nvim
      nvim-web-devicons
      lualine-nvim
      gitsigns-nvim

      # Quality of Life
      vim-sleuth # Auto-detect indentation settings
    ];

    # -----------------------------------------------------------------------
    # Embedded Lua Configuration (init.lua)
    # -----------------------------------------------------------------------
    initLua = ''
      -- Matugen-driven colorscheme (base16), regenerated on every wallpaper
      -- change by the same matugen run that themes the terminal/starship/
      -- fastfetch (see ../style/matugen.nix). Falls back to no colorscheme
      -- on a very first boot before matugen has ever produced this file.
      local ok, base16_colors = pcall(dofile, vim.fn.expand('~/.config/nvim/matugen-colors.lua'))
      if ok and base16_colors then
        require('base16-colorscheme').setup(base16_colors)
      end

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