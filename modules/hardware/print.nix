{ pkgs, ... }:
{
  services.printing = {
    enable = true;

    # Epson L130 is escp2-l130 in gutenprint; epson-escpr ships no PPD for it
    drivers = with pkgs; [ gutenprint ];

    # virtual "pdf" queue, output lands in /var/spool/cups-pdf-pdf/users/$USER
    cups-pdf.enable = true;
  };

  # mDNS, so driverless and network queues resolve without hand-written URIs
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # CUPS only auto-adds driverless printers, so without this the L130 is
  # detected and has no queue. Serial pins it to this unit.
  hardware.printers = {
    ensureDefaultPrinter = "EpsonL130";
    ensurePrinters = [
      {
        name = "EpsonL130";
        model = "gutenprint.5.3://escp2-l130/expert";
        deviceUri = "usb://EPSON/L130%20Series?serial=564A354B3232323430";
      }
    ];
  };

  environment.systemPackages = [ pkgs.system-config-printer ];
}
