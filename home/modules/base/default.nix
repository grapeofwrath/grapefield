{
  config,
  pkgs,
  gLib,
  ...
}:

{
  imports = gLib.scanPaths ./.;

  home = {
    shellAliases = {
      n = "hx";
      ".." = "cd ..";
    };

    stateVersion = "26.05";
  };

  programs.starship.enable = true;

  systemd.user.startServices = "sd-switch";
}
