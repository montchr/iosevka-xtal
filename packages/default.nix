{self, inputs', ...}: {
  perSystem = ctx@{pkgs,...}:
    let
    inherit (pkgs) callPackages recurseIntoAttrs;
# inherit (inputs'.napalm.legacyPackages) buildPackage;
    in
  {
    packages = {
default = ctx.config.iosevka-xtal;

iosevka-xtal = recurseIntoAttrs (callPackages ./iosevka-xtal.nix {});
      # upstream = (pkgs.callPackage ./generated.nix {}).iosevka;
# iosevka-src = buildPackage ./iosevka-src.nix {inherit (ctx.config.packages) upstream; };
# iosevka = pkgs.callPackage ./iosevka.nix {iosevka-src = ctx.config.iosevka-src;};
    };
  };
}
