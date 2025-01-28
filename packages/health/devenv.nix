{pkgs, ...}: {
  packages = with pkgs; [nushell sourcekit-lsp];

  languages = {
    swift.enable = true;
  };

  android = {
    enable = true;
    flutter.enable = true;
  };

  enterShell = ''
    nu
  '';
}
