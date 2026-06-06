{
  inputs = {
    flake-utils = { url = "github:numtide/flake-utils"; };
    # Nix Ros Overlay
    nix-ros-overlay = { url = "github:lopsided98/nix-ros-overlay/master"; };
    nixpkgs = { follows = "nix-ros-overlay/nixpkgs"; };
  };
  outputs =
    { nixpkgs, flake-utils, nix-ros-overlay, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = (import nixpkgs {
          inherit system;
          overlays = [ nix-ros-overlay.overlays.default ];
        });
      in {
        packages.default = with pkgs.clangStdenv;
          mkDerivation {
            pname = "revlib-ros";
            version = "1.0.0";
            src = ./.;

            cmakeFlags = [
              "-D$AMENT_PREFIX_PATH=$AMENT_PREFIX_PATH"
            ];

            nativeBuildInputs = [
              pkgs.cmake
              pkgs.makeWrapper
              pkgs.glib
              pkgs.gtk2
              (pkgs.opencv.override {
                enableJPEG = true;
                enableFfmpeg = true;
                enableGStreamer = true;
              })

              # ROS Packages
              pkgs.colcon
              # ... other non-ROS packages
              (with pkgs.rosPackages.humble;
                buildEnv {
                  paths = [
                    image-transport
                    ros-core
                    ament-cmake
                    ament-cmake-core
                    ament-cmake-ros
                    ament-cmake-auto

                    # ... other ROS packages
                  ];
                })
            ];
            buildInputs = [ ];

            buildPhase = ''
              mkdir -p build
              cmake -S $src -B ./build -DCMAKE_BUILD_TYPE=Release
              cmake --build build
            '';
            installPhase = ''
              mkdir -p $out/bin
              cp build/revlib-ros $out/bin
            '';
          };

        devShells.default = with pkgs;
          mkShell.override { stdenv = pkgs.clangStdenv; } {
            packages = [
              # Generic DevTools
              # clang-tools must be first before clang
              pkgs.clang-tools
              pkgs.cmake
              pkgs.glib
              pkgs.clang
              pkgs.nixfmt
              pkgs.python312Packages.flask

              # ROS Packages
              pkgs.colcon
              (with pkgs.rosPackages.humble;
                buildEnv {
                  paths = [
                    ros-core
                    ament-cmake
                    ament-cmake-core
                    ament-cmake-ros
                    ament-cmake-auto

                    # ... other ROS packages
                  ];
                })
            ];
          };
      });
}
