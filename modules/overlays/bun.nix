final: prev:
let
  version = "1.2.21";
in
{
  bun = prev.bun.overrideAttrs (oldAttrs: {
    inherit version;
    src = prev.fetchurl {
      url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-darwin-aarch64.zip";
      hash = "sha256-/YhmMLoVxIQjatXz8islXSh8Pu+NO8JvyAmFEDXATOw=";
    };
  });
}
