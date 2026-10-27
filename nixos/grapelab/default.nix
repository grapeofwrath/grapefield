{
  config,
  lib,
  pkgs,
  defaultUser,
  ...
}: {
  imports = [
    ./hardware-configuration.nix

    ./../modules/server
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
  nix.settings.auto-optimise-store = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "grapelab"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  time.timeZone = "America/Los_Angeles";

  i18n.defaultLocale = "en_US.UTF-8";

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

  immich.enable = true;
  papra.enable = true;
  ai.enable = true;
  podman.enable = true;

  system.stateVersion = "26.05"; # Did you read the comment?
}
