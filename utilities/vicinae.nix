{
  pkgs,
  inputs,
  ...
}: {
  imports = [inputs.vicinae.homeManagerModules.default];

  services.vicinae = {
    enable = true;
    systemd = {
      enable = true;
      autoStart = true; # default: false
      environment = {
        USE_LAYER_SHELL = 1;
      };
    };

    settings = {
      close_on_focus_loss = true;
      consider_preedit = true;
      pop_to_root_on_close = true;
      favicon_service = "twenty";
      search_files_in_root = true;
    };
  };
}
