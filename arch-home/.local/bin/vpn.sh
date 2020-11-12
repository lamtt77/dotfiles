#!/usr/bin/env bash

vpn="wg2fcmLAN"

if [[ "${1}" == "status" ]]; then
	if nmcli -t con show $vpn | grep -qi 'wireguard'; then
		echo ""
	else
		echo ""
	fi

elif [[ "${1}" == "toggle" ]]; then
	if nmcli -t con show $vpn | grep -qi 'wireguard'; then
		wg-quick down $vpn
		notify-send "VPN Down"
	else
		wg-quick up $vpn
		notify-send "VPN Active"
	fi
fi
