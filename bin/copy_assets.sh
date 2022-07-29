#!/bin/sh

set -eu

REPO_DIR="$(cd `dirname $0` && pwd)/.."

cd "$REPO_DIR"

if ! mountpoint "$REPO_DIR/sd_card"; then
    echo "Error: $REPO_DIR/sd_card is not mounted"
    echo ""
    echo " 1) Install any firmware onto the Flipper at least once"
    echo " 2) Unmount the SD card in the Flipper"
    echo "    Settings > Storage > Unmount SD Card"
    echo " 3) Insert the SD card into a reader in this computer"
    echo " 4) Mount the SD card to $REPO_DIR/sd_card"
    echo "    e.g. mount -t vfat -o rw,umask=000 /dev/sda1 $REPO_DIR/sd_card"
    echo " 5) Run this script again"
    exit 1
fi

mkdir -pv sd_backup

tar cvfz "sd_backup/flipper-sd-backup-$(date +%Y-%m-%d).tgz" sd_card

# ELF applications
# SDK may not be stable - delete any existing Flipper apps
mkdir -pv sd_card/apps

rm -f sd_card/apps/*.fap

rsync -rv firmware/assets/resources/apps/*.fap sd_card/apps/.

# BadUSB

mkdir -pv sd_card/badusb

rsync -rv firmware/assets/resources/badusb/* sd_card/badusb/.
rsync -rv assets/playground/BadUSB/* sd_card/badusb/. \
    --exclude *.md
rsync -rv assets/badusb/Payloads/* sd_card/badusb/.

# Dolphin picures?

mkdir -pv sd_card/dolphin

rsync -rv firmware/assets/resources/dolphin/* sd_card/dolphin/.
rsync -rv assets/playground/Graphics/manifest.txt sd_card/dolphin/.

# Infrared

mkdir -pv sd_card/infrared

rsync -rv firmware/assets/resources/infrared/* sd_card/infrared/.
rsync -rv assets/infrared/* sd_card/infrared/. \
    --exclude README.md \
    --exclude _CSV-IRDB_ \
    --exclude _Pronto_Converted_

# Music Player

mkdir -pv sd_card/music_player

rsync -rv firmware/assets/resources/music_player/* sd_card/music_player/.
rsync -rv assets/music_player/* sd_card/music_player/. \
    --exclude README.md \
    --exclude *.zip

# NFC

mkdir -pv sd_card/nfc/amiibo

rsync -rv firmware/assets/resources/nfc/* sd_card/nfc/.
rsync -rv assets/nfc/amiibo/* sd_card/nfc/amiibo/. \
    --exclude *.md
rsync -rv assets/playground/NFC/* sd_card/nfc/. \
    --exclude *.md \
    --exclude Amiibo \
    --exclude HID_iClass \
    --exclude mf_classic_dict

# PicoPass

mkdir -pv sd_card/picopass

rsync -rv assets/playground/picopass/* sd_card/picopass/. \
    --exclude *.md

# Sub-GHz

mkdir -pv sd_card/subghz

for bak_file in touchtunes_map.txt universal_rf_map.txt; do
    if [ -e sd_card/subghz/assets/$bak_file ]; then
        mv sd_card/subghz/assets/$bak_file sd_card/subghz/assets/$bak_file.bak
    fi
done

rsync -rv firmware/assets/resources/subghz/* sd_card/subghz/.
rsync -rv assets/playground/Sub-GHz/* sd_card/subghz/. \
    --exclude *.md \
    --exclude *.png \
    --exclude Settings \
    --exclude TouchTunes/*.md \
    --exclude TouchTunes/touchtunes_map

rsync assets/playground/Sub-GHz/Settings/setting_user sd_card/subghz/assets/.

#sed -e 's/add_standard_frequencies: false/add_standard_frequencies: true/' \
#    -e's/ignore_default_tx_region: false/ignore_default_tx_region: true/' \
#    sd_card/subghz/assets/setting_user | tee sd_card/subghz/assets/setting_user

for bak_file in touchtunes_map.txt universal_rf_map.txt; do
    if [ -e sd_card/subghz/assets/$bak_file.bak ]; then
        mv sd_card/subghz/assets/$bak_file.bak sd_card/subghz/assets/$bak_file
    fi
done

# WAV player

mkdir -pv sd_card/wav_player

rsync -rv firmware/assets/resources/wav_player/* sd_card/wav_player/.
rsync -rv assets/playground/Wav_Player/* sd_card/wav_player/. \
    --exclude *.md
