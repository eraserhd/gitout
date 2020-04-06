self: super: {
  gerbilPackages = {
    clojerbil = super.callPackage "${super.fetchFromGitHub {
        owner = "eraserhd";
        repo = "clojerbil";
        rev = "6a7d711b7f14a438555dfed50f522402fa11372c";
        sha256 = "0pp5ncap1z8j78fla75240fr67nfakj05ja2qiv3jk5fnxd8738k";
    }}/derivation.nix" {};
  };
  gitout = super.callPackage ./derivation.nix {};
}
