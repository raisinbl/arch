#!/bin/bash

# Validate packages and suggest fixes
# Run this to check which packages are available before full installation

script_dir=$(dirname "$(realpath $0)")

echo "=== Package Validation ===" 
echo ""

# Validate official packages
echo "[1/2] Checking official packages..."
echo "Packages that don't exist in repos (will be skipped):"
invalid_official=0

while IFS= read -r pkg; do
	[[ -z "$pkg" || "$pkg" =~ ^# ]] && continue
	
	if ! pacman -Si "$pkg" &>/dev/null; then
		echo "  ✗ $pkg"
		((invalid_official++))
	fi
done < "$script_dir/pkglist.txt"

if [ $invalid_official -eq 0 ]; then
	echo "  ✓ All official packages are valid"
fi

echo ""

# Validate AUR packages
echo "[2/2] Checking AUR packages..."
echo "Note: This requires internet and paru/yay installed"
echo "Packages that don't exist in AUR (will be skipped):"
invalid_aur=0

if command -v paru &>/dev/null; then
	while IFS= read -r pkg; do
		[[ -z "$pkg" || "$pkg" =~ ^# ]] && continue
		
		if ! paru -Si "$pkg" &>/dev/null; then
			echo "  ✗ $pkg (not found in AUR)"
			((invalid_aur++))
		fi
	done < "$script_dir/pkglist_aur.txt"
	
	if [ $invalid_aur -eq 0 ]; then
		echo "  ✓ All AUR packages are valid"
	fi
else
	echo "  (skipping AUR validation - paru not installed)"
fi

echo ""
echo "Summary: $invalid_official invalid official, $invalid_aur invalid AUR"
echo ""
echo "To fix invalid packages:"
echo "1. Remove them from pkglist.txt or pkglist_aur.txt"
echo "2. Or regenerate from current system: ./get_pkg.sh"
