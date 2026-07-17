{ config, pkgs, username, ... }:

let
  peer-port = 51412;
in
{
  services.rtorrent = {
    enable = true;
    port = peer-port;
    package = pkgs.rtorrent;
    openFirewall = true;

    dataPermissions = "0770";

    configText = ''
      # Limit memory mapped chunk cache size
      pieces.memory.max.set = 2048M

      # Set umask
      system.umask.set = 0007

      # Prefer encrypted connections but allow fallback to bypass ISP throttling
      protocol.encryption.set = allow_incoming,try_outgoing,enable_retry

      # Enable distributed hash table & peer exchange for trackerless/magnet torrents
      dht.mode.set = auto
      dht.port.set = 6881
      protocol.pex.set = yes

      # Enable UDP tracker support
      trackers.use_udp.set = yes

      # Verify file hashes on completion automatically
      pieces.hash.on_completion.set = yes

      # Fine-tune connection limits
      throttle.max_downloads.global.set = 300
      throttle.max_uploads.global.set = 100
      throttle.min_peers.normal.set = 40
      throttle.max_peers.normal.set = 100
      throttle.min_peers.seed.set = 10
      throttle.max_peers.seed.set = 50
    '';
  };

  systemd.services.rtorrent.serviceConfig.LimitNOFILE = 16384;

  users.users.${username}.extraGroups = [ config.services.rtorrent.group ];

  networking.firewall.allowedTCPPorts = [ 6881 ];
  networking.firewall.allowedUDPPorts = [ peer-port 6881 ];

  environment.systemPackages = with pkgs; [
    rtorrent
    tremc
  ];
}
