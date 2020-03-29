self: super: {
  gitout = super.callPackage ./derivation.nix {};
  clojerbil = super.callPackage "${super.fetchFromGitHub {
        owner = "eraserhd";
        repo = "clojerbil";
        rev = "453c251cfaed996cd1291fab8fa06ee0554208e0";
        sha256 = "1mchax1nvr03a09mrwwzzhkmbw3zmi67ac3c9xm1j7yh36a4g014";
  }}/derivation.nix" {};
}
