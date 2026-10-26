{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.lubelogger;
in {
  options.lubelogger = {
    enable = mkEnableOption "Enable LubeLogger";
  };

  config = mkIf cfg.enable {
    services.lubelogger = {
      enable = true;
      # port = 5001;
      # settings = {
      #   LUBELOGGER_DOMAIN = "0.0.0.0";
      #   LUBELOGGER_OPEN_REGISTRATION = "true";
      # };
    };
  };
}
