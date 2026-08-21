{pkgs, ...}:{
  users.users.oryn = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "plugdev" "video" "adbusers" "i2c" "inputs" "kvm"];
    shell = pkgs.zsh;

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILlvXkJs+A7u5d6/+hyK37xhYE1LvGM7sczqDNeUpwt5"
    ];
  };
}
