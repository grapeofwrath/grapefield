{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.fish;
in {
  options.fish = {
  };
  config = {
    programs = {
      fish.enable = true;
      bash = {
        enable = true;
      };
    };
  };
}
