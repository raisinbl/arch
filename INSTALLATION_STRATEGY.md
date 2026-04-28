# Installation Error Handling Strategy

## Problem
When you don't use this setup for a while, AUR packages may become:
- **Out of date** - depends on deprecated dependencies
- **Deprecated** - replaced by newer packages
- **Removed** - no longer maintained or available
- **Broken** - build failures due to missing deps

## Solution Strategy

### 1. **Before Installation - Validate Packages**
Run this to check which packages are problematic:
```bash
./pkg/validate_packages.sh
```
This identifies invalid packages without attempting install.

### 2. **During Installation - Graceful Failure**
The improved `first_time.sh`:
- Installs each package **individually** (not as batch)
- **Skips failed packages** instead of stopping entire process
- Logs all failures to `/tmp/failed_*.txt`
- Shows clear summary of what succeeded/failed

### 3. **After Installation - Fix Failures**
If packages fail, you have options:

**Option A: Update the package lists**
```bash
# Regenerate from current working system
./pkg/get_pkg.sh

# This creates fresh lists with only installed/available packages
# Then commit the updated lists to repo
git add pkg/pkglist.txt pkg/pkglist_aur.txt
git commit -m "update: refresh package lists"
```

**Option B: Remove problematic packages manually**
Edit `pkg/pkglist_aur.txt` and remove packages that no longer exist.

**Option C: Find replacements**
- Check AUR status: https://aur.archlinux.org/packages/
- Search for alternative packages
- Update the lists with replacements

### 4. **Key Improvements in New Script**

| Feature | Benefit |
|---------|---------|
| **Per-package error handling** | One failure doesn't block others |
| **Detailed logging** | Trace exactly what failed and why |
| **Failed package tracking** | Easy to see what needs fixing |
| **Clear summary** | Know status at a glance |
| **Paru cleanup** | Removes old paru build before rebuilding |
| **Comment support** | Add `# outdated` notes in pkglist.txt |

### 5. **Best Practices**

- **Keep pkglist.txt updated**: After setting up on current system, run `./pkg/get_pkg.sh` to capture working state
- **Commit updated lists**: Make this a regular commit in your arch repo so others (and future you) have fresh lists
- **Use comments**: Add `# package-name - reason for inclusion` to track why packages are needed
- **Test validation**: Run `validate_packages.sh` before full install on new device

## Example Workflow on New Device

```bash
# 1. Clone arch repo
git clone https://github.com/raisinbl/arch.git ~/arch
cd ~/arch

# 2. (Optional) Validate packages first - see what might fail
./pkg/validate_packages.sh

# 3. Run installation - will skip problematic packages
./first_time.sh

# 4. Check results - see what failed
cat /tmp/failed_aur_packages.txt
cat /tmp/failed_official_packages.txt

# 5. Fix as needed - either:
#    - Remove them from lists and re-run
#    - Install manually later
#    - Find replacements and commit new lists
```

## Logging

All installations are logged to:
- `/tmp/arch_install_<timestamp>.log` - Full detailed log
- `/tmp/failed_official_packages.txt` - Official packages that failed
- `/tmp/failed_aur_packages.txt` - AUR packages that failed

Check these files to debug specific failures.
