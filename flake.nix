{
  description = "A very basic flake";

  inputs = {
    even = {
      url = "github:dali99/even";
      flake = false;
    };
  };

  outputs = inputs@{ self, nixpkgs, ... }: let
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
  in {
    packages.x86_64-linux.website = pkgs.stdenv.mkDerivation {
      name = "dandellion-xyz";
      version = "unstable";

      nativeBuildInputs = [ pkgs.zola ];
      src = ./.;

      buildPhase = ''
        mkdir themes
        ln -s ${inputs.even} themes/even
        zola build
      '';

      installPhase = ''
        mkdir -p $out
        mv public/* $out/
      '';
    };
    
    packages.x86_64-linux.default = self.packages.x86_64-linux.website;
  };
}
