{ stdenv, fetchurl, dietlibc }:

stdenv.mkDerivation rec {
  name = "ucspi-tcp-0.88";
  builder = ./builder.sh;
  inherit dietlibc;

  allowedReferences = ["out"];
  
  src = fetchurl {
    url = http://cr.yp.to/ucspi-tcp/ucspi-tcp-0.88.tar.gz;
    sha256 = "171yl9kfm8w7l17dfxild99mbf877a9k5zg8yysgb1j8nz51a1ja";
  };

  meta = {
    description = "Command-line tools for building TCP client-server applications";
    homepage = http://cr.yp.to/ucspi-tcp.html;
    license = stdenv.lib.licenses.publicDomain.shortName;
    platforms = stdenv.lib.platforms.gnu;
    maintainers = with stdenv.lib.maintainers; [ tzeman ];
  };
}
