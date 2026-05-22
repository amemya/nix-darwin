# CodeRabbit CLI - AI-powered code review tool
#
# Downloads the pre-built binary from cli.coderabbit.ai and installs it
# as a Nix package for declarative, reproducible installs.
#
# To update:
#   1. Check the latest version:  curl -fsSL https://cli.coderabbit.ai/releases/latest/VERSION
#   2. Prefetch the new hashes:   nix-prefetch-url "https://cli.coderabbit.ai/releases/<version>/coderabbit-<os>-<arch>.zip"
#   3. Convert to SRI format:     nix hash convert --hash-algo sha256 --to sri <hash>
#   4. Update `version` and the hashes below.

{ lib, stdenv, fetchurl, unzip, autoPatchelfHook }:

let
  version = "0.5.1";

  # Map Nix system identifiers to CodeRabbit's naming convention
  # (matches the URL scheme used by install.sh)
  platformMap = {
    "aarch64-darwin" = {
      os = "darwin";
      arch = "arm64";
      hash = "sha256-y3HFloerlzO9hYl6csiV74culKGmz8DP340klFUo+6I=";
    };
    "x86_64-darwin" = {
      os = "darwin";
      arch = "x64";
      hash = "sha256-fRodzcsf/Aiig1vl8GCy8M2ITmhzBkkmUMCp4IScwFw=";
    };
    "aarch64-linux" = {
      os = "linux";
      arch = "arm64";
      hash = "sha256-RioZvIf3mtbwb58K8YB21Cb3yjmkXbBwUjA76fHHsa4=";
    };
    "x86_64-linux" = {
      os = "linux";
      arch = "x64";
      hash = "sha256-+iuoLgYemQDvoyU9wSMk2tX8MeMAlgndKx7Gk/0nBnI=";
    };
  };

  platform = platformMap.${stdenv.hostPlatform.system}
    or (throw "coderabbit-cli: unsupported platform ${stdenv.hostPlatform.system}");
in

stdenv.mkDerivation {
  pname = "coderabbit-cli";
  inherit version;

  src = fetchurl {
    url = "https://cli.coderabbit.ai/releases/${version}/coderabbit-${platform.os}-${platform.arch}.zip";
    hash = platform.hash;
  };

  # The zip contains a flat binary, no nested directory
  sourceRoot = ".";

  nativeBuildInputs = [ unzip ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  dontConfigure = true;
  dontBuild = true;

  unpackPhase = ''
    runHook preUnpack
    unzip "$src"
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -m 755 coderabbit $out/bin/coderabbit

    # Create 'cr' alias (matches install.sh behavior)
    ln -s coderabbit $out/bin/cr

    runHook postInstall
  '';

  meta = with lib; {
    description = "CodeRabbit CLI - AI-powered code review from the command line";
    homepage = "https://coderabbit.ai";
    license = licenses.unfree;
    platforms = builtins.attrNames platformMap;
    mainProgram = "coderabbit";
  };
}