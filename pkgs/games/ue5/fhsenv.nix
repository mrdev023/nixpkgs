{ buildFHSEnvBubblewrap, ... }:

buildFHSEnvBubblewrap {
  name = "build-ue5";

  targetPkgs = pkgs: with pkgs; [
    which
    dotnetCorePackages.dotnet_8.sdk
    pkg-config
    mono
    git
    python3Full
    vulkan-tools
    openssl
    xdg-user-dirs
  ];

  runScript = "
    cat /etc/os-release
    ./Setup.sh
    ./GenerateProjectFiles.sh
    make
  ";
}
