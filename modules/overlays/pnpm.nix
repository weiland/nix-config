final: prev: {
  pnpm = prev.pnpm.overrideAttrs (oldAttrs: rec {
    version = "10.15.0";
    src = prev.fetchurl {
      url = "https://registry.npmjs.org/pnpm/-/pnpm-${version}.tgz";
      hash = "sha256-hMGeeI19fuJI5Ka3FS+Ou6D0/nOApfRDyhfXbAMAUtI=";
    };
  });
}
