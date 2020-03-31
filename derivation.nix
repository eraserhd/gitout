{ stdenv, fetchFromGitHub, gerbil, gerbilPackages, gambit, libyaml, zlib }:

stdenv.mkDerivation rec {
  pname = "gitout";
  version = "0.1.0";

  src = ./.;

  buildInputs = [ gerbil gambit gerbilPackages.clojerbil libyaml zlib ];

  installPhase = ''
    mkdir -p $out/bin
    GERBIL_PATH=$out GERBIL_LOADPATH=${gerbilPackages.clojerbil}/lib gxi build.ss
  '';

  meta = with stdenv.lib; {
    description = "TODO: fill me in";
    homepage = https://github.com/eraserhd/gitout;
    license = licenses.publicDomain;
    platforms = platforms.all;
    maintainers = [ maintainers.eraserhd ];
  };
}
