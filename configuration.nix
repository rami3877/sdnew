{ config, lib, pkgs, ... }:

{
	imports =
		[
		./hardware-configuration.nix
    ./users.nix
		];


	nix.settings = {
		substituters = [
			"https://cache.nixos.org"
		];
    experimental-features = [ "nix-command" "flakes" ];
		connect-timeout = 60;
		download-attempts = 10;
	};

	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

	boot.kernelPackages = pkgs.linuxPackages_latest;
	networking.hostName = "nixos"; 
	environment.variables.XKB_DEFAULT_OPTIONS = "caps:escape";


	time.timeZone = "Asia/Amman";

	services.xserver.xkb = {
		layout = "us,ara";
		options = "caps:escape"; 
	};

	nixpkgs.config.allowUnfreePredicate = pkg:
	builtins.elem (lib.getName pkg) [ "corefonts" ];

	fonts.packages = with pkgs; [
		  corefonts
		  noto-fonts
		  noto-fonts-cjk-sans
		  noto-fonts-color-emoji
		  liberation_ttf
		  fira-code
		  fira-code-symbols
		  mplus-outline-fonts.githubRelease
		  dina-font
		  proggyfonts
		  nerdfetch
		  nerd-fonts.jetbrains-mono
	];

	environment.systemPackages = with pkgs; [
			wget
			neovim
			alacritty
			cinnamon
			brave
			onlyoffice-desktopeditors
			amiri
			git
			gcc 
			stdenv
			glibc.dev
	];

	fonts.fontconfig = {
		enable = true;
		defaultFonts = {
			sansSerif = [ "Cairo" "DejaVu Sans" ];
			serif = [ "Amiri" "DejaVu Serif" ];
		};
	};


# services
	services.openssh.enable = true;
	services.libinput.enable = false;
	services.xserver={
		enable = true;
		desktopManager.cinnamon.enable = true;

	};
	services.pipewire = {
		enable = true;
		pulse.enable = true;
	};

# network
	networking.firewall.allowedTCPPorts = [ 22 ];
	networking.firewall.enable = false;
	networking.networkmanager.enable = true;
	system.copySystemConfiguration = true;

# programs
  programs.firefox.enable = false;
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
	  stdenv.cc.cc.lib
		  zlib
  ];

	system.stateVersion = "26.05";
}
