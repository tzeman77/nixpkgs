{ stdenv, fetchurl, bglibs, cvm }:

let
  pkg = "mailfront";
  ver = "2.01";
  web = http://untroubled.org;
in stdenv.mkDerivation rec {
  name = "${pkg}-${ver}";

  src = fetchurl {
    url = "${web}/${pkg}/${pkg}-${ver}.tar.gz";
    sha256 = "0qrbqx5h9sc74dk87ddzznyzfdcgak2jl45sw63q9p1ngkpnkc0z";
  };

  buildInputs = [cvm bglibs];
  inherit bglibs;

  configurePhase = ''
    echo $bglibs/include/bglibs > conf-bgincs
    echo $bglibs/lib > conf-bglibs
    echo $out/bin > conf-bin
    echo $out/include > conf-include
    echo $out/lib/mailfront > conf-modules
  '';

  meta = {
    description = "Mail server network protocol front-ends";
    homepage = "${web}/${pkg}";
    license = stdenv.lib.licenses.gpl2Plus.fullName;
    platforms = stdenv.lib.platforms.gnu;
    maintainers = with stdenv.lib.maintainers; [ tzeman ];
  };

}

# vim: et ts=2 sw=2 
