#!/usr/bin/env sh
  
# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch polybar
#polybar mybar -c ~/.config/polybar/config

#for m in $(polybar --list-monitors | cut -d":" -f1); do
#       MONITOR=$m polybar --reload ~/.config/polybar/config mybar &
#done

#if type "xrandr"; then
#  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
#     MONITOR=$m polybar -c ~/.config/polybar/config primary &
#  done
#fi

# Determine monitors
PRIMARY_MONITOR=$(xrandr | awk '$2 == "connected" && $3 == "primary" { print $1 }')
SECONDARY_MONITORS=$(xrandr | awk '$2 == "connected" && $3 != "primary" { print $1 }')

# Launch bars
echo "---" | tee -a /tmp/polybar_primary.log
POLYBAR_MONITOR=$PRIMARY_MONITOR polybar primary >>/tmp/polybar_primary.log 2>&1 &

for m in $SECONDARY_MONITORS
do
        echo "---" | tee -a /tmp/polybar_secondary_$m.log
        POLYBAR_MONITOR=$m polybar secondary >>/tmp/polybar_secondary_$m.log 2>&1 &
done

notify-send "Polybar launched..."
