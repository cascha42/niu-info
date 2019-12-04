#!/bin/sh

# Config and Variables
. ./config.sh
apiurl="https://app-api-fk.niu.com"


# Functions
get_motor_data() {
	url="${apiurl}/v3/motor_data/index_info?sn=${serialnumber}"

	curl -s -H "token: ${token}" $url -o /tmp/motor_data.json
}

get_battery_info() {
	url="${apiurl}/v3/motor_data/battery_info?sn=${serialnumber}"

	curl -s -H "token: ${token}" $url -o /tmp/battery_info.json
}

is_battery_connected() {
	cat /tmp/motor_data.json | jq '.data.isConnected'
}

is_charging() {
	cat /tmp/motor_data.json | jq '.data.isCharging'
}

get_battery_charge() {
	cat /tmp/motor_data.json | jq '.data.batteries.compartmentA.batteryCharging'
}

get_lat() {
	cat /tmp/motor_data.json | jq '.data.postion.lat'
}

get_lng() {
	cat /tmp/motor_data.json | jq '.data.postion.lng'
}

get_gmap_link() {
	lat="$(get_lat)"
	lng="$(get_lng)"

	echo "https://www.google.de/maps/place/${lat},${lng}/@${lat},${lng}"
}

get_estimated_range() {
	cat /tmp/motor_data.json | jq '.data.estimatedMileage'
}

get_last_update_time() {
	millies=$(cat /tmp/motor_data.json | jq '.data.infoTimestamp')
	date --date="@$(echo $(( $millies / 1000 )))" "+%F %T"
}

get_lock_status() {
	cat /tmp/motor_data.json | jq '.data.lockStatus'
}

main() {
	# Get fresh json data on every run
	get_motor_data
	#get_battery_info


	# Exit 1 if Token Error
	if grep -q "ERROR" /tmp/motor_data.json; then
	    echo "TOKEN ERROR, aborting."
		exit 1
	else
		:	 
	fi
	

	# Main Response
	echo -n "Lock Status: "
	if [ "$(get_lock_status)" = "0" ]; then
		echo "locked"
	else
		echo "unlocked"
	fi

	if [ "$(is_battery_connected)" = "true" ]; then
		echo -n "Battery: $(get_battery_charge)%"
		if [ "$(is_charging)" = "1" ]; then
			echo " (Charging)"
		else
			echo ""
		fi
	else
		echo "Battery: not connected"
	fi

	echo "Range: $(get_estimated_range)km"

	echo "Position: $(get_gmap_link)"
	echo "Last API Update: $(get_last_update_time)"
}
main

