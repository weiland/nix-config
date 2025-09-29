final: prev:
let
  version = "1.2.23";
in
{
  bun = prev.bun.overrideAttrs (oldAttrs: {
    inherit version;
    src = prev.fetchurl {
      url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-darwin-aarch64.zip";
      hash = "sha256-IvX6P/9ysNO45+D4BR7K3y5Bkg1HSsYttSeRRICckAU=";
    };
  });
}
