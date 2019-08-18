#!/bin/sh

# Config
. ./config.sh
apiurl="https://app-api-fk.niu.com"

get_motor_data() {
	url="${apiurl}/v3/motor_data/index_info?sn=${serialnumber}"

	curl -s -H "token: ${token}" $url -o /tmp/motor_data.json
}

get_battery_info() {
	url="${apiurl}/v3/motor_data/battery_info?sn=${serialnumber}"

	curl -s -H "token: ${token}" $url -o /tmp/battery_info.json
}

is_charging() {
	if [ "$(cat /tmp/motor_data.json | jq '.data.isCharging')" = "0" ]; then
		return 1
	else
		return 0
	fi
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

get_last_gps_time() {
	millies=$(cat /tmp/motor_data.json | jq '.data.gpsTimestamp')
	date --date="@$(echo $(( $millies / 1000 )))"
}

get_speed() {
	cat /tmp/motor_data.json | jq '.data.nowSpeed'
}

main() {
	# Get fresh json data on every run
	get_motor_data
	#get_battery_info


	echo -n "Battery: $(get_battery_charge)%"
	if is_charging; then
		echo " (Charging)"
	else
		echo ""
	fi

	echo "Range: $(get_estimated_range)km"

	echo "Position: $(get_gmap_link)"
	echo "Last GPS Update: $(get_last_gps_time)"
	echo "Speed: $(get_speed)km/h"
}
main

