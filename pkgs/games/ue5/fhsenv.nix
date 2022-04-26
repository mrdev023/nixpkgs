{ callPackage, ... }:

(callPackage ./fhs {} {
  name = "build-ue5";

  targetPkgs = pkgs: with pkgs; [
    which
    dotnetCorePackages.dotnet_8.sdk
    pkg-config
    mono
    git
    python2
    vulkan-tools
    openssl
    xdg-user-dirs
  ];

  osReleaseFile = ./os-release;

  runScript = "
    cat /etc/os-release
    ./Setup.sh
    ./GenerateProjectFiles.sh
    make
  ";
})
