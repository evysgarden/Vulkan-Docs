{
  description = "vulkan docs";

  inputs = {
    utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      utils,
    }:
    utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };

      in
      {
        packages.default = pkgs.stdenv.mkDerivation {
          pname = "vulkan-man-pages";
          version = "1.4.309";
          src = ./.;

          enableParallelBuilding = true;

          nativeBuildInputs = with pkgs; [
            asciidoctor-with-extensions
            nodejs_24
            python3
            python3Packages.pyparsing
            python3Packages.networkx
            nodePackages.he
            hexapdf
          ];

          makeFlags = "man3pages";

          postBuild = ''
            substituteInPlace gen/out/man/man3/* \
              --replace-quiet "<code>" "\fB" \
              --replace-quiet "</code>" "\fP" \
              --replace-quiet "<strong>" "\fI" \
              --replace-quiet "<strong class=\"purple\">" "\fI" \
              --replace-quiet "</strong>" "\fP" \
              --replace-quiet "C SPECIFICATION" "SYNOPSIS"
            
            find gen/out/man/man3 -type f -exec sed -i 's/\.URL "\(.*\)\.html" ".*" ".*"/\\fB\1\\fP/g' '{}' \;
          '';

          installPhase = ''
            runHook preInstall
            mkdir -p $out/share/
            cp -rv gen/out/man $out/share/man
            runHook postInstall
          '';
        };
      }
    );
}
