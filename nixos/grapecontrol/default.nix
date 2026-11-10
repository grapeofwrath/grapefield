{
  config,
  lib,
  pkgs,
  inputs,
  defaultUser,
  ...
}: {
  imports = [
    ./hardware-configuration.nix

    ./../modules/base

    inputs.montrose.nixosModules.default
  ];

  # don't change
  # Workaround for https://github.com/NixOS/nix/issues/8502
  services.logrotate.checkConfig = false;

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;
  networking.domain = "";
  # 

  nix.settings.trusted-public-keys = [
    "grape-nix-cache:CbEHUYEzXkpPNvjALkG04Nw+tjs/zOU8DjVX0r6QteU="
  ];

  users.users.marcus = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager"]; # Enable ‘sudo’ for the user.
    initialPassword = "changeme";
    openssh.authorizedKeys.keys = [''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEJ8yDdkacpKp8z72NwAhbQKnvjRWvQltrQ41uFi3HK7 grapeofwrath@pm.me'' ];
    packages = with pkgs; [
      tree
      git
      vim
      curl
      wget
      htop
      helix
      alejandra
      just
    ];
  };

  security.sudo.wheelNeedsPassword = true;
  services.openssh.enable = true;
  services.getty.autologinUser = defaultUser;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 80 443 2222 ];
  };
  services.tailscale.enable = true;
  services.caddy = {
    enable = true;
    virtualHosts."montrosemillwork.com".extraConfig = ''
      reverse_proxy localhost:5050
    '';
  };
  services.montrose.enable = true;

  system.stateVersion = "23.11"; # Did you read the comment?
}
