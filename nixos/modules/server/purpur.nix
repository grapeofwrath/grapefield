{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.services.purpur;

  purpurPackage = pkgs.stdenv.mkDerivation {
    pname = "purpur";
    version = "${cfg.version}-${cfg.build}";

    src = pkgs.fetchurl {
      url = "https://api.purpurmc.org/v2/purpur/${cfg.version}/${cfg.build}/download";
      inherit (cfg) hash;
      name = "purpur-${cfg.version}-${cfg.build}.jar";
    };

    dontUnpack = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin $out/lib/minecraft
      cp $src $out/lib/minecraft/server.jar

      # services.minecraft-server runs `${"$"}{package}/bin/minecraft-server ${"$"}{jvmOpts}`,
      # so JVM options must come *before* -jar.
      cat > $out/bin/minecraft-server <<EOF
      #!${pkgs.runtimeShell}
      exec ${cfg.javaPackage}/bin/java "\$@" -jar $out/lib/minecraft/server.jar nogui
      EOF
      chmod +x $out/bin/minecraft-server

      runHook postInstall
    '';

    meta = {
      description = "Purpur Minecraft server";
      homepage = "https://purpurmc.org";
      mainProgram = "minecraft-server";
    };
  };
in {
  options.services.purpur = {
    enable = mkEnableOption "PurpurMC Server";

    version = mkOption {
      type = types.str;
      example = "1.21.4";
      description = "Minecraft version to run (must exist on https://api.purpurmc.org/v2/purpur).";
    };

    build = mkOption {
      type = types.str;
      example = "2327";
      description = ''
        Purpur build number for `version`. Pinned (not "latest") so the hash stays valid.
        List builds with: curl -s https://api.purpurmc.org/v2/purpur/<version>
      '';
    };

    hash = mkOption {
      type = types.str;
      default = lib.fakeHash;
      example = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
      description = ''
        SRI hash of the jar. Leave as the default on the first build; Nix will fail
        and print the correct hash in the "got:" line.
      '';
    };

    javaPackage = mkOption {
      type = types.package;
      default = pkgs.jre_headless;
      defaultText = literalExpression "pkgs.jre_headless";
      example = literalExpression "pkgs.jdk25_headless";
      description = "Java runtime. Newer Minecraft versions require newer Java (21+, later 25).";
    };

    port = mkOption {
      type = types.port;
      default = 43000;
      description = "Server port.";
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = "Open the server port in the firewall.";
    };

    memory = mkOption {
      type = types.str;
      default = "2048M";
      description = "Value for both -Xms and -Xmx.";
    };

    motd = mkOption {
      type = types.str;
      default = "NixOS Minecraft server!";
      description = "Message of the day";
    };

    seed = mkOption {
      type = types.str;
      description = "Level Seed";
    };

    restartMessage = mkOption {
      type = types.str;
      default = "Server restarting in 2 minutes";
      description = "Message from the server before it restarts";
    };

    restartTime = mkOption {
      type = types.str;
      default = "03:00";
      description = "24hr time of restart <hour>:<min>";
    };
  };

  config = mkIf cfg.enable {
    services.minecraft-server = {
      enable = true;
      eula = true; # by enabling this you accept Mojang's EULA
      declarative = true;
      openFirewall = cfg.openFirewall;
      package = purpurPackage;
      serverProperties = {
        server-port = cfg.port;
        difficulty = 3;
        gamemode = 1;
        max-players = 5;
        motd = cfg.motd;
        white-list = false;
        enable-rcon = true;
        "rcon.password" = "herobrine";
        level-seed = cfg.seed;
      };
      jvmOpts = "-Xms${cfg.memory} -Xmx${cfg.memory}";
    };

    systemd.services.minecraft-restart = {
      description = "Daily Minecraft server restart";
      serviceConfig.Type = "oneshot";
      script = ''
        echo "say ${cfg.restartMessage}" > /run/minecraft-server.stdin || true
        sleep 120
        ${pkgs.systemd}/bin/systemctl try-restart minecraft-server.service
      '';
    };

    systemd.timers.minecraft-restart = {
      wantedBy = [ "timers.target" ];
      timerConfig.OnCalendar = "*-*-* ${cfg.restartTime}:00";
    };
    systemd.tmpfiles.rules = [
      "d /var/lib/minecraft 2770 minecraft minecraft - -"
    ];
    systemd.services.minecraft-server.serviceConfig.UMask = lib.mkForce "0007";
  };
}
