{ nixpkgs ? (import ./nixpkgs.nix), ... }:
let
  pkgs = import nixpkgs {
    config = {};
    overlays = [
      (import ./overlay.nix)
    ];
  };
in {
  test = pkgs.stdenv.mkDerivation {
    name = "tests";
    src = ./tests;
    buildInputs = with pkgs; [ git gitout gerbil ];
    buildPhase = ''
      gxi run-tests.ss
    '';
    installPhase = "touch $out";
  };
}
