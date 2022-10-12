{
  lib,
  iosevka,
}: let
  makeFam = set: family: {
    spacing ? "normal",
    withItalic ? true,
    withOblique ? false,
    weights ? ["light" "regular" "medium" "semibold" "bold" "heavy"],
  }: (iosevka.override {
    inherit set;

  });
in makeFam
