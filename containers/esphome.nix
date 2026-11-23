{ ... }:

{
  virtualisation.oci-containers.containers.esphome = {
    image = "esphome/esphome:2026.10";
    autoStart = true;
    volumes = [
      "/var/lib/esphome:/config"
      "/etc/localtime:/etc/localtime:ro"
    ];
    environment = {
      TZ = "America/New_York";
    };
    extraOptions = [
      "--network=host"
      "--privileged"
      "--device=/dev:/dev"
    ];
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/esphome 0750 root root -"
  ];
}
