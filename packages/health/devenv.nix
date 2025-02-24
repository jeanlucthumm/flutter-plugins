{pkgs, ...}: {
  packages = with pkgs; [
    nushell
    sourcekit-lsp
    lldb
    swiftformat
  ];

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
