{ pkgs, ... }: {
  boot = {
    kernelModules = ["tcp_bbr"];

    kernel.sysctl = {
      ## TCP hardening
      "net.ipv4.icmp_ignore_bogus_error_responses" = 1;
      "net.ipv4.conf.default.rp_filter" = 1;
      "net.ipv4.conf.all.rp_filter" = 1;

      # Do not accept IP source route packets
      "net.ipv4.conf.all.accept_source_route" = 0;
      "net.ipv6.conf.all.accept_source_route" = 0;

      # Don't send ICMP redirects
      "net.ipv4.conf.all.send_redirects" = 0;
      "net.ipv4.conf.default.send_redirects" = 0;

      # Refuse ICMP redirects (MITM mitigations)
      "net.ipv4.conf.all.accept_redirects" = 0;
      "net.ipv4.conf.default.accept_redirects" = 0;
      "net.ipv4.conf.all.secure_redirects" = 0;
      "net.ipv4.conf.default.secure_redirects" = 0;
      "net.ipv6.conf.all.accept_redirects" = 0;
      "net.ipv6.conf.default.accept_redirects" = 0;

      # Protects against SYN flood attacks
      "net.ipv4.tcp_syncookies" = 1;

      # Incomplete protection again TIME- WAIT assassination
      "net.ipv4.tcp_rfc1337" = 1;

      ## TCP optimization
      "net.ipv4.tcp_fastopen" = 3;
      "net.ipv4.ip_forward" = 1; # Required for container/VPN routing

      ## Network performance optimizations
      "net.core.rmem_default" = 262144;
      "net.core.rmem_max" = 134217728;
      "net.core.wmem_default" = 262144;
      "net.core.wmem_max" = 134217728;
      "net.ipv4.tcp_rmem" = "4096 131072 134217728";
      "net.ipv4.tcp_wmem" = "4096 65536 134217728";
      "net.ipv4.tcp_window_scaling" = 1;
      "net.ipv4.tcp_timestamps" = 1;
      "net.ipv4.tcp_sack" = 1;
      "net.ipv4.tcp_adv_win_scale" = 1;
      "net.ipv4.tcp_fin_timeout" = 15;
      "net.ipv4.tcp_tw_reuse" = 1;
    };
  };

  security = {
    sudo.wheelNeedsPassword = false;
    rtkit.enable = true;
    polkit.enable = true;
    protectKernelImage = true;

    apparmor = {
      enable = true;
      killUnconfinedConfinables = true;
      packages = [ pkgs.apparmor-profiles ];
    };

    acme.acceptTerms = true;
  };

  services.gnome.gnome-keyring.enable = true;
}
