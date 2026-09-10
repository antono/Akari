{
  lib,
  pkgs,
  ...
}:
{
  extraPackages = with pkgs; [
    marksman
    imagemagick
  ];

  extraPlugins = [
    # markdown-review.nvim: fork of markdown-preview.nvim adding review comments.
    # Overriding the nixpkgs derivation keeps its vendored app/node_modules and
    # nodejs runtime dependency; only the source is swapped for the fork.
    (pkgs.vimPlugins.markdown-preview-nvim.overrideAttrs (_: {
      pname = "markdown-review.nvim";
      version = "d172217";
      src = pkgs.fetchFromGitHub {
        owner = "antono";
        repo = "markdown-review.nvim";
        rev = "d172217ec84a288bdab95d11541920dca4932738"; # branch: master
        hash = "sha256-Awyk4Se1tAb6N59glBz2HA9CSdOg5jqnOsG3NbLGpig=";
      };
    }))
  ];

  plugins = {
    # conform-nvim.settings = {
    #   formatters_by_ft.markdown = [ "deno_fmt" ];
    #
    #   formatters = {
    #     deno_fmt.command = lib.getExe pkgs.deno;
    #   };
    # };

    lsp.servers = {
      marksman.enable = true;
    };

    lint = {
      lintersByFt.markdown = [ "markdownlint" ];
      linters.markdownlint.cmd = lib.getExe pkgs.markdownlint-cli;
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>mp";
      action = "<cmd>MarkdownReviewToggle<cr>";
      options = {
        silent = true;
        desc = "Toggle markdown preview";
      };
    }
    {
      mode = "n";
      key = "<leader>mr";
      action = "<cmd>MarkdownReview<cr>";
      options = {
        silent = true;
        desc = "Toggle markdown Review";
      };
    }
  ];
}
