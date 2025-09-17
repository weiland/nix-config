final: prev: {
  pnpm = prev.pnpm.overrideAttrs (oldAttrs: rec {
    version = "10.17.0";
    src = prev.fetchurl {
      url = "https://registry.npmjs.org/pnpm/-/pnpm-${version}.tgz";
      hash = "sha256-vZ7FQXZBOR4KyzkSspEr1bA4VAeoLalHRKdAe1Z/208=";
    };
  });
}
