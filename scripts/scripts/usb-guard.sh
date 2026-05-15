#!/usr/bin/env bash

SINK="${1:-alsa_output.pci-0000_01_00.1.hdmi-stereo}"  # override: pactl list sinks short
#SINK="${1:-bluez_output.94_DB_56_02_68_87.1}"  # override: pactl list sinks short
VOLUME=100       # percent, 0–100
ALARM_DURATION=30

alarm() {
    local name="$1"
    printf '\n!!! USB DEVICE REMOVED: %s — SOUNDING ALARM !!!\n\n' "$name"

    local paplay_args=(--volume=$((VOLUME * 65536 / 100)))
    [[ -n "$SINK" ]] && paplay_args+=(--device="$SINK")

    local lo=/tmp/alarm-lo.wav hi=/tmp/alarm-hi.wav
    ffmpeg -f lavfi -i "sine=frequency=880:duration=0.3"  "$lo" -y 2>/dev/null
    ffmpeg -f lavfi -i "sine=frequency=1320:duration=0.3" "$hi" -y 2>/dev/null

    local end=$((SECONDS + ALARM_DURATION))
    while [[ $SECONDS -lt $end ]]; do
        paplay "${paplay_args[@]}" "$lo"
        paplay "${paplay_args[@]}" "$hi"
    done

    rm -f "$lo" "$hi"
}

echo "USB guardian active — alarming on ANY device removal."
echo "Press Ctrl+C to disarm."
echo ""

action="" devtype="" product="" devname=""

udevadm monitor --udev --property --subsystem-match=usb | \
while IFS= read -r line; do
    case "$line" in
        ACTION=*)  action="${line#ACTION=}" ;;
        DEVTYPE=*) devtype="${line#DEVTYPE=}" ;;
        PRODUCT=*) product="${line#PRODUCT=}" ;;
        DEVNAME=*) devname="${line#DEVNAME=}" ;;
        "")
            if [[ "$action" == "remove" && "$devtype" == "usb_device" ]]; then
                label="${devname:-${product}}"
                alarm "$label" &
            fi
            action=""; devtype=""; product=""; devname=""
            ;;
    esac
done
