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
        devShell = pkgs.mkShellNoCC {
          packages = with pkgs; [
            python3
            python3Packages.pyparsing
          ];
        };
      }
    );
}
