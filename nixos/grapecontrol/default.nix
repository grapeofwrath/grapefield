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

  users.users.marcus = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager"]; # Enable ‘sudo’ for the user.
    initialPassword = "changeme";
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
    allowedTCPPorts = [ 22 80 443 ];
  };
  services.tailscale.enable = true;
  services.caddy = {
    enable = true;
    virtualHosts."montrosemillwork.com".extraConfig = ''
      reverse_proxy localhost:5050
    '';
  };
  services.montrose.enable = true;

  system.stateVersion = "26.05"; # Did you read the comment?
}
