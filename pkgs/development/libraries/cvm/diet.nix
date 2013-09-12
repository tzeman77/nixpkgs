{ stdenv, fetchurl, dietlibc, libtool, diet-bglibs }:

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

  buildInputs = [dietlibc libtool diet-bglibs];

  inherit diet-bglibs;

  patches = [
    # fix missing main() - can't find in .a lib.
    ./link-main.patch
  ];

  configurePhase = ''
    echo "diet gcc" > conf-cc
    echo "diet gcc -s -static" > conf-ld
    echo ${diet-bglibs}/include/bglibs > conf-bgincs
    echo ${diet-bglibs}/lib > conf-bglibs
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

