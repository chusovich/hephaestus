# hephaestus

Home automation server running NixOS.

## ESPHome

ESPHome is managed by the `virtualisation.oci-containers` NixOS module in
[`containers/esphome.nix`](./containers/esphome.nix), using Podman with the
`esphome/esphome:2026.10` image. It uses host networking for LAN device discovery
and does not need USB device access.

ESPHome configuration is stored at `/var/lib/esphome` on the host (`/config`
in the container). Its dashboard is available at:

```text
http://192.168.10.167:6052
```

The migration retains device YAML, secrets, and ESPHome storage metadata.
Rebuildable compiler and build caches are left behind and will be recreated as
needed.

## Matter Server

The Matter.js Server is managed by the `virtualisation.oci-containers` NixOS
module in [`containers/matter.nix`](./containers/matter.nix), using Podman with
the `ghcr.io/matter-js/matterjs-server:1.6.0` image. It uses host networking
so Matter multicast discovery and IPv6 traffic can reach the host's LAN interface.

The server persists its fabric and controller data at
`/var/lib/matterjs-server` on the host (`/data` in the container). The directory
is prepared for the container's UID 1000. The server's WebSocket endpoint is:

```text
ws://192.168.10.167:5580/ws
```

In Home Assistant, add the Matter integration, choose the option to connect to
an existing/custom Matter Server, and use that URL.

### Machine-specific network settings

These settings are specific to this host and its current network:

- `enp1s0` is the LAN interface. Matter.js is configured to use it for mDNS and
  Matter network communication.
- The host has the static IPv4 address `192.168.10.167`; the Matter Server's
  WebSocket listener is bound to that address. The host firewall is currently
  disabled, so the listener is available to devices on the LAN.
- IPv6 is enabled on `enp1s0`; it receives IPv6 Router Advertisements and has
  ULA and link-local addresses. A public/global IPv6 address or IPv6 internet
  access is not required for Matter.
- `net.ipv6.conf.enp1s0.accept_ra_rt_info_max_plen = 64` enables processing
  Thread route advertisements up to `/64`. The kernel supports this feature,
  Router Advertisement processing is enabled, and IPv6 forwarding remains off.
- Matter's mDNS/link-local multicast discovery does not cross VLANs. The host,
  Matter devices, and Thread Border Router should be on the same LAN/VLAN.

The Matter Server and dashboard do not provide an authentication layer for
their listener. Keep port 5580 on a trusted network; if the network layout
changes, update `LISTEN_ADDRESS` and/or configure an appropriate host firewall.

If replacing an existing Python Matter Server, back up its data and follow the
[Matter.js migration guide](https://github.com/matter-js/matterjs-server/blob/main/docs/migration.md)
before reusing that server's data.

### References

- [Home Assistant Matter integration](https://www.home-assistant.io/integrations/matter/)
- [Matter.js Server Docker instructions](https://github.com/matter-js/matterjs-server/blob/main/docs/docker.md)
- [Matter.js Server OS and networking requirements](https://github.com/matter-js/matterjs-server/blob/main/docs/os_requirements.md)
- [NixOS Docker documentation](https://wiki.nixos.org/wiki/Docker)
- [NixOS OCI container options](https://search.nixos.org/options?channel=unstable&query=virtualisation.oci-containers)
