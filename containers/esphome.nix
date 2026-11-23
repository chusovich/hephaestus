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
    ];
    log-driver = "k8s-file";
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/esphome 0750 root root -"
  ];
}
