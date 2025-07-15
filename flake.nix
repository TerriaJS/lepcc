{
  description = "A basic flake with a shell";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { system = "${system}"; config.allowUnfree = true; };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            nodejs
	    emscripten
            cmake
            python3
          ];

          shellHook = ''
	    if [ ! -d $(pwd)/.emscripten_cache ]; then
              cp -R ${pkgs.emscripten}/share/emscripten/cache/ $(pwd)/.emscripten_cache
              chmod u+rwX -R $(pwd)/.emscripten_cache
            fi
            export EM_CACHE=$(pwd)/.emscripten_cache
          '';
        };
      });
}
