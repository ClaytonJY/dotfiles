{
  description = "claytonjy's home-manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      mkHome = { system, username, homeDirectory, extraModules ? [ ] }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [
            {
              home.username = username;
              home.homeDirectory = homeDirectory;
            }
            ./home.nix
          ] ++ extraModules;
        };
      # Capability modules compose the common base for each concrete profile.
      profileModules = {
        gui = [ ./profiles/gui.nix ];
        linuxGui = [ ./profiles/linux-gui.nix ];
      };
    in
    {
      homeConfigurations = {
        "linux-laptop" = mkHome {
          system = "x86_64-linux";
          username = "claytonjy";
          homeDirectory = "/home/claytonjy";
          extraModules = profileModules.gui ++ profileModules.linuxGui;
        };

        "macbook" = mkHome {
          system = "aarch64-darwin";
          username = "claytonjy";
          homeDirectory = "/Users/claytonjy";
          extraModules = profileModules.gui;
        };

        "linux-vm" = mkHome {
          system = "x86_64-linux";
          username = "claytonjy";
          homeDirectory = "/home/claytonjy";
        };
      };

      apps = forAllSystems (system: {
        home-manager = {
          type = "app";
          program = "${home-manager.packages.${system}.home-manager}/bin/home-manager";
        };
      });

      formatter =
        forAllSystems (system: nixpkgs.legacyPackages.${system}.nixpkgs-fmt);
    };
}
