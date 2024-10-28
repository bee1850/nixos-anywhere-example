{
  modulesPath,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
  ];
  boot = { 
   loader.systemd-boot.enable = true;
   supportedFilesystems = [ "zfs" ];
   initrd.postDeviceCommands = lib.mkAfter ''
    zfs rollback -r rpool/local/root@blank
  '';
  };
  services.openssh.enable = true;
  networking.hostId = "4145f0bc";

  environment.systemPackages = map lib.lowPrio [
    pkgs.curl
    pkgs.gitMinimal
  ];

  users.users.root.openssh.authorizedKeys.keys = [
    # change this to your ssh key
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGjO8XQy9w6Yas1DaTq+4vhWiFeyz6uZcngaHkIeUwf8 NixOS WSL"
  ];

  system.stateVersion = "24.05";
}
