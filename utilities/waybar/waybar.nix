{ pkgs, lib, ... }:

{
  ############################################################
  ## 1.                Copy waybar files                    ##
  ############################################################
  home.file.".config/waybar/config.jsonc" = {
    source = ./config.jsonc;
    force  = true;        
  };

  home.file.".config/waybar/style.css"   = { source = ./style.css;   force = true; };
  home.file.".config/waybar/theme.css"   = { source = ./theme.css;   force = true; };

  home.file.".config/waybar/modules" = {
    source    = ./modules;
    recursive = true;    
    force     = true;
  };


  ############################################################
  ## 2.  Install Waybar itself                              ##
  ############################################################
  home.packages = with pkgs; [
    waybar
    playerctl
    gobject-introspection
    (python3.withPackages (ps: with ps; [ pygobject3 ]))
    python-pyamdgpuinfo
    lm_sensors
  ];

  ############################################################
  ## 3.  Disable the Hydenix generator bar                  ##
  ############################################################
  hydenix.hm.waybar.enable = lib.mkForce false;
}