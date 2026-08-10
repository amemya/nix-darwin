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
  version = "0.6.5";

  # Map Nix system identifiers to CodeRabbit's naming convention
  # (matches the URL scheme used by install.sh)
  platformMap = {
    "aarch64-darwin" = {
      os = "darwin";
      arch = "arm64";
      hash = "sha256-V1MNVXym919ItsJkoQ2BabUjNL6ZHEhb4kApVL22zsw=";
    };
    "x86_64-darwin" = {
      os = "darwin";
      arch = "x64";
      hash = "sha256-/y3hqI/tcrS+qYyAaoHGfpq/0dDMYkRdw19KlF9uVuo=";
    };
    "aarch64-linux" = {
      os = "linux";
      arch = "arm64";
      hash = "sha256-8FYSDvih62Qc+5tAu9NtrSg180Gh3KCep3Z6lMHoMJs=";
    };
    "x86_64-linux" = {
      os = "linux";
      arch = "x64";
      hash = "sha256-goDc+CKNCHt4++iVW4xe8/g/c/1G2aAJRTlIVH0wSpk=";
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
