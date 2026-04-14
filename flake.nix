{
  description = "Amemiya's nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, }:
  let
    # Automatically detect the hostname of the current machine.
    # Read from a temp file written by the nrs alias before darwin-rebuild runs.
    hostname = builtins.replaceStrings ["\n"] [""]
      (builtins.readFile /tmp/.nix-darwin-hostname);
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ pkgs.vim
        ];

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      programs.zsh.enable = true;

      # Ensure GUI apps (VS Code etc.) can find Nix-managed binaries
      environment.systemPath = [
        "/etc/profiles/per-user/amemiya/bin"
        "/run/current-system/sw/bin"
      ];

      # Install Nerd Fonts
      fonts.packages = [
        pkgs.hackgen-nf-font
      ];

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      # The platform the configuration will be used on.
      # Automatically detect Intel (x86_64-darwin) or Apple Silicon (aarch64-darwin).
      nixpkgs.hostPlatform = builtins.currentSystem;
      nixpkgs.config.allowUnfree = true;
      
      #brew
      homebrew = {
        enable = true;

        brews = [
          "juliaup"
        ];

        casks = [
          "scroll-reverser"
          "iterm2"
          "warp"
        ];
      };


      users.users.amemiya = {
        name = "amemiya";
        home = "/Users/amemiya";
      };
      system.primaryUser = "amemiya";
      home-manager.users."amemiya" = import ./home.nix;

    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild switch --flake . --impure
    darwinConfigurations.${hostname} = nix-darwin.lib.darwinSystem {
      modules =
      [ configuration 
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }
      ];
    };
  };
}
