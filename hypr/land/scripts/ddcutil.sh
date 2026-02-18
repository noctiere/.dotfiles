#!/run/current-system/sw/bin/bash

DISPLAY_NAME="HDMI-A-1"
DISPLAY_NUM=1
VCP_CODE=10
ACTION=$1
STEP=${2:-5}

if [ "$ACTION" == "up" ]; then
    ddcutil setvcp $VCP_CODE + $STEP --display $DISPLAY_NUM
elif [ "$ACTION" == "down" ]; then
    ddcutil setvcp $VCP_CODE - $STEP --display $DISPLAY_NUM
fi

CURRENT_VAL=$(ddcutil getvcp $VCP_CODE --display $DISPLAY_NUM --brief | awk '{print $4}' | tr -d ',')

if [ "$CURRENT_VAL" -eq 100 ]; then
    PROGRESS="1.0"
elif [ "$CURRENT_VAL" -lt 10 ]; then
    PROGRESS="0.0$CURRENT_VAL"
else
    PROGRESS="0.$CURRENT_VAL"
fi

swayosd-client \
    --monitor "$DISPLAY_NAME" \
    --custom-icon "display-brightness-symbolic" \
    --custom-progress "$PROGRESS"
