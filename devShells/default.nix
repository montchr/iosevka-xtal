{lib, ...}: {
  perSystem = {
    inputs',
    system,
    pkgs,
    lib,
    ...
  }: let
    inherit (lib) getExe;

    inherit
      (pkgs)
      alejandra
      nvfetcher
      treefmt
      ;
    inherit (pkgs.nodePackages) prettier;

    withCategory = category: attrset: attrset // {inherit category;};
    pkgWithCategory = category: package: {inherit package category;};

    # iosevka-xtal = pkgWithCategory "iosevka-xtal";
    # iosevka-xtal' = withCategory "iosevka-xtal";
    linters = pkgWithCategory "linters";
    formatters = pkgWithCategory "formatters";
    # utils = pkgWithCategory "utils";
    utils' = withCategory "utils";
    secrets = pkgWithCategory "secrets";
    secrets' = withCategory "secrets";
  in {
    devShells.default = inputs'.devshell.legacyPackages.mkShell {
      name = "iosevka-xtal";

      commands = [
        (utils' {
          name = "update-sources";
          command = ''
            cd $PRJ_ROOT/packages
${getExe nvfetcher} -c ./nvfetcher.toml $@
cd -
          '';
        })
        (utils' {
          name = "format";
          command = ''
            treefmt --clear-cache -- "$@"
          '';
        })

        (utils' {
          name = "evalnix";
          help = "Check Nix parsing";
          command = ''
            ${getExe pkgs.fd} --extension nix --exec \
              nix-instantiate --parse --quiet {} >/dev/null
          '';
        })

        (formatters alejandra)
        (formatters prettier)
        (formatters treefmt)
      ];

      packages = [];

      env = [];
    };
  };
}
