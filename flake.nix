{
  description = "Sample flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=release-21.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (
      system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
          {
            defaultPackage = with pkgs;
              stdenv.mkDerivation {
                name = "doc.pdf";
                buildInputs = [
                  pandoc
                  (texlive.combine { inherit (texlive) scheme-basic xcolor; })
                ];
                src = ./source.md;

                dontUnpack = true;
                buildPhase = ''
                  pandoc $src -o out.pdf
                '';

                installPhase = ''
                  mv out.pdf "$out";
                '';

              };
          }
    );

}
