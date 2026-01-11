{
  lib,
  pkgs,
  stdenv,
  fetchurl,
  buildPackages,
  installShellFiles,
  testers,
}:
let
  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "k0s is not available for ${system}.";

  plat =
    {
      aarch64-linux = "arm64";
      armv7l-linux = "arm";
      x86_64-linux = "amd64";
    }
    .${system} or throwSystem;

  hash =
    {
      aarch64-linux = "sha256-oGcoUY4Bq32YatT/8cYIrH5I2nLhM+iipjgRWvZUgnc=";
      armv7l-linux = "sha256-ou0f7BrxJnjvoAdAa8vggfDm6lJOXBgREC5Ndp1oxeA=";
      x86_64-linux = "sha256-qSRR48h22ddttCtyK8w6DFuHXyNT/lQBuOJQGNppuDg=";
    }
    .${system} or throwSystem;

  version = "1.34.3+k0s.0";
in
stdenv.mkDerivation {
  pname = "k0s";
  inherit version;

  src = fetchurl {
    url = "https://github.com/k0sproject/k0s/releases/download/v${version}/k0s-v${version}-${plat}";
    hash = hash;
  };

  dontUnpack = true;

  nativeBuildInputs = [ installShellFiles ];

  installPhase =
    let
      k0s =
        if stdenv.buildPlatform.canExecute stdenv.hostPlatform then
          placeholder "out"
        else
          buildPackages.k0s;
    in
    ''
      install -m 755 -D -- "$src" "$out"/bin/k0s

      # Generate shell completions
      installShellCompletion --cmd k0s \
        --bash <(${k0s}/bin/k0s completion bash) \
        --fish <(${k0s}/bin/k0s completion fish) \
        --zsh <(${k0s}/bin/k0s completion zsh)
    '';

  passthru.tests.version = testers.testVersion {
    package = pkgs.k0s;
    command = "k0s version";
    version = "v${version}";
  };

  meta = {
    description = "k0s - The Zero Friction Kubernetes";
    homepage = "https://github.com/k0sproject/k0s";
    license = lib.licenses.asl20;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [
      mrdev023
      twz123
    ];
    mainProgram = "k0s";
    platforms = [
      "aarch64-linux"
      "armv7l-linux"
      "x86_64-linux"
    ];
  };
}
