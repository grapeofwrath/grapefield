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
    ./../modules/server

    inputs.montrose.nixosModules.default
  ];

  # services.xserver.enable = true;

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

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

  # environment.systemPackages = with pkgs; [
  #   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #   wget
  # ];

  services.openssh.enable = true;
  services.getty.autologinUser = defaultUser;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 80 443 ];
  };
  services.tailscale.enable = true;
  services.caddy = {
    enable = true;
    virtualHosts."https://localhost:4002".extraConfig = ''
      reverse_proxy localhost:5002
    '';
  };

  services.montrose.enable = true;

  immich.enable = true;
  papra.enable = true;
  ai.enable = true;
  podman.enable = true;

  system.stateVersion = "26.05"; # Did you read the comment?
}
