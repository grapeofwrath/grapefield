{
  config,
  pkgs,
  lib,
  pkgs-stable,
  defaultUser,
  ...
}:
with lib; let
  cfg = config.podman;
in {
  options.podman = {
    enable = mkEnableOption "podman";
  };
  config = mkIf cfg.enable {
    virtualisation.containers = {
      enable = true;
      registries.settings = {
        unqualified-search-registries = ["docker.io"];
        registry = [
          {
            location = "docker.io";
          }
          {
            location = "quay.io";
          }
        ];
      };
    };
    virtualisation = {
      podman = {
        enable = true;
        dockerCompat = true;
        defaultNetwork.settings.dns_enabled = true;
      };
    };
    environment.systemPackages = with pkgs; [
      dive
      podman-tui
      podman-compose
    ];
    users.users.${defaultUser}.extraGroups = [ "podman" ];
  };
}
