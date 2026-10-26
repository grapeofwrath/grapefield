{
  config,
  pkgs,
  gLib,
  ...
}:

{
  programs = {
    fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting
      '';
    };
    bash = {
      enable = true;
      initExtra = ''
        if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
        then
          shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
          exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
        fi
      '';
    };
    fzf.enable = true;
    ripgrep.enable = true;
    zoxide = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
    };
    direnv = {
      enableBashIntegration = true;
      enableFishIntegration = true;
      nix-direnv.enable = true;
    };
    starship = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      settings = {
        aws.disabled = true;
        gcloud.disabled = true;
        kubernetes.disabled = true;
        directory = {
          #trunicate_length = 8;
          #trunicate_to_repo = false;
          read_only = " 󰌾";
        };
        username = {
          format = "[$user]($style)@";
          show_always = true;
        };
        hostname = {
          ssh_only = false;
          style = "bold green";
          ssh_symbol = " ";
        };
        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[➜](bold red)";
        };
        c.symbol = " ";
        docker_context.symbol = " ";
        git_branch.symbol = " ";
        golang.symbol = " ";
        lua.symbol = " ";
        memory_usage.symbol = "󰍛 ";
        nix_shell.symbol = " ";
        package.symbol = "󰏗 ";
        python.symbol = " ";
        rust.symbol = " ";
        zig.symbol = " ";
        os.symbols = {
          Arch = " ";
          Debian = " ";
          EndeavourOS = " ";
          Fedora = " ";
          Garuda = "󰛓 ";
          Linux = " ";
          Macos = " ";
          NixOS = " ";
          Pop = " ";
          Raspbian = " ";
          Ubuntu = " ";
          Unknown = " ";
          Windows = "󰍲 ";
        };
      };
    };
  };
}
