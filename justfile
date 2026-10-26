deploy:
    sudo nixos-rebuild switch --flake .

rebuild:
    sudo nixos-rebuild boot --flake .

debug:
    nixos-rebuild switch --flake . --use-remote-sudo --show-trace --verbose

up:
    nix flake update

# update specific input
upp:
    nix flake update $(i)

clean:
    sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 7d

gc:
    sudo nix-collect-garbage --delete-old

fmt:
    alejandra .
