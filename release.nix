{ nixpkgs ? (import ./nixpkgs.nix), ... }:
let
  pkgs = import nixpkgs { config = {}; };
  git-host-tools = pkgs.callPackage ./derivation.nix {};
in {
  test = pkgs.runCommandNoCC "git-host-tools-test" {} ''
    mkdir -p $out
    : ${git-host-tools}
  '';
}