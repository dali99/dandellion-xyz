with import (import ./nix/sources.nix {}).nixpkgs {};
stdenv.mkDerivation {
  name = "dandellion-xyz-shell";
  buildInputs = [
    zola
    niv
  ];
}
