{ config, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  # Use Podman for NixOS-managed OCI containers. Keep Docker available for
  # separately managed Compose stacks.
  virtualisation = {
    oci-containers.backend = "podman";

    docker = {
      enable = true;
      logDriver = "local";
      daemon.settings."log-opts" = {
        "max-size" = "10m";
        "max-file" = "3";
      };
    };

    containers.containersConf.settings.containers = {
      log_driver = "k8s-file";
      log_size_max = 10485760;
    };
  };

  # Compressed in-memory swap avoids writing swapped secrets to the unencrypted
  # root filesystem. The limit is 50% of physical memory.
  zramSwap = {
    enable = true;
    memoryPercent = 50;
  };
  
  # Networking
  networking = {
    firewall.enable = false;
    hostName = "hephaestus";
    interfaces = {
      enp1s0 = {
        useDHCP = false;
        ipv4.addresses = [ {
          address = "192.168.10.167";
          prefixLength = 24;
        } ];
      };
    };
    defaultGateway = "192.168.10.1";
    nameservers = [ "192.168.10.1" ];
  };

  # Default user account
  users.users.calebh = {
    isNormalUser = true;
    description = "Caleb Husovich";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [ ];
    initialPassword = "password";
   };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
