# source: https://github.com/NixOS/nixpkgs/issues/493775#issuecomment-3969526444
final: prev: {
  yt-dlp = prev.yt-dlp.overridePythonAttrs (oldAttrs: {
    # don't use gnome keyring
    dependencies = (
      __filter (
        prev:
        !(__elem prev.pname [
          "cffi"
          "secretstorage"
        ])
      ) oldAttrs.dependencies
    );
  });
}
