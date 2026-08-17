{...}: let
  # NVMe enumeration order is not stable across boots; mount by UUID only.
  opts = [
    "uid=1000"
    "gid=100"
    "windows_names"
    "nofail"
    "x-gvfs-show"
    "x-systemd.automount"
  ];
in {
  # Windows C: — ro while Fast Startup leaves the volume hibernated.
  fileSystems."/mnt/predator" = {
    device = "/dev/disk/by-uuid/5CEC640CEC63DF30";
    fsType = "ntfs3";
    options = opts ++ ["ro"];
    noCheck = true;
  };

  fileSystems."/mnt/data" = {
    device = "/dev/disk/by-uuid/D2EE68ABEE688995";
    fsType = "ntfs3";
    options = opts;
    noCheck = true;
  };
}
