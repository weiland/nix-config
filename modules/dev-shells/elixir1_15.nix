{
  description = "Elixir development environment (atm mainly for macOS).";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ ];
      systems = [ "aarch64-darwin" ];
      perSystem =
        {
          config,
          self',
          inputs',
          pkgs,
          system,
          ...
        }:
        let
          inherit (pkgs.lib) optional optionals;
          inherit (pkgs.stdenv) isDarwin;
          # elixir = pkgs.beam.packages.erlang.elixir;

          # Set the Erlang version
          erlangVersion = "erlangR25"; # TODO: use R26?
          # Set the Elixir version
          elixirVersion = "elixir_1_15";

          # erlang = pkgs.beam.interpreters.${erlangVersion};
          beamPackages = pkgs.beam.packages.${erlangVersion};
          # beamPackages = with pkgs.beam_minimal; packagesWith interpreters.${elixirVersion};
          elixir = beamPackages.${elixirVersion};
          elixir-ls = beamPackages.elixir-ls;

          locales = pkgs.glibcLocales;
        in
        {
          devShells.default = pkgs.mkShell {
            name = "elixir dev";

            buildInputs = [
              elixir
              elixir-ls
              locales
            ]
            ++ (with pkgs; [
              # nodejs
            ])
            ++ optional pkgs.stdenv.isLinux pkgs.inotify-tools
            ++ optional isDarwin pkgs.terminal-notifier
            ++ optionals isDarwin (
              with pkgs.darwin.apple_sdk.frameworks;
              [
                CoreFoundation
                CoreServices
              ]
            );

            shellHook = ''
              mkdir -p .nix-mix
              mkdir -p .nix-hex
              export MIX_HOME=$PWD/.nix-mix
              export HEX_HOME=$PWD/.nix-hex
              export PATH=$MIX_HOME/bin:$PATH
              export PATH=$HEX_HOME/bin:$PATH
              export PATH=$MIX_HOME/escripts:$PATH

              #${elixir}/bin/mix --version
              #${elixir}/bin/iex --version
            '';

            LANG = "en_GB.UTF-8";
            ERL_AFLAGS = "-kernel shell_history enabled";
          };
        };
    };
}
