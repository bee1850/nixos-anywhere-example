{ lib, ... } :
{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/sda";
        content = {
          type = "gpt";
          partitions = {
            boot = {
                name = "boot";
                size = "1M";
                type = "EF02";
            };
            efi = {
              size = "512M";
              type = "EF00";
              name = "efi";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            root = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "zfspool";
              };
            };
          };
        };
      };
    };
    zpool = {
      zfspool = {
        type = "zpool";
        rootFsOptions = {
          canmount = "off";
        };
        datasets = {
          root = {
            type = "zfs_fs";
            mountpoint = "/";
            options.mountpoint = "legacy";
            postCreateHook = "zfs snapshot zfspool/root@blank";
          };
          nix = {
            type = "zfs_fs";
            mountpoint = "/nix";
            options.mountpoint = "legacy";
          };
          persist = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            mountpoint = "/persist";
          };
          home = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            mountpoint = "/home";
            postCreateHook = "zfs snapshot zfspool/home@blank";
          };
        };
      };
    };
  };
}
