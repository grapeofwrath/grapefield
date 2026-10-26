{
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    just
    alejandra
    compose2nix
  ];
}
