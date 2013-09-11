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

  /*
  ipv6patch = fetchurl {
    url = "http://www.fefe.de/ucspi/${pkg}-${ver}-ipv6.diff19.bz2";
    sha256 = "1kls3xysv3wwmikxychnbfv8vbnb0ih15005hhn4a56pj392r59m";
  };

  patches = ipv6patch;
  */

  buildInputs = [dietlibc];

  configurePhase = ''
    echo "diet gcc" > conf-cc
    echo "diet gcc -s -static" > conf-ld
  '';

  buildPhase = "./package/compile";

  installPhase = ''
    mkdir $out/bin
    for BIN in `cat package/commands`; do
      cp command/$BIN $out/bin
    done
  '';

  allowedReferences = ["out"];
  dontPatchShebangs = true; # /bin/sh
  dontStrip = true; # diet does not need stripping
  dontPatchELF = true; # we produce static binaries

  # man pages
  /*
  postInstall = ''
    mkdir -p $out/man/man1
    cp $NIX_BUILD_TOP/${pkg}-${ver}-man/*.1 $out/man/man1/
  '';
  */

  meta = {
    description = "A collection of tools for managing UNIX services";
    homepage = "${web}/{$pkg}.html";
    license = stdenv.lib.licenses.publicDomain.shortName;
    platforms = stdenv.lib.platforms.gnu;
    maintainers = with stdenv.lib.maintainers; [ tzeman ];
  };
}

# vim: et ts=2 sw=2 
