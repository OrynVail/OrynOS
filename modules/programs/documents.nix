{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    # OFFICE tools
    libreoffice-fresh

    # Document conversion
    pandoc

    # OCR tools
    tesseract
    gImageReader

    # Text expansion
    espanso
  ];
}
