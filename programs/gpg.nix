{
  pkgs,
  lib,
  ...
}: {
  # Install gpg 
  home.packages = with pkgs; [
    gnupg
  ];
  
  programs.gpg = {
    enable = true;
    settings = {
      personal-cipher-preferences = "AES256";
      personal-digest-preferences = "SHA512";
      personal-compress-preferences = "ZLIB BZIP2 ZIP Uncompressed";
      default-preference-list = "SHA512 AES256 ZLIB BZIP2 ZIP Uncompressed";
      cert-digest-algo = "SHA512";
      s2k-digest-algo = "SHA512";
      s2k-cipher-algo = "AES256";
      charset = "utf-8";
      fixed-list-mode = true;
      no-comments = true;
      no-emit-version = true;
      no-greeting = true;
      keyid-format = "0xlong";
      list-options = "show-uid-validity";
      verify-options = "show-uid-validity";
      with-key-origin = true;
      require-cross-certification = true;
      no-symkey-cache = true;
      use-agent = true;
      # throw-keyids = true;
      
      # keyserver for key retrieval
      keyserver = "hkps://keys.openpgp.org";
      keyserver-options = "honor-keyserver-url";
    };
  };
    
    services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 86400; # Corresponds to default-cache-ttl in gpg-agent.conf
    defaultCacheTtlSsh = 86400; # Corresponds to default-cache-ttl-ssh in gpg-agent.conf
    enableExtraSocket = true; # Corresponds to --enable-extra-socket for the agent daemon
    enableSshSupport = true;  # Corresponds to --enable-ssh-support for the agent daemon
    pinentry.package = pkgs.pinentry-curses; 
  };
}
  
