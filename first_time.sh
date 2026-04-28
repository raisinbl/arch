#!/bin/bash

set -e
current_dir=$(dirname $(realpath $0))

# Logs and tracking files
log_file="/tmp/arch_install_$(date +%s).log"
failed_official_packages="/tmp/failed_official_packages.txt"
failed_aur_packages="/tmp/failed_aur_packages.txt"

echo "=== Arch Linux Package Installation ===" | tee "$log_file"
echo "Log file: $log_file" | tee -a "$log_file"
echo ""

# === STEP 1: Update package database ===
echo "[1/4] Updating package database..." | tee -a "$log_file"
sudo pacman -Syu 2>&1 | tee -a "$log_file"

# === STEP 2: Install official packages with error handling ===
echo "[2/4] Installing official packages..." | tee -a "$log_file"
> "$failed_official_packages"

while IFS= read -r pkg; do
	# Skip empty lines and comments
	[[ -z "$pkg" || "$pkg" =~ ^# ]] && continue
	
	if sudo pacman -S --needed --noconfirm "$pkg" 2>&1 | tee -a "$log_file"; then
		echo "✓ $pkg" | tee -a "$log_file"
	else
		echo "✗ $pkg (failed, marking for review)" | tee -a "$log_file"
		echo "$pkg" >> "$failed_official_packages"
	fi
done < "$current_dir/pkg/pkglist.txt"

# Show failed official packages summary
if [ -s "$failed_official_packages" ]; then
	echo "" | tee -a "$log_file"
	echo "⚠ Failed official packages:" | tee -a "$log_file"
	cat "$failed_official_packages" | tee -a "$log_file"
	echo "Tip: These may be outdated or removed. Consider updating pkglist.txt." | tee -a "$log_file"
	echo ""
fi

# === STEP 3: Install paru (AUR helper) ===
echo "[3/4] Checking paru (AUR helper)..." | tee -a "$log_file"
if [ -x "$(command -v paru)" ]; then
	echo "✓ paru is already installed" | tee -a "$log_file"
else
	echo "Installing paru from AUR..." | tee -a "$log_file"
	tmp_dir=/tmp/paru-bin
	rm -rf "$tmp_dir" 2>/dev/null || true
	
	if git clone https://aur.archlinux.org/paru-bin.git "$tmp_dir" 2>&1 | tee -a "$log_file"; then
		if (cd "$tmp_dir" && makepkg -si --needed --noconfirm) 2>&1 | tee -a "$log_file"; then
			echo "✓ paru installed successfully" | tee -a "$log_file"
		else
			echo "✗ Failed to build paru. You may need to install it manually." | tee -a "$log_file"
			exit 1
		fi
	else
		echo "✗ Failed to clone paru repository" | tee -a "$log_file"
		exit 1
	fi
	rm -rf "$tmp_dir"
fi

# === STEP 4: Install AUR packages with error handling ===
echo "[4/4] Installing AUR packages..." | tee -a "$log_file"
> "$failed_aur_packages"

while IFS= read -r pkg; do
	# Skip empty lines and comments
	[[ -z "$pkg" || "$pkg" =~ ^# ]] && continue
	
	if paru -S --needed --noconfirm "$pkg" 2>&1 | tee -a "$log_file"; then
		echo "✓ $pkg" | tee -a "$log_file"
	else
		echo "✗ $pkg (AUR package failed, marking for review)" | tee -a "$log_file"
		echo "$pkg" >> "$failed_aur_packages"
	fi
done < "$current_dir/pkg/pkglist_aur.txt"

# === FINAL SUMMARY ===
echo "" | tee -a "$log_file"
echo "=== Installation Summary ===" | tee -a "$log_file"

failed_official_count=$(wc -l < "$failed_official_packages" 2>/dev/null || echo "0")
failed_aur_count=$(wc -l < "$failed_aur_packages" 2>/dev/null || echo "0")

echo "Failed official packages: $failed_official_count" | tee -a "$log_file"
echo "Failed AUR packages: $failed_aur_count" | tee -a "$log_file"

if [ "$failed_official_count" -eq 0 ] && [ "$failed_aur_count" -eq 0 ]; then
	echo "✓ All packages installed successfully!" | tee -a "$log_file"
else
	echo "" | tee -a "$log_file"
	echo "⚠ Some packages failed. Options:" | tee -a "$log_file"
	echo "1. Review failed packages in summary above" | tee -a "$log_file"
	echo "2. Update pkglist.txt with: ./pkg/get_pkg.sh" | tee -a "$log_file"
	echo "3. Manually fix/remove packages and re-run this script" | tee -a "$log_file"
	echo "4. Check AUR status: https://aur.archlinux.org/packages/" | tee -a "$log_file"
fi

echo "" | tee -a "$log_file"
echo "Full log saved to: $log_file" | tee -a "$log_file"
