{ config, pkgs, ... }:

{
  imports = [
    ./../modules/base
  ];
  home.packages = with pkgs; [
    zip
    xz
    unzip
    p7zip

    ripgrep
    jq
    yq-go
    fzf

    mtr
    iperf3
    dnsutils
    ldns
    nmap
    ipcalc

    cowsay
    file
    which
    tree
    gnutar
    gawk
    zstd
    gnupg

    nix-output-monitor

    glow

    btop
    iotop
    iftop

    strace
    ltrace
    lsof

    sysstat
    lm_sensors
    pciutils
    usbutils
  ];

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "grapeofwrath";
        email = "69535018+grapeofwrath@users.noreply.github.com";
      };
      url."ssh://git@github.com" = {
        insteadOf = "https://github.com";
      };
      init.defaultBranch = "main";
    };
  };

  home.stateVersion = "26.05";
}
