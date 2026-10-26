{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.papra;
in {
  options.papra = {
    enable = mkEnableOption "Enable Papra";
  };

  config = mkIf cfg.enable {
    services.papra = {
      enable = true;
      environment = {
        AUTH_IS_REGISTRATION_ENABLED = false;
        TRUSTED_ORIGINS = "http://grapelab:1221,http://100.107.9.75:1221";
      };
    };
  };
}
