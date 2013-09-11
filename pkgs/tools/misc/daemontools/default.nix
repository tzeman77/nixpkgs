{ stdenv, fetchurl, dietlibc }:

let
  pkg = "daemontools";
  ver = "0.76";
  web = http://cr.yp.to;
in stdenv.mkDerivation rec {
  name = "${pkg}-${ver}";

  srcs = [
    (fetchurl {
      url = "${web}/${pkg}/${pkg}-${ver}.tar.gz";
      sha256 = "07scvw88faxkscxi91031pjkpccql6wspk4yrlnsbrrb5c0kamd5";
    })
    (fetchurl {
      url = "http://smarden.org/pape/djb/manpages/${pkg}-${ver}-man.tar.gz";
      sha256 = "02k06k2f69jl758cz6hfmnvzxq5vyyik29b7hzshv2l7w2ppfk8v";
    })
  ];
  sourceRoot = "admin/${pkg}-${ver}";

  buildInputs = [dietlibc];

  configurePhase = ''
    echo "diet gcc" > src/conf-cc
    echo "diet gcc -s -static" > src/conf-ld
  '';

  buildPhase = "./package/compile";

  installPhase = ''
    mkdir -p $out/bin
    for BIN in `cat package/commands`; do
      cp command/$BIN $out/bin
    done
    mkdir -p $out/man/man8
    cp $NIX_BUILD_TOP/${pkg}-man/*.8 $out/man/man8/
  '';

  allowedReferences = ["out"];
  dontPatchShebangs = true; # /bin/sh
  dontStrip = true; # diet does not need stripping
  dontPatchELF = true; # we produce static binaries

  meta = {
    description = "A collection of tools for managing UNIX services";
    homepage = "${web}/{$pkg}.html";
    license = stdenv.lib.licenses.publicDomain.shortName;
    platforms = stdenv.lib.platforms.gnu;
    maintainers = with stdenv.lib.maintainers; [ tzeman ];
  };
}

# vim: et ts=2 sw=2 