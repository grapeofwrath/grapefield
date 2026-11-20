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
  users.users.root.openssh.authorizedKeys.keys = [''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEJ8yDdkacpKp8z72NwAhbQKnvjRWvQltrQ41uFi3HK7 grapeofwrath@pm.me'' ];

  users.users.marcus = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "minecraft"]; # Enable ‘sudo’ for the user.
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

  services.purpur = {
    enable = true;
    version = "26.3";
    build = "2658";
    hash = "sha256-7y8Z7C/xUnOwIOCM1Gv5WjYpYkOGQzewaOJfW3XALj8=";
    javaPackage = pkgs.jdk25_headless;
    memory = "8192M";
    motd = ''\u00A7b\u00A7l\u26CF \u00A76\u00A7lBuilder's \u00A7e\u00A7lParadise \u00A7b\u00A7l\u26CF\n\u00A77Don't look \u00A7c\u00A7kback\u00A77!'';
    seed = "6994583329261680997";
  };

  immich.enable = true;
  papra.enable = true;
  ai.enable = true;
  podman.enable = true;

  system.stateVersion = "26.05"; # Did you read the comment?
}
