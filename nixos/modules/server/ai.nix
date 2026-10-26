{
  config,
  pkgs,
  lib,
  pkgs-stable,
  ...
}:
with lib; let
  cfg = config.ai;
in {
  options.ai = {
    enable = mkEnableOption "AI";
  };
  config = mkIf cfg.enable {
    services = {
      ollama = {
        enable = true;
        package = pkgs.ollama-cpu;
        loadModels = [
          "llama3.2"
        ];
      };
      open-webui = {
        enable = true;
        package = pkgs-stable.open-webui;
        port = 5005;
      };
    };
  };
}
