{ pkgs, ... }: {
  # Git Identity & Configuration
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Oryn Vail";
        email = "orynvail@gmail.com";
      };
    };
  };
}
