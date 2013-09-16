{ stdenv, fetchurl, libtool, which, perl }:

let
  pkg = "bglibs";
  ver = "1.106";
  homepage = http://untroubled.org/bglibs;
in stdenv.mkDerivation rec {
  name = "${pkg}-${ver}";

  src = fetchurl {
    url = "${homepage}/${name}.tar.gz";
    sha256 = "1w4dagl2h1gps2kbzdk9zn3ls1c81q0d6cnczkr8zrc85lffb2jw";
  };

  buildInputs = [libtool which perl];

  patches = [
    ./bglibs.patch
  ];

  configurePhase = ''
    echo "gcc -s -static" > conf-ld
    echo $out/include/bglibs > conf-include
    echo $out/lib > conf-lib
    echo $out/bin > conf-bin
    echo $out/man > conf-man
  '';

  meta = {
    description = "One stop library package";
    homepage = homepage;
    license = stdenv.lib.licenses.lgpl21Plus.fullName;
    platforms = stdenv.lib.platforms.gnu;
    maintainers = with stdenv.lib.maintainers; [ tzeman ];
  };

}

# vim: et ts=2 sw=2 
