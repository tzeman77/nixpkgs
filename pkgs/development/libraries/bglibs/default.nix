{ stdenv, fetchurl, dietlibc, libtool }:

let
  pkg = "bglibs";
  ver = "1.106";
  homepage = http://untroubled.org/bglibs;
in stdenv.mkDerivation {
  name = "${pkg}-${ver}";

  src = fetchurl {
    url = "${homepage}/${name}.tar.gz";
    sha256 = "1w4dagl2h1gps2kbzdk9zn3ls1c81q0d6cnczkr8zrc85lffb2jw";
  };

  buildInputs = [dietlibc libtool];

  patches = [
    # libtool diet gcc... can't find main.o inside .a library
    ./bg-installer.patch
  ];

  configurePhase = ''
    echo "diet gcc" > conf-cc
    echo "diet gcc -s -static" > conf-ld
    echo $out/include/bglibs > conf-include
    echo $out/lib > conf-lib
    echo $out/bin > conf-bin
    echo $out/man > conf-man
  '';

  allowedReferences = ["out"];
  #dontPatchShebangs = true; # /bin/sh
  dontStrip = true; # diet does not need stripping
  dontPatchELF = true; # we produce static binaries

  meta = {
    description = "One stop library package";
    homepage = homepage;
    license = stdenv.lib.licenses.lgpl21Plus.fullName;
    platforms = stdenv.lib.platforms.gnu;
    maintainers = with stdenv.lib.maintainers; [ tzeman ];
  };

}

# vim: et ts=2 sw=2 
