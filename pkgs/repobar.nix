# RepoBar - GitHub repo status in your menu bar
#
# macOS menu bar app that shows CI, Issues, PRs, and Latest Release
# status for your GitHub repositories.
#
# Distributed as a Universal Binary (x86_64 + arm64).
# Source: https://github.com/steipete/RepoBar
#
# To update:
#   1. Check the latest release: https://github.com/steipete/RepoBar/releases
#   2. nix-prefetch-url "https://github.com/steipete/RepoBar/releases/download/v<version>/RepoBar-<version>.zip"
#   3. nix hash convert --hash-algo sha256 --to sri <hash>
#   4. Update `version` and `hash` below.

{ lib, stdenvNoCC, fetchurl, unzip, _7zz }:

stdenvNoCC.mkDerivation rec {
  pname = "repobar";
  version = "0.6.2";

  src = fetchurl {
    url = "https://github.com/steipete/RepoBar/releases/download/v${version}/RepoBar-${version}.zip";
    hash = "sha256-Y5e6HK8nSpXOTiA0vUMSrhUp62rNGE2e5UNtXC9NTo0=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ unzip ];

  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;  # Don't strip/patch macOS .app bundles

  unpackPhase = ''
    runHook preUnpack
    unzip -q "$src"
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications"
    cp -R RepoBar.app "$out/Applications/"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Show status of GitHub Repos in your menu bar: CI, Issues, PRs, Latest Release";
    homepage = "https://github.com/steipete/RepoBar";
    license = licenses.unfree;
    platforms = [ "aarch64-darwin" "x86_64-darwin" ];
    mainProgram = "RepoBar";
  };
}
