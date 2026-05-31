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
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      mkHome = { username, homeDirectory, modules ? [ ] }:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            {
              home.username = username;
              home.homeDirectory = homeDirectory;
            }
            ./home.nix
          ] ++ modules;
        };
    in
    {
      homeConfigurations."personal-linux" = mkHome {
        username = "claytonjy";
        homeDirectory = "/home/claytonjy";
      };
      formatter.${system} = pkgs.nixpkgs-fmt;
    };
}
