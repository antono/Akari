{ pkgs, ... }:
let
  isAarch64Darwin = pkgs.stdenv.hostPlatform.system == "aarch64-darwin";
in
{
  config = {
    extraConfigLuaPre = ''
      vim.fn.sign_define("diagnosticsignerror", { text = " ", texthl = "diagnosticerror", linehl = "", numhl = "" })
      vim.fn.sign_define("diagnosticsignwarn", { text = " ", texthl = "diagnosticwarn", linehl = "", numhl = "" })
      vim.fn.sign_define("diagnosticsignhint", { text = "󰌵", texthl = "diagnostichint", linehl = "", numhl = "" })
      vim.fn.sign_define("diagnosticsigninfo", { text = " ", texthl = "diagnosticinfo", linehl = "", numhl = "" })
    '';

    # feature that enhances the way Neovim loads and executes Lua modules,
    # offering improved performance and flexibility.
    luaLoader.enable = true;

    clipboard.providers.wl-copy.enable = if isAarch64Darwin then false else true;

    opts = {
      virtualedit = "block"; # Allow cursor to move where there is no text in visual block mode
      cursorline = true; # Highlight the line where the cursor is located
      cmdheight = 2; # more space in the neovim command line for displaying messages
      showmode = false; # Dont show the editor mode in status line

      # Enable relative line numbers
      number = true;
      relativenumber = false;

      # Tab spacing 2 spaces
      tabstop = 2;
      softtabstop = 2;
      shiftwidth = 2;
      expandtab = true;

      smartindent = true;
      wrap = true;

      # Smart indent on word wrap
      breakindent = true;

      # Undo stuff from days ago
      swapfile = false;
      backup = false;
      undofile = true;

      # Incremental search
      hlsearch = true;
      incsearch = true;

      # Better splitting
      splitbelow = true;
      splitright = true;

      # Enable ignorecase + smartcase for better searching
      ignorecase = true;
      smartcase = true; # Don't ignore case with capitals
      grepprg = "rg --vimgrep";
      grepformat = "%f:%l:%c:%m";

      # Better colors
      termguicolors = true;

      # Decrease updatetime
      updatetime = 50; # faster completion (4000ms default)

      # Enable the sign column to prevent the screen from jumping
      signcolumn = "yes";

      # Reduce which-key timeout to 250s
      timeoutlen = 250;

      scrolloff = 8; # Will never have less than 8 characters as you scroll down
      mouse = "a"; # Mouse

      # Set encoding type
      encoding = "utf-8";
      fileencoding = "utf-8";

      # Maximum number of items to show in the popup menu (0 means "use available screen space")
      pumheight = 0;

    };

    extraConfigLua = ''
      local opt = vim.opt
      local g = vim.g
      local o = vim.o

      vim.opt.runtimepath:append(vim.fn.expand("~/Code/cerbo.nvim"))

      -- some local stuff is possible
      local home = os.getenv("HOME")
      local unmanaged = home .. "/.local/share/nvim-plugins"
      vim.opt.packpath:append(unmanaged)
      vim.opt.runtimepath:append(unmanaged)

      -- Neovide
      if g.neovide then
        vim.print(vim.g.neovide_version)
        -- Neovide options
        g.neovide_fullscreen = false
        g.neovide_hide_mouse_when_typing = false
        g.neovide_refresh_rate = 60
        g.neovide_cursor_vfx_mode = "ripple"
        g.neovide_cursor_animate_command_line = true
        g.neovide_cursor_animate_in_insert_mode = true
        g.neovide_cursor_vfx_particle_lifetime = 5.0
        g.neovide_cursor_vfx_particle_density = 14.0
        g.neovide_cursor_vfx_particle_speed = 12.0
        g.neovide_scale_factor = 1.0

        g.neovide_progress_bar_enabled = true
        g.neovide_progress_bar_height = 5.0
        g.neovide_progress_bar_animation_speed = 200.0
        g.neovide_progress_bar_hide_delay = 0.2

        -- Neovide Fonts
        -- o.guifont = "MonoLisa Trial:Medium:h15"
        -- o.guifont = "CommitMono:Medium:h15"
        -- o.guifont = "JetBrainsMono Nerd Font:h14:Medium:i"
        -- o.guifont = "FiraMono Nerd Font:Medium:h14"
        -- o.guifont = "FiraCode Nerd Font:Medium:h11"
        -- o.guifont = "CaskaydiaCove Nerd Font:h14:b:i"
        -- o.guifont = "BlexMono Nerd Font Mono:h14:Medium:i"
        -- o.guifont = "Liga SFMono Nerd Font:b:h15"

        local function change_scale(delta)
          local new = vim.g.neovide_scale_factor + delta
          if new < 0.5 then return end
          vim.g.neovide_scale_factor = new
        end

        -- Neovide on Linux often does not forward <C-=>; <C-+> is reliable.
        vim.keymap.set({"n", "v"}, "<C-+>", function() change_scale(0.1) end)
        vim.keymap.set({"n", "v"}, "<C-=>", function() change_scale(0.1) end)
        vim.keymap.set({"n", "v"}, "<C-->", function() change_scale(-0.1) end)
        vim.keymap.set({"n", "v"}, "<C-0>", function() vim.g.neovide_scale_factor = 1.0 end)
      end
    '';
  };
}
