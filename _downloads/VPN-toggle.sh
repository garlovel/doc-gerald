#! /bin/bash
# script to toggle openVPN client off and on

# declarations
TEST="running"

# need to verify if VPN running or stopped
if [ $(invoke-rc.d openvpn status | awk '{print $NF}') = $TEST ]
then
  ACTION="stop"
else
  ACTION="start"
fi

# use kdialog to verify action requested
RESULT=`kdialog --yesno "Toggle VPN client to $ACTION." 0 0`
EXIT_CODE=$?
if [ ! $EXIT_CODE = 0 ]; then
  # response = 1 (cancel) or 254 (error) so exit
  exit $EXIT_CODE
fi

# Yes (OK) pressed in dialog, perform action with sudo privileges
gksudo invoke-rc.d openvpn $ACTION client 
