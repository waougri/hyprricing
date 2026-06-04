#!/usr/bin/env bash
# ~/.config/sway/statusbar.sh
# Machine: Ryzen 9 7900X · RX 7700 XT · 32GB RAM · Void Linux · Sway

# ── colors ────────────────────────────────────────────────────────────────────
FG="#cccccc"
GREEN="#62b086"
DIM="#888888"
WARN="#e5c07b"
ERR="#e06c75"
SEP_W=14

# ── helpers ───────────────────────────────────────────────────────────────────

# Escape text safe for JSON string values
json_esc() {
  local s="$1"
  s="${s//\\/\\\\}"          # \ → \\  (must be first)
  s="${s//\"/\\\"}"          # " → \"
  s="${s//$'\n'/\\n}"        # newline → \n
  s="${s//$'\r'/\\r}"        # CR → \r
  s="${s//$'\t'/\\t}"        # tab → \t
  printf '%s' "$s"
}

block() {
  local name="$1" text color="${3:-$FG}"
  text=$(json_esc "$2")
  printf '{"name":"%s","full_text":"%s","color":"%s","separator":false,"separator_block_width":%d}' \
    "$name" "$text" "$color" "$SEP_W"
}

divider() {
  printf '{"full_text":"  ","color":"%s","separator":false,"separator_block_width":0}' "$DIM"
}

# ── cpu ───────────────────────────────────────────────────────────────────────

get_cpu_pct() {
  local s1 s2 t1 i1 t2 i2 dt di pct=0
  s1=$(awk 'NR==1{print $2+$3+$4+$5+$6+$7+$8, $5+$6}' /proc/stat 2>/dev/null) || { echo "?"; return; }
  sleep 0.25
  s2=$(awk 'NR==1{print $2+$3+$4+$5+$6+$7+$8, $5+$6}' /proc/stat 2>/dev/null) || { echo "?"; return; }
  read -r t1 i1 <<< "$s1"
  read -r t2 i2 <<< "$s2"
  [[ -z "$t1" || -z "$t2" ]] && { echo "?"; return; }
  dt=$(( t2 - t1 ))
  di=$(( i2 - i1 ))
  [[ $dt -gt 0 ]] && pct=$(( (dt - di) * 100 / dt ))
  echo "$pct"
}

get_cpu_temp() {
  local dir raw
  for dir in /sys/class/hwmon/hwmon*; do
    if [[ "$(cat "$dir/name" 2>/dev/null)" == "k10temp" ]]; then
      raw=$(cat "$dir/temp1_input" 2>/dev/null) && echo $(( raw / 1000 )) && return
    fi
  done
  echo "?"
}

# ── ram ───────────────────────────────────────────────────────────────────────

get_ram() {
  awk '
    /MemTotal/   { total=$2 }
    /MemFree/    { free=$2  }
    /Buffers/    { buf=$2   }
    /^Cached/    { cache=$2 }
    END { printf "%.1fG/%.0fG", (total-free-buf-cache)/1048576, total/1048576 }
  ' /proc/meminfo 2>/dev/null || echo "?"
}

# ── gpu (amdgpu · RX 7700 XT) ─────────────────────────────────────────────────

_amdgpu_hwmon() {
  local dir
  for dir in /sys/class/hwmon/hwmon*; do
    [[ "$(cat "$dir/name" 2>/dev/null)" == "amdgpu" ]] && echo "$dir" && return 0
  done
  return 1
}

get_gpu_busy() {
  local f
  for f in /sys/class/drm/card*/device/gpu_busy_percent; do
    [[ -f "$f" ]] && cat "$f" && return
  done
  echo "?"
}

get_gpu_temp() {
  local hwmon raw
  hwmon=$(_amdgpu_hwmon 2>/dev/null) || { echo "?"; return; }
  raw=$(cat "$hwmon/temp1_input" 2>/dev/null) || { echo "?"; return; }
  echo $(( raw / 1000 ))
}

get_vram() {
  local card used total
  for card in /sys/class/drm/card*; do
    if [[ -f "$card/device/mem_info_vram_used" ]]; then
      used=$(cat "$card/device/mem_info_vram_used" 2>/dev/null) || continue
      total=$(cat "$card/device/mem_info_vram_total" 2>/dev/null) || continue
      printf "%dM/%dM" $(( used / 1048576 )) $(( total / 1048576 ))
      return
    fi
  done
  echo "?"
}

# ── disk ──────────────────────────────────────────────────────────────────────

get_disk() {
  df -h / 2>/dev/null | awk 'NR==2{print $3"/"$2}' || echo "?"
}

# ── network ───────────────────────────────────────────────────────────────────

get_net() {
  local ssid iface
  ssid=$(iwgetid -r 2>/dev/null)
  if [[ -n "$ssid" ]]; then echo " $ssid"; return; fi
  iface=$(ip route show default 2>/dev/null | awk 'NR==1{print $5}')
  if [[ -n "$iface" ]]; then echo "󰈀 $iface"; return; fi
  echo "󰖪 offline"
}

# ── volume ────────────────────────────────────────────────────────────────────

get_volume() {
  local vol mute
  # avoid pipefail killing us — capture pactl output first
  local sink_vol
  sink_vol=$(pactl get-sink-volume @DEFAULT_SINK@ 2>/dev/null) || { echo "󰝟 ?"; return; }
  vol=$(printf '%s' "$sink_vol" | grep -oP '\d+(?=%)' | head -1) || vol="0"
  mute=$(pactl get-sink-mute @DEFAULT_SINK@ 2>/dev/null | grep -o 'yes\|no') || mute="no"

  if [[ "$mute" == "yes" ]]; then
    echo "󰝟 muted"
  elif [[ "$vol" -ge 60 ]]; then
    echo "󰕾 ${vol}%"
  elif [[ "$vol" -ge 1 ]]; then
    echo "󰖀 ${vol}%"
  else
    echo "󰕿 0%"
  fi
}

# ── mpris ─────────────────────────────────────────────────────────────────────

get_mpris() {
  command -v playerctl &>/dev/null || return 0
  local status
  status=$(playerctl status 2>/dev/null) || return 0
  [[ "$status" == "Stopped" || -z "$status" ]] && return 0
  local artist title icon
  artist=$(playerctl metadata artist 2>/dev/null | cut -c1-18) || artist=""
  title=$(playerctl metadata title 2>/dev/null | cut -c1-22)   || title="unknown"
  [[ "$status" == "Paused" ]] && icon=" " || icon=" "
  if [[ -n "$artist" ]]; then
    echo "${icon}${artist} — ${title}"
  else
    echo "${icon}${title}"
  fi
}

# ── clock ─────────────────────────────────────────────────────────────────────

get_datetime() { date "+%a %d %b   %H:%M:%S"; }

# ── main loop ─────────────────────────────────────────────────────────────────

printf '{"version":1}\n[\n[],\n'

while true; do
  CPU_PCT=$(get_cpu_pct)
  CPU_TEMP=$(get_cpu_temp)
  RAM=$(get_ram)
  GPU_BUSY=$(get_gpu_busy)
  GPU_TEMP=$(get_gpu_temp)
  VRAM=$(get_vram)
  DISK=$(get_disk)
  NET=$(get_net)
  VOL=$(get_volume)
  MPRIS=$(get_mpris)
  DT=$(get_datetime)

  cpu_color=$FG
  if [[ "$CPU_PCT" =~ ^[0-9]+$ ]]; then
    (( CPU_PCT > 95 )) && cpu_color=$ERR || (( CPU_PCT > 80 )) && cpu_color=$WARN
  fi

  gpu_color=$FG
  if [[ "$GPU_BUSY" =~ ^[0-9]+$ ]]; then
    (( GPU_BUSY > 95 )) && gpu_color=$ERR || (( GPU_BUSY > 80 )) && gpu_color=$WARN
  fi

  printf '['

  if [[ -n "$MPRIS" ]]; then
    printf '%s,' "$(block mpris "$MPRIS" "$GREEN")"
    printf '%s,' "$(divider)"
  fi

  printf '%s,' "$(block cpu " ${CPU_PCT}%  ${CPU_TEMP}°" "$cpu_color")"
  printf '%s,' "$(block ram "  ${RAM}" "$FG")"
  printf '%s,' "$(block gpu "󰍹 ${GPU_BUSY}%  ${GPU_TEMP}°" "$gpu_color")"
  printf '%s,' "$(block vram " ${VRAM}" "$DIM")"
  printf '%s,' "$(block disk "󰋊 ${DISK}" "$DIM")"
  printf '%s,' "$(block net "${NET}" "$FG")"
  printf '%s,' "$(block vol "${VOL}" "$FG")"
  printf '%s'  "$(block clock " ${DT}" "$GREEN")"

  printf '],\n'
  sleep 0.75
done
