{ stdenv, lib, fetchFromGitHub, gerbil, gerbilPackages, gambit, libyaml, zlib, asciidoc-full }:

stdenv.mkDerivation rec {
  pname = "gitout";
  version = "0.1.0";

  src = ./.;

  buildInputs = [
    gerbil
    gambit
    gerbilPackages.clojerbil
    libyaml
    zlib
    asciidoc-full
  ];

  installPhase = ''
    mkdir -p $out/bin $out/share/man/man1/
    GERBIL_PATH=$out GERBIL_LOADPATH=${gerbilPackages.clojerbil}/lib gxi build.ss

    for mansource in *.1.adoc; do
      a2x -f manpage "$mansource"
      cp "''${mansource%.adoc}" $out/share/man/man1/
    done
  '';

  meta = with lib; {
    description = "TODO: fill me in";
    homepage = "https://github.com/eraserhd/gitout";
    license = licenses.publicDomain;
    platforms = platforms.all;
    maintainers = [ maintainers.eraserhd ];
  };
}
