# Nix-managed update script for antigravity-cli.
#
# Usage (from flake root):
#   nix run .#update-antigravity-cli

{ writeShellApplication, curl, jq, gawk, gnused, nix }:

writeShellApplication {
  name = "update-antigravity-cli";
  runtimeInputs = [ curl jq gawk gnused nix ];
  text = ''
    NIX_FILE="./pkgs/antigravity-cli.nix"

    if [ ! -f "$NIX_FILE" ]; then
      echo "Error: $NIX_FILE not found. Run this from the flake root." >&2
      exit 1
    fi

    OLD_VERSION=$(sed -n 's/^[[:space:]]*version = "\([^"]*\)";/\1/p' "$NIX_FILE" | head -n 1)
    BASE_URL="https://antigravity-cli-auto-updater-974169037036.us-central1.run.app/manifests"

    declare -A PLATFORMS=(
      ["aarch64-darwin"]="darwin_arm64"
      ["x86_64-darwin"]="darwin_amd64"
      ["aarch64-linux"]="linux_arm64"
      ["x86_64-linux"]="linux_amd64"
    )

    declare -A URLS
    declare -A HASHES
    NEW_VERSION=""

    for nix_system in "''${!PLATFORMS[@]}"; do
      platform="''${PLATFORMS[$nix_system]}"
      echo "Fetching manifest for $nix_system ($platform)..."

      manifest=$(curl -fsSL "$BASE_URL/$platform.json")
      version=$(jq -r '.version' <<< "$manifest")
      url=$(jq -r '.url' <<< "$manifest")
      sha512_hex=$(jq -r '.sha512' <<< "$manifest")

      if [ -z "$version" ] || [ "$version" = "null" ] || [ -z "$url" ] || [ "$url" = "null" ] || [ -z "$sha512_hex" ] || [ "$sha512_hex" = "null" ]; then
        echo "Error: malformed manifest for $platform" >&2
        exit 1
      fi

      if [ -z "$NEW_VERSION" ]; then
        NEW_VERSION="$version"
      elif [ "$NEW_VERSION" != "$version" ]; then
        echo "Error: version mismatch across platforms ($NEW_VERSION vs $version)" >&2
        exit 1
      fi

      sri=$(nix hash convert --hash-algo sha512 --to sri "$sha512_hex")
      URLS[$nix_system]="$url"
      HASHES[$nix_system]="$sri"
      echo "  version: $version"
      echo "  hash:    $sri"
    done

    echo
    echo "Updating $NIX_FILE ($OLD_VERSION -> $NEW_VERSION)..."

    sed -i "s/^  version = \".*\";/  version = \"$NEW_VERSION\";/" "$NIX_FILE"

    for nix_system in "''${!PLATFORMS[@]}"; do
      url="''${URLS[$nix_system]}"
      hash="''${HASHES[$nix_system]}"
      awk -v sys="$nix_system" -v url="$url" -v hash="$hash" '
        $0 ~ "\"" sys "\"" { found=1 }
        found && /url = "/ {
          sub(/url = "[^"]*"/, "url = \"" url "\"")
        }
        found && /hash = "/ {
          sub(/hash = "[^"]*"/, "hash = \"" hash "\"")
        }
        found && /^[[:space:]]*\};/ { found=0 }
        { print }
      ' "$NIX_FILE" > "$NIX_FILE.tmp" && mv "$NIX_FILE.tmp" "$NIX_FILE"
    done

    echo "Done! Updated antigravity-cli: $OLD_VERSION -> $NEW_VERSION"
  '';
}
