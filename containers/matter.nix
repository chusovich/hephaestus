{ ... }:

{
  virtualisation.oci-containers = {
    containers.matter-server = {
      image = "ghcr.io/matter-js/matterjs-server:1.6.0";
      autoStart = true;
      podman.user = "admin";
      volumes = [ "/var/lib/matterjs-server:/data" ];
      log-driver = "k8s-file";
      environment = {
        LISTEN_ADDRESS = "192.168.10.167";
        PRIMARY_INTERFACE = "enp1s0";
      };
      extraOptions = [ "--network=host" ];
    };
  };

  # Matter.js Server runs as UID 1000 in the container and needs write access
  # to its persistent storage directory.
  systemd.tmpfiles.rules = [
    "d /var/lib/matterjs-server 0750 1000 100 -"
  ];

  # Matter/Thread relies on IPv6 Router Advertisement Route Information
  # Options to route traffic to Thread devices behind a border router.
  boot.kernel.sysctl = {
    "net.ipv6.conf.enp1s0.accept_ra" = 1;
    "net.ipv6.conf.enp1s0.accept_ra_rt_info_max_plen" = 64;
    "net.ipv6.conf.all.forwarding" = 0;
  };
}
