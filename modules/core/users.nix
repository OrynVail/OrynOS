{pkgs, ...}:{
  users.users.oryn = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "plugdev" "video" "adbusers" "i2c" "inputs" "kvm"];
    shell = pkgs.zsh;
  };
}
