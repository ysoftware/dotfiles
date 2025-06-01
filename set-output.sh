switch_audio_output() {
    sleep 1

    local sink_type=$1
    sink_id=$(pactl list short sinks | grep -i "$sink_type" | awk '{print $1}')

    if [ -n "$sink_id" ]; then
        pactl set-default-sink "$sink_id"
    fi
}

set_workspace_desk() {
    gnome-monitor-config set -LM DP-2 -m 1920x1080@60.000 -LpM HDMI-1 -m 2560x1440@143.912 -x 1920 -y 500
    switch_audio_output "direct"
}

set_workspace_sofa() {
    gnome-monitor-config set -LpM HDMI-2 -m 4096x2160@119.880 -s 2
    switch_audio_output "hdmi"
}

set_workspace_all() {
    gnome-monitor-config set -LM DP-2 -m 1920x1080@60.000 -LpM HDMI-1 -m 2560x1440@143.912 -x 1920 -y 500 -LM HDMI-2 -m 4096x2160@119.880 -x 4480 -y 200 -s2
    switch_audio_output "hdmi"
}

# call function by name
$1
