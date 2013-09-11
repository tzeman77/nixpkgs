{ stdenv, fetchurl, dietlibc, libtool, bglibs }:

let
  pkg = "cvm";
  ver = "0.96";
  homepage = http://untroubled.org/cvm;
in stdenv.mkDerivation rec {
  name = "${pkg}-${ver}";

  src = fetchurl {
    url = "${homepage}/${name}.tar.gz";
    sha256 = "1s94c9h3fzw7l1cv5g5qcm5ysx8nhwxdhnvhjmyb4q5iyjr22ldq";
  };

  buildInputs = [dietlibc libtool bglibs];

  inherit bglibs;

  patches = [
  ];

  configurePhase = ''
    env
    echo "diet gcc" > conf-cc
    echo "diet gcc -s -static" > conf-ld
    echo $bglibs/include/bglibs > conf-bgincs
    echo $bglibs/lib > conf-bglibs
    echo $out/lib > conf-lib
    echo $out/bin > conf-bin
    echo $out/man > conf-man
    echo $out/include > conf-include
  '';

  allowedReferences = ["out"];
  dontStrip = true; # diet does not need stripping
  dontPatchELF = true; # we produce static binaries

  meta = {
    description = "Credential Validation Modules";
    homepage = homepage;
    license = stdenv.lib.licenses.gpl2Plus.fullName;
    platforms = stdenv.lib.platforms.gnu;
    maintainers = with stdenv.lib.maintainers; [ tzeman ];
  };

}

# vim: et ts=2 sw=2 

