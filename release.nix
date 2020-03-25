{ nixpkgs ? (import ./nixpkgs.nix), ... }:
let
  pkgs = import nixpkgs { config = {}; };
  gitout = pkgs.callPackage ./derivation.nix {};
in {
  test = pkgs.runCommandNoCC "gitout-test" {} ''
    mkdir -p $out
    : ${gitout}
  '';
}
