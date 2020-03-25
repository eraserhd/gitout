{ stdenv, fetchFromGitHub, ... }:

stdenv.mkDerivation rec {
  pname = "git-host-tools";
  version = "0.1.0";

  src = ./.;

  meta = with stdenv.lib; {
    description = "TODO: fill me in";
    homepage = https://github.com/eraserhd/git-host-tools;
    license = licenses.publicDomain;
    platforms = platforms.all;
    maintainers = [ maintainers.eraserhd ];
  };
}
