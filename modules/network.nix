{pkgs, ...}: {
  networking = {
    enableIPv6 = false;
    nameservers = ["1.1.1.1" "1.0.0.1" "8.8.8.8"];

    nftables.enable = true;
    firewall.enable = true;

    networkmanager = {
      enable = true;
      dns = "none";
      wifi.powersave = true;
      plugins = with pkgs; [
        networkmanager-openvpn
      ];
    };

    dhcpcd.enable = false;
  };

  services = {
    openssh = {
      enable = true;
      settings.UseDns = false; 
    };
  };

  # Editable /etc/hosts for htb machines
  environment.etc.hosts.enable = false;
}