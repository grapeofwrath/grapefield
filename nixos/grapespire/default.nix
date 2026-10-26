{ config, pkgs, inputs, ... }:

{
  imports = [
      ./hardware-configuration.nix

      ./../modules/base
      ./../modules/server

      inputs.dux-files.nixosModules.dux-files
      inputs.dms-plugin-registry.nixosModules.default
    ];

  services.displayManager.dux-greeter = {
    enable = true;
    compositor.name = "hyprland";
    configHome = "/home/marcus";
    logs = {
      save = true;
      path = "/tmp/dux-greeter.log";
    };
  };

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 24*1024;
  }];

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    # jack.enable = true;
  };

  services.libinput.enable = true;

  users.users."marcus" = {
    isNormalUser = true;
    description = "Marcus";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
      brave
    ];
  };

  programs.firefox.enable = true;

  services.tailscale.enable = true;

  environment.systemPackages = with pkgs; [
    wget
    git
    helix
    curl
    kitty
  ];

  environment.variables.EDITOR = "helix";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };


  services.openssh.enable = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  programs.hyprland = {
    enable = true;
  };
  programs.dux-shell = {
    enable = true;
    systemd = {
      enable = true;
      restartIfChanged = true;
    };
    plugins = {
      dankActions.enable = true;
      dankHooks.enable = true;
      dankLauncherKeys.enable = true;
      activateLinux.enable = true;
      sathiAi.enable = true;
    };
  };
  programs.dux-search.enable = true;
  programs.dux-files.enable = true;

  podman.enable = true;
}
