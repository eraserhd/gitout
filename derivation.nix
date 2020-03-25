{ stdenv, fetchFromGitHub, gerbil, ... }:

stdenv.mkDerivation rec {
  pname = "gitout";
  version = "0.1.0";

  src = ./.;

  buildInputs = [ gerbil ];

  installPhase = ''
    mkdir -p $out/bin
    GERBIL_PATH=$out gxi build.ss
  '';

  meta = with stdenv.lib; {
    description = "TODO: fill me in";
    homepage = https://github.com/eraserhd/gitout;
    license = licenses.publicDomain;
    platforms = platforms.all;
    maintainers = [ maintainers.eraserhd ];
  };
}
