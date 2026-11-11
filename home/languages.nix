{ lib, pkgs, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) isLinux;
  # full toolchain per language: runtime, lsp, formatter
  # nvim side: config/nvim/lsp/<server>.lua, formatters in none-ls.lua
  languages = with pkgs; {
    bash = [ bash-language-server ];
    c = [ clang-tools ] ++ lib.optionals isLinux [ gcc ];
    go = [ go gopls ];
    js = [ nodejs pnpm typescript-language-server prettier ];
    lua = [ lua-language-server stylua ];
    nix = [ nil ];
    python = [ uv pyright black isort ];
    rust = [ cargo rustc rust-analyzer ];
    terraform = [ terraform-ls ];
    web = [ vscode-langservers-extracted ]; # html, css, json, eslint
    yaml = [ yaml-language-server ];
  };
in
{
  home.packages = lib.concatLists (lib.attrValues languages);
}
