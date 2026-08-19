{ config, pkgs, username, ... }:

let
  peer-port = 51412;
  rt = config.services.rtorrent;
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

      schedule = dht_bootstrap_1,30,0,"dht.add_node=router.bittorrent.com:6881"
      schedule = dht_bootstrap_2,31,0,"dht.add_node=dht.transmissionbt.com:6881"
      schedule = dht_bootstrap_3,32,0,"dht.add_node=router.utorrent.com:6881"
      schedule = dht_bootstrap_4,33,0,"dht.add_node=dht.libtorrent.org:25401"

      # Watch folders, .torrent files only — magnets will not load from a file
      schedule = watch_start, 10, 10, ((load.start, (cat, (cfg.watch), "start/*.torrent")))
      schedule = watch_load, 11, 10, ((load.normal, (cat, (cfg.watch), "load/*.torrent")))

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

  services.flood = {
    enable = true;
    host = "127.0.0.1";
    port = 3000;
    extraArgs = [
      "--auth=none"
      "--rtsocket=${rt.rpcSocket}"
    ];
  };

  systemd.services.flood.serviceConfig.SupplementaryGroups = [ rt.group ];

  systemd.services.rtorrent.serviceConfig.LimitNOFILE = 16384;

  systemd.tmpfiles.rules = [
    "d '${rt.downloadDir}' 0770 ${rt.user} ${rt.group} -"
    "d '${rt.dataDir}/watch/start' 0770 ${rt.user} ${rt.group} -"
    "d '${rt.dataDir}/watch/load' 0770 ${rt.user} ${rt.group} -"
  ];

  users.users.${username}.extraGroups = [ rt.group ];

  networking.firewall.allowedTCPPorts = [ 6881 ];
  networking.firewall.allowedUDPPorts = [ peer-port 6881 ];

  environment.sessionVariables.PYRO_SCGI_URL = "scgi+unix://${rt.rpcSocket}";

  environment.systemPackages = with pkgs; [
    rtorrent
    pyrosimple
  ];
}
