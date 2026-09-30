{ config, pkgs, lib, ... }:

let
  home-manager = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/release-26.05.tar.gz;
in
{
  imports =
    [
      "${home-manager}/nixos"
    ];

  users.users.rami.isNormalUser = true;
  users.users.rami.extraGroups = [ "wheel" ];
  users.users.rami.shell = pkgs.zsh;
  programs.zsh.enable = true;

  home-manager.backupFileExtension = "backup";
  home-manager.users.rami = { pkgs, ... }: {

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
    };
    home.packages = with pkgs; [
        tree
        xsel
        zsh
        kicad
        cmake
        nmap
        file 
        freecad
        unzip
        glibc.dev
        stdenv
        ripgrep
        pyright
    ];
    home.shellAliases = {
          nixosE = "sudo -E nvim /etc/nixos/configuration.nix";
          rebuild = "sudo nixos-rebuild switch";
    };
    home.sessionVariables = {
        CPATH = "${pkgs.glibc.dev}/include:${pkgs.gcc.libc.dev}/include";
    };
    home.stateVersion = "26.05";
  };
}
