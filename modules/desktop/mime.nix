{ pkgs, lib, ... }:
with lib;
let
  defaultApps = {
    image = [ "org.gnome.Loupe.desktop" ];
    audio = [ "mpv.desktop" ];
    video = [ "mpv.desktop" ];
    pdf = [ "zathura.desktop" ];
  };

  mimeMap = {
    image = [
      "image/bmp"
      "image/gif"
      "image/jpeg"
      "image/jpg"
      "image/png"
      "image/svg+xml"
      "image/tiff"
      "image/vnd.microsoft.icon"
      "image/webp"
    ];
    audio = [
      "audio/aac"
      "audio/mpeg"
      "audio/ogg"
      "audio/opus"
      "audio/wav"
      "audio/webm"
      "audio/x-matroska"
    ];
    video = [
      "video/mp2t"
      "video/mp4"
      "video/mpeg"
      "video/ogg"
      "video/webm"
      "video/x-flv"
      "video/x-matroska"
      "video/x-msvideo"
    ];
    pdf = [ "application/pdf" ];
  };

  associations = with lists;
    listToAttrs (flatten (mapAttrsToList
      (key: map (type: attrsets.nameValuePair type defaultApps."${key}"))
      mimeMap));
in {
  xdg = {
    configFile."mimeapps.list".force = true;
    mimeApps = {
      enable = true;
      associations.added = associations;
      defaultApplications = associations;
    };
  };
}