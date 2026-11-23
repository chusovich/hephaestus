{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-core = {
      url = "github:chusovich/nix-core/v2026.10.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nix-core, ... }: {
    nixosConfigurations.hephaestus = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        nix-core.nixosModules.default
        ./configuration.nix
      ];
    };
  };
}

