#!/bin/bash

# call xrandr to see these variables or just guess them
PRIMARY="DP-5"
SECONDARY="HDMI-4"
TV="HDMI-5"

switch_audio_output() {
    sleep 1
    local sink_type=$1
    sink_id=$(pactl list short sinks | grep -i "$sink_type" | awk '{print $1}')
    if [ -n "$sink_id" ]; then
        pactl set-default-sink "$sink_id"
    fi
}

set_workspace_desk() {
    gnome-monitor-config set -LM "$PRIMARY" -m 1920x1080@60.000 -LpM "$SECONDARY" -m 2560x1440@143.912 -x 1920 -y 163
    switch_audio_output "direct"
}

set_workspace_sofa() {
    gnome-monitor-config set -LpM "$TV" -m 4096x2160@119.880 -s 2
    switch_audio_output "hdmi"
}

set_workspace_all() {
    gnome-monitor-config set -LM "$PRIMARY" -m 1920x1080@60.000 -LpM "$SECONDARY" -m 2560x1440@143.912 -x 1920 -y 0 -LM "$TV" -m 4096x2160@119.880 -x 4480 -y 163 -s 2
    switch_audio_output "hdmi"
}

$1
