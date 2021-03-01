with import (import ./nix/sources.nix {}).nixpkgs {};
let
  even = pkgs.fetchFromGitHub {
    owner = "getzola";
    repo = "even";
    rev = "fc64c3a64c6f00951cb8d411a2dc5e9444717b7d";
    sha256 = "0cjzs2dvna6sa98qjr1wzyw8z7xaw4f61izglq7z882myck94yl3";
  };
in
stdenv.mkDerivation {
  name = "dandellion-xyz";
  version = "2021-03-01";
  nativeBuildInputs = [ pkgs.zola ];

#  src = pkgs.fetchFromGitHub {
#    owner = "dali99";
#    repo = "dandellion-xyz";
#    rev = "1bcb64c6208ad448dcbedba3cd372735196535db";
#    sha256 = lib.fakeSha256;
#  };

  src = ./.;

  buildPhase = ''
    mkdir themes
    ln -s ${even} themes/even
    zola build
  '';

  installPhase = ''
    mkdir -p $out
    mv public/* $out/
  '';
  
}
