# Nix-managed update script for coderabbit-cli.
#
# Usage (from flake root):
#   nix run .#update-coderabbit-cli --impure          # latest version
#   nix run .#update-coderabbit-cli --impure -- 0.6.0  # specific version

{ writeShellApplication, curl, gawk, gnused, nix }:

writeShellApplication {
  name = "update-coderabbit-cli";
  runtimeInputs = [ curl gawk gnused nix ];
  text = ''
    NIX_FILE="./pkgs/coderabbit-cli.nix"

    if [ ! -f "$NIX_FILE" ]; then
      echo "Error: $NIX_FILE not found. Run this from the flake root." >&2
      exit 1
    fi

    BASE_URL="https://cli.coderabbit.ai/releases"

    if [ -n "''${1:-}" ]; then
      VERSION="$1"
    else
      VERSION=$(curl -fsSL "$BASE_URL/latest/VERSION" | tr -d '[:space:]')
    fi

    echo "Updating coderabbit-cli to version $VERSION"
    echo

    declare -A PLATFORMS=(
      ["aarch64-darwin"]="darwin-arm64"
      ["x86_64-darwin"]="darwin-x64"
      ["aarch64-linux"]="linux-arm64"
      ["x86_64-linux"]="linux-x64"
    )

    declare -A HASHES
    for nix_system in "''${!PLATFORMS[@]}"; do
      platform="''${PLATFORMS[$nix_system]}"
      url="$BASE_URL/$VERSION/coderabbit-$platform.zip"
      echo "Fetching hash for $nix_system ($platform)..."

      nix32=$(nix-prefetch-url "$url" 2>/dev/null)
      sri=$(nix hash convert --hash-algo sha256 --to sri "$nix32")
      HASHES[$nix_system]="$sri"
      echo "  $sri"
    done

    echo
    echo "Updating $NIX_FILE ..."

    # Update version
    sed -i "s/version = \".*\"/version = \"$VERSION\"/" "$NIX_FILE"

    # Update per-platform hashes
    for nix_system in "''${!HASHES[@]}"; do
      hash="''${HASHES[$nix_system]}"
      awk -v sys="$nix_system" -v hash="$hash" '
        $0 ~ "\"" sys "\"" { found=1 }
        found && /hash = "/ {
          sub(/hash = "sha256-[^"]*"/, "hash = \"" hash "\"")
          found=0
        }
        { print }
      ' "$NIX_FILE" > "$NIX_FILE.tmp" && mv "$NIX_FILE.tmp" "$NIX_FILE"
    done

    echo "Done! Updated to version $VERSION"
  '';
}
