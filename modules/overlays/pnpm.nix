final: prev: {
  pnpm = prev.pnpm.overrideAttrs (oldAttrs: rec {
    version = "10.18.0";
    src = prev.fetchurl {
      url = "https://registry.npmjs.org/pnpm/-/pnpm-${version}.tgz";
      hash = "sha256-OWej7+KQnfMF/sS4M6ME38oXw4C2u3dnL02sTyzdN4g=";
    };
  });
}
