{
  description = "iosevka-xtal";

  nixConfig.extra-experimental-features = "nix-command flakes";
  nixConfig.extra-substituters = "https://iosevka-xtal.cachix.org https://dotfield.cachix.org https://nix-community.cachix.org";
  nixConfig.extra-trusted-public-keys = "iosevka-xtal.cachix.org-1:5d7Is01fs3imwU9w5dom2PcSskJNwtJGbfjRxunuOcw= dotfield.cachix.org-1:b5H/ucY/9PDARWG9uWA87ZKWUBU+hnfF30amwiXiaNk= nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = {
    self,
    nixpkgs,
    flake-parts,
    ...
  }: (flake-parts.lib.mkFlake {inherit self;} {
    systems = nixpkgs.lib.systems.flakeExposed;
    perSystem = ctx@{system, pkgs, ...}: let
      inherit (pkgs) callPackages recurseIntoAttrs;
    in {
      packages = {
        inherit (recurseIntoAttrs (import ./packages/iosevka-xtal.nix {inherit (pkgs) lib iosevka;})) iosevka-xtal iosevka-xtal-term;
        default = ctx.config.packages.iosevka-xtal;
      };
      formatter = pkgs.alejandra;
    };
  });
}
