# CodeRabbit CLI - AI-powered code review tool
#
# Downloads the pre-built binary from cli.coderabbit.ai and installs it
# as a Nix package for declarative, reproducible installs.
#
# To update:
#   nix run .#update-coderabbit-cli              # latest version
#   nix run .#update-coderabbit-cli -- 0.6.0     # specific version

{ lib, stdenv, fetchurl, unzip, autoPatchelfHook }:

let
  version = "0.9.6";

  # Map Nix system identifiers to CodeRabbit's naming convention
  # (matches the URL scheme used by install.sh)
  platformMap = {
    "aarch64-darwin" = {
      os = "darwin";
      arch = "arm64";
      hash = "sha256-XmRgk7iWhTI0G+SRjjRGdbT6deAbojAsx9rSJS7tGOA=";
    };
    "x86_64-darwin" = {
      os = "darwin";
      arch = "x64";
      hash = "sha256-3UuCMgFFvtOhul+E/zJ2fK0zxWUisex7YjjFfkAGBs0=";
    };
    "aarch64-linux" = {
      os = "linux";
      arch = "arm64";
      hash = "sha256-OeelKnuIeYBRwIMwGcnP5I4DemXNu+mcW3paqpEqFE4=";
    };
    "x86_64-linux" = {
      os = "linux";
      arch = "x64";
      hash = "sha256-7BVPV19XzW3TAJk4B3Im87gyoGBq1OdOJKgVJ2LWQko=";
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
