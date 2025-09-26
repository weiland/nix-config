final: prev: {
  # this worked (using the same package as nixpkgs do)
  # takes a long time (like using the GitHub code)
  nodejs_24 = prev.nodejs_24.overrideAttrs (oldAttrs: rec {
    version = "24.9.0";
    src = prev.fetchurl {
      url = "https://nodejs.org/dist/v${version}/node-v${version}.tar.xz";
      hash = "sha256-8XvEywH1kJjDSiiMG7EJp3iGfBTusOu9YI0GF7EZO78=";
    };
  });
}
