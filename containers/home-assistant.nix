{ ... }:

{
  virtualisation.oci-containers.containers.homeassistant = {
    image = "ghcr.io/home-assistant/home-assistant:2026.11.2";
    autoStart = true;
    volumes = [
      "/var/lib/home-assistant:/config"
      "/etc/localtime:/etc/localtime:ro"
      "/run/dbus:/run/dbus:ro"
    ];
    environment = {
      TZ = "America/New_York";
    };
    extraOptions = [
      "--network=host"
      "--privileged"
      "--stop-timeout=60"
    ];
    log-driver = "k8s-file";
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/home-assistant 0750 root root -"
  ];
}
