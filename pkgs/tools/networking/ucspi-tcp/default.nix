{ stdenv, fetchurl, dietlibc }:

stdenv.mkDerivation rec {
  name = "ucspi-tcp-0.88";
  builder = ./builder.sh;
  inherit dietlibc;
  
  src = fetchurl {
    url = http://cr.yp.to/ucspi-tcp/ucspi-tcp-0.88.tar.gz;
    sha256 = "171yl9kfm8w7l17dfxild99mbf877a9k5zg8yysgb1j8nz51a1ja";
  };

  meta = {
    description = "command-line tools for building TCP client-server applications.";
    homepage = http://cr.yp.to/ucspi-tcp.html;
    license = stdenv.lib.licenses.publicDomain;
    platforms = stdenv.lib.platforms.gnu;
    #maintainers = with stdenv.lib.maintainers; [ jcumming ];
    maintainers = "Tomas Zeman <tzeman@volny.cz>";
  };
}
