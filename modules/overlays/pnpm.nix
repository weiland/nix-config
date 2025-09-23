final: prev: {
  pnpm = prev.pnpm.overrideAttrs (oldAttrs: rec {
    version = "10.17.1";
    src = prev.fetchurl {
      url = "https://registry.npmjs.org/pnpm/-/pnpm-${version}.tgz";
      hash = "sha256-oeATP2gBwTA5rkEwnl5afRBYo6Hh7dAgpJRKg8U2jQQ=";
    };
  });
}
