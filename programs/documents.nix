{
  config,
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    # OFFICE tools
    onlyoffice-bin

    # PDF
    zathura

    # Document conversion
    pandoc

    # OCR tools
    tesseract
    gImageReader

    # Text expansion
    espanso
  ];
}
