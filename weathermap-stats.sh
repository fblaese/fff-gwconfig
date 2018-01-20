#!/bin/sh

mkdir -p /tmp/.stats

cd /sys/class/net
for interface in fff*
do
	prev=$(cat /tmp/.stats/$interface)

	if [ -f /tmp/.stats/$interface ]; then
		old_rx=$(echo "$prev" | cut -f1)
		old_tx=$(echo "$prev" | cut -f2)
	else
		old_rx=0
		old_tx=0
	fi
	new_rx=$(cat $interface/statistics/rx_bytes)
	new_tx=$(cat $interface/statistics/tx_bytes)

	#write new values into file
	echo "$new_rx\t$new_tx" > /tmp/.stats/$interface

	diff_rx=$((($new_rx - $old_rx)/60*8))
	diff_tx=$((($new_tx - $old_tx)/60*8))

	echo "$interface\t$diff_rx\t$diff_tx" > /var/www/stmarkus/weathermap-stats/$interface.txt
done
