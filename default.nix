let
  nixpkgs = import ./nixpkgs.nix;
  pkgs = import nixpkgs {
    config = {};
    overlays = [
      (import ./overlay.nix)
      (import "${(import nixpkgs {}).fetchFromGitHub {
        owner = "eraserhd";
        repo = "clojerbil";
        rev = "453c251cfaed996cd1291fab8fa06ee0554208e0";
        sha256 = "1mchax1nvr03a09mrwwzzhkmbw3zmi67ac3c9xm1j7yh36a4g014";
      }}/overlay.nix")
    ];
  };

in pkgs.gitout
