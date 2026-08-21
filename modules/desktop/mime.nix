{ pkgs, lib, ... }:
with lib;
let
  defaultApps = {
    web = [ "brave-browser.desktop" ];
    image = [ "org.gnome.Loupe.desktop" ];
    audio = [ "mpv.desktop" ];
    video = [ "mpv.desktop" ];
    pdf = [ "org.pwmt.zathura.desktop" ];
    text = [ "nvim.desktop" ];
    archive = [ "org.gnome.FileRoller.desktop" ];
    directory = [ "yazi.desktop" ];
  };

  mimeMap = {
    web = [
      "text/html"
      "x-scheme-handler/http"
      "x-scheme-handler/https"
      "x-scheme-handler/about"
      "x-scheme-handler/unknown"
      "application/xhtml+xml"
    ];
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
    pdf = [
      "application/pdf"
      "application/epub+zip"
      "image/vnd.djvu"
      "application/postscript"
    ];
    text = [
      "text/plain"
      "text/markdown"
      "text/x-markdown"
      "text/english"
      "text/x-log"
      "application/json"
      "application/x-yaml"
      "text/x-yaml"
      "application/toml"
      "text/x-toml"
      "application/xml"
      "text/xml"
      "text/x-nix"
      "text/css"
      "text/javascript"
      "application/javascript"
      "application/x-javascript"
      "text/x-typescript"
      "text/x-python"
      "text/x-python3"
      "application/x-python-code"
      "text/x-lua"
      "text/x-go"
      "text/x-rust"
      "text/rust"
      "text/x-ruby"
      "text/x-perl"
      "application/x-perl"
      "text/x-php"
      "text/x-haskell"
      "text/x-sql"
      "text/x-diff"
      "text/x-patch"
      "text/x-cmake"
      "text/x-makefile"
      "text/x-c"
      "text/x-c++"
      "text/x-csrc"
      "text/x-chdr"
      "text/x-c++src"
      "text/x-c++hdr"
      "text/x-java"
      "text/x-tex"
      "text/x-shellscript"
      "application/x-shellscript"
      "application/x-desktop"
    ];
    archive = [
      "application/zip"
      "application/x-tar"
      "application/gzip"
      "application/x-compressed-tar"
      "application/x-bzip2"
      "application/x-bzip-compressed-tar"
      "application/x-xz"
      "application/x-xz-compressed-tar"
      "application/x-7z-compressed"
      "application/vnd.rar"
      "application/x-rar-compressed"
    ];
    directory = [ "inode/directory" ];
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