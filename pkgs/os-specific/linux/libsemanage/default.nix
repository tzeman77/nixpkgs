{ stdenv, fetchurl, libsepol, libselinux, ustr, bzip2, bison, flex }:
stdenv.mkDerivation rec {

  name = "libsemanage-${version}";
  version = "2.1.9";
  inherit (libsepol) se_release se_url;

  src = fetchurl {
    url = "${se_url}/${se_release}/libsemanage-${version}.tar.gz";
    sha256 = "1k1my3n1pj30c5887spykcdk1brgxfpxmrz6frxjyhaijxzx20bg";
  };

  makeFlags = "PREFIX=$(out) DESTDIR=$(out)";

  NIX_CFLAGS_COMPILE = "-fstack-protector-all";
  NIX_CFLAGS_LINK = "-lsepol";

  buildInputs = [ libsepol libselinux ustr bzip2 bison flex ];

  meta = with stdenv.lib; {
    inherit (libsepol.meta) homepage platforms maintainers;
    description = "Policy management tools for SELinux";
    license = licenses.lgpl21;
  };
}
