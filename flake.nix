{
  description = "Noctalia Dots - Modular NixOS Configuration";

  # Offered on the very first build (before nix.settings in
  # modules/packages.nix has ever taken effect). Nix will prompt once to
  # trust this — say yes, or it'll compile Noctalia from source instead.
  nixConfig = {
    extra-substituters = [ "https://noctalia.cachix.org" ];
    extra-trusted-public-keys = [ "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helium-browser = {
      url = "github:oxcl/nix-flake-helium-browser";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";  
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia";
      # NOTE: deliberately NOT following the shared nixpkgs here.
      # Noctalia's docs are explicit that inputs.nixpkgs.follows disables
      # its Cachix binary cache — with it set, Noctalia's Qt/C++/Rust
      # shell compiles from source on every rebuild instead of pulling a
      # prebuilt binary. The tradeoff is a second nixpkgs copy in the
      # closure; on anything resource-capped (a VM, for instance) that's
      # a much better trade than a from-source Noctalia build.
    };
  };

  outputs = { self, nixpkgs, home-manager, niri, stylix, noctalia, plasma-manager, spicetify-nix, zen-browser, helium-browser, nix-vscode-extensions, ... }@inputs:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/nixos
            niri.nixosModules.niri
            stylix.nixosModules.stylix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              
              home-manager.backupFileExtension = "backup";
              home-manager.extraSpecialArgs = { inherit inputs; };
              
              home-manager.users.healer = {
                imports = [
                  ./home/default.nix
                ];
              };
            }
          ];
        };
      };
    };
}