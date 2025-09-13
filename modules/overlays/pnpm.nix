final: prev: {
  pnpm = prev.pnpm.overrideAttrs (oldAttrs: rec {
    version = "10.16.0";
    src = prev.fetchurl {
      url = "https://registry.npmjs.org/pnpm/-/pnpm-${version}.tgz";
      hash = "sha256-3WLTjfGmcCyTD7oUuSvDyj1cJKbHAFsuU1Wpi4mPpdQ=";
    };
  });
}
