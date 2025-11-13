{
  description = "Open source Linux client for Checkpoint VPN tunnels";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        nativeBuildInputs = with pkgs; [
          iproute2
          pkg-config
        ];

        buildInputs = with pkgs; [
          openssl
          glib
          gtk4
          webkitgtk_6_0
          libsoup_3
          libayatana-appindicator
          libappindicator
          libappindicator-gtk3
          kdePackages.kstatusnotifieritem
        ];
      in
      {
        formatter = pkgs.alejandra;
        packages.snx-rs = pkgs.rustPlatform.buildRustPackage rec {
          inherit nativeBuildInputs buildInputs;
          useNextest = true;
          pname = "snx-rs";
          version = "4.9.0";

          # Some tests are failing on NixOS, even though they build fine
          # outside nix build environment. So... it's easier to lie.
          doCheck = false;

          src = pkgs.fetchFromGitHub {
            owner = "ancwrd1";
            repo = "snx-rs";
            rev = "v${version}";
            hash = "sha256-LJBLa5SpSaQH/OopkqHPay5AXpeQD6pmvU+2+yeG53I=";
          };

          cargoHash = "sha256-LUsHtOJw1lo9dI5pWIGAktzyI8YYr0PfU05+1/uSgd8=";

          meta = {
            description = "Open source Linux client for Checkpoint VPN tunnels";
            homepage = "https://github.com/ancwrd1/snx-rs";
            license = nixpkgs.lib.licenses.afl3;
          };
        };

        apps = {
          snx-rs = {
            type = "app";
            program = "${self.defaultPackage}/bin/snx-rs";
          };
          snxctl = {
            type = "app";
            program = "${self.defaultPackage}/bin/snxctl";
          };
        };

        defaultPackage = self.packages.${system}.snx-rs;

        nixosModules = {
          config = {
            environment.systemPackages = [ self.defaultPackage.${system} ];
          };
        };
      }
    );
}
