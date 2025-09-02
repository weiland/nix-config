final: prev: {
  pnpm = prev.pnpm.overrideAttrs (oldAttrs: rec {
    version = "10.15.1";
    src = prev.fetchurl {
      url = "https://registry.npmjs.org/pnpm/-/pnpm-${version}.tgz";
      hash = "sha256-jFOvAq4+wfsK51N3+NTWIXwtfL5vA8FjUMq/dJPebv8=";
    };
  });
}
