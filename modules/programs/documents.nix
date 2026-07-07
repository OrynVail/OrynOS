{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    # OFFICE tools
    onlyoffice-desktopeditors

    # Document conversion
    pandoc

    # OCR tools
    tesseract
    gImageReader

    # Text expansion
    espanso
  ];
}
