{ pkgs, ... }: {
  enable = true;
  settings = {
    theme = "onelight";
    editor = {
      bufferline = "multiple";
      color-modes = true;
      line-number = "relative";
      lsp.display-messages = true;
    };
    keys.normal = {
      space.w = ":w";
      space.q = ":q";
      space.x = ":x";
    };
  };
  languages.language = [{
    name = "elixir";
    auto-format = true;
  }];
}
