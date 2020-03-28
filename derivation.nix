{ stdenv, fetchFromGitHub, gerbil, makeWrapper, clojerbil, ... }:

stdenv.mkDerivation rec {
  pname = "gitout";
  version = "0.1.0";

  src = ./.;

  buildInputs = [ gerbil makeWrapper clojerbil ];

  installPhase = ''
    find ${clojerbil}
    mkdir -p $out/bin
    GERBIL_PATH=$out GERBIL_LOADPATH=${clojerbil}/lib gxi build.ss
    for exe in "$out/bin/"*; do
      wrapProgram "$exe" --prefix GERBIL_LOADPATH : "$out/lib"
    done
  '';

  meta = with stdenv.lib; {
    description = "TODO: fill me in";
    homepage = https://github.com/eraserhd/gitout;
    license = licenses.publicDomain;
    platforms = platforms.all;
    maintainers = [ maintainers.eraserhd ];
  };
}
