with import (import ./nix/sources.nix {}).nixpkgs {};
let
  even = pkgs.fetchFromGitHub {
    owner = "dali99";
    repo = "even";
    rev = "730a85d3fa1d54569cc8d7d2d162461d955572ce";
    sha256 = "0d04xas3mml0n1j64d4gl292bbhdrn02cmjxpjqglbimd4y4cn64";
  };
in
{
  website = pkgs.stdenv.mkDerivation {
    name = "dandellion-xyz";
    version = "2021-05-07";
    nativeBuildInputs = [ zola ];

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
  };
}
