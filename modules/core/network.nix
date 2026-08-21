{pkgs, ...}: {
  networking = {
    enableIPv6 = false;
    nameservers = ["1.1.1.1" "1.0.0.1" "8.8.8.8"];

    nftables.enable = true;
    firewall.enable = true;

    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
      wifi.powersave = true;
      plugins = with pkgs; [
        networkmanager-openvpn
      ];
    };

    dhcpcd.enable = false;
  };

  services = {
    resolved.enable = true;

    cloudflare-warp.enable = true;

    # Key-only, and not exposed to attached networks. Reachable over loopback
    # or a VPN interface; add the port back if that ever changes.
    openssh = {
      enable = true;
      openFirewall = false;
      settings = {
        UseDns = false;
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
      };
    };
  };

  # Editable /etc/hosts for htb machines
  environment.etc.hosts.enable = false;
}