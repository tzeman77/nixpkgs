{ stdenv, fetchurl, openssl }:

let
  pkg = "bincimap";
  ver = "1.2.13";
  homepage = http://www.bincimap.org;
in stdenv.mkDerivation rec {
  name = "${pkg}-${ver}";

  src = fetchurl {
    url = "ftp://ftp.linux.org.tr/gentoo/distfiles/bincimap-1.2.13final.tar.bz2";
    sha256 = "0a25ms7nj0ns18danrpp1jxvicaddkrpz8mq0qh1lljacyhnh8qm";
  };

  buildInputs = [openssl];

  patches = [ 
    ./bincimap-1.2.13-gcc43.patch
    ./const-char-fix.patch
  ];

  configureFlags = "--with-ssl";

  meta = {
    description = "A well designed, modular IMAP server for Maildir";
    homepage = homepage;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.all;
    maintainers = with stdenv.lib.maintainers; [ tzeman ];
  };

}

# vim: et ts=2 sw=2 

