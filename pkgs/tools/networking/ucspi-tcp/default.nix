{ stdenv, fetchurl, dietlibc }:

let
  pkg = "ucspi-tcp";
  ver = "0.88";
in stdenv.mkDerivation rec {
  name = "${pkg}-${ver}";

  srcs = [
    (fetchurl {
      url = "http://cr.yp.to/ucspi-tcp/${pkg}-${ver}.tar.gz";
      sha256 = "171yl9kfm8w7l17dfxild99mbf877a9k5zg8yysgb1j8nz51a1ja";
    })
    (fetchurl {
      url = "http://smarden.org/pape/djb/manpages/${pkg}-${ver}-man.tar.gz";
      sha256 = "1vq8nibyjq8cirif8iv2bpzp5jv0jpgjgfqa0cnbc8ipr9lxvc89";
    })
  ];
  sourceRoot = "${pkg}-${ver}";

  buildInputs = [dietlibc];

  configurePhase = ''
    echo $out > conf-home
    echo "diet gcc" > conf-cc
    echo "diet gcc -s -static" > conf-ld
  '';

  installTargets = "setup check";

  allowedReferences = ["out"];
  dontPatchShebangs = true; # /bin/sh
  dontStrip = true; # diet does not need stripping
  dontPatchELF = true; # we produce static binaries

  # man pages
  postInstall = ''
    mkdir -p $out/share/man/man1
    cp $NIX_BUILD_TOP/${pkg}-${ver}-man/*.1 $out/share/man/man1/
  '';

  meta = {
    description = "Command-line tools for building TCP client-server applications";
    homepage = http://cr.yp.to/ucspi-tcp.html;
    license = stdenv.lib.licenses.publicDomain.shortName;
    platforms = stdenv.lib.platforms.gnu;
    maintainers = with stdenv.lib.maintainers; [ tzeman ];
  };
}
