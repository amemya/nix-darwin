# Google Antigravity CLI - AI agent in the terminal
#
# Downloads the pre-built binary from antigravity.google's release bucket and
# installs it as a Nix package for declarative, reproducible installs.
#
# To update:
#   nix run .#update-antigravity-cli

{ lib, stdenv, fetchurl, makeBinaryWrapper, autoPatchelfHook }:

let
  version = "1.5.15";

  # Map Nix system identifiers to Antigravity CLI release artifacts
  # (each release URL includes a build ID, so full URLs are tracked per platform)
  platformMap = {
    "aarch64-darwin" = {
      url = "https://storage.googleapis.com/antigravity-public/antigravity-cli/1.5.15-5514532022517760/darwin-arm/cli_mac_arm64.tar.gz";
      hash = "sha512-sDqEHrOim+kYpmlgt3X2jtTzvMAvM5YhMbu8JsRuqYPOrGyDKtRu/RHXPZosuX30qyTUvJLuR9PV7Oe42LYSNQ==";
    };
    "x86_64-darwin" = {
      url = "https://storage.googleapis.com/antigravity-public/antigravity-cli/1.5.15-5514532022517760/darwin-x64/cli_mac_x64.tar.gz";
      hash = "sha512-Inbg8YmpF+fqpLAOzln+ahBikURy4TJH9AK1b+JsmvrNCvSUR24xpWEPsLJzQAykAT8nPVbWnG/dfi0OyTP1lg==";
    };
    "aarch64-linux" = {
      url = "https://storage.googleapis.com/antigravity-public/antigravity-cli/1.5.15-5514532022517760/linux-arm/cli_linux_arm64.tar.gz";
      hash = "sha512-1krXWXgbUN+s+n2YJsCtRplZ0BvfWhcKzUyDRy66McZ3uvAFKsirSO70Dw0/DiYFfnUqq9JDMcefTIgdS4chJQ==";
    };
    "x86_64-linux" = {
      url = "https://storage.googleapis.com/antigravity-public/antigravity-cli/1.5.15-5514532022517760/linux-x64/cli_linux_x64.tar.gz";
      hash = "sha512-rz8L5YuEdZQNefmr6hnnYuzD0mXqn1bP+N2AXie6KZtEowWnlQSn/+br36KaKUxW7cTK7Rh1mQv68v7xUI7IsA==";
    };
  };

  platform = platformMap.${stdenv.hostPlatform.system}
    or (throw "antigravity-cli: unsupported platform ${stdenv.hostPlatform.system}");
in

stdenv.mkDerivation {
  pname = "antigravity-cli";
  inherit version;

  src = fetchurl {
    inherit (platform) url hash;
  };

  sourceRoot = ".";

  nativeBuildInputs = [ makeBinaryWrapper ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  dontConfigure = true;
  dontBuild = true;
  dontStrip = true;

  unpackPhase = ''
    runHook preUnpack
    tar -xzf "$src" antigravity
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 antigravity $out/libexec/antigravity-cli/agy
    makeWrapper $out/libexec/antigravity-cli/agy $out/bin/agy \
      --set AGY_CLI_DISABLE_AUTO_UPDATE 1

    runHook postInstall
  '';

  meta = with lib; {
    description = "Google Antigravity CLI - AI agent in the terminal";
    homepage = "https://antigravity.google";
    license = licenses.unfree;
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
    platforms = builtins.attrNames platformMap;
    mainProgram = "agy";
  };
}
