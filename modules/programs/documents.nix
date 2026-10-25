{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    # OFFICE tools
    libreoffice

    # Document conversion
    pandoc

    # OCR tools
    (tesseract.override { enableLanguages = [ "eng" ]; })
    gImageReader

    # Text expansion
    espanso
  ];
}
