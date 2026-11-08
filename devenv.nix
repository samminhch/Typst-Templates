{ pkgs, inputs, ... }:
let
  manifest = fromTOML (builtins.readFile ./typst.toml);
  version = manifest.package.version;
in
{
  packages = [
    pkgs.yaml-language-server
    inputs.tytanic.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
  languages.typst = {
    enable = true;
  };
  enterShell = ''
    git config core.hooksPath .githooks 2>/dev/null || true
    ./.githooks/post-checkout 2>/dev/null || true
  '';
}
