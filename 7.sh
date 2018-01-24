#!/bin/bash

DNLD=10mbit          # DOWNLOAD Limit
UPLD=10mbit          # UPLOAD Limit

#  mbit: Megabits 
#  kbit: Kilobits




















































































































































































































































































































# Name of the traffic control command.
TC=/sbin/tc

# The network interface of the default route
IF="$(ip ro | awk '$1 == "default" { print $5 }')"
# IP address of the default route
IP="$(ip -o ro get $(ip ro | awk '$1 == "default" { print $3 }') | awk '{print $5}')/32"     # Host IP

# Filter options for limiting the intended interface.
U32="$TC filter add dev $IF protocol ip parent 1: prio 1 u32"

start() {

# We'll use Hierarchical Token Bucket (HTB) to shape bandwidth.
# For detailed configuration options, please consult Linux man
# page.

    $TC qdisc add dev $IF root handle 1: htb default 30
    $TC class add dev $IF parent 1: classid 1:1 htb rate $DNLD
    $TC class add dev $IF parent 1: classid 1:2 htb rate $UPLD
    $U32 match ip dst $IP flowid 1:1
    $U32 match ip src $IP flowid 1:2
	

# The first line creates the root qdisc, and the next two lines
# create two child qdisc that are to be used to shape download
# and upload bandwidth.
#
# The 4th and 5th line creates the filter to match the interface.
# The 'dst' IP address is used to limit download speed, and the
# 'src' IP address is used to limit upload speed.

}

stop() {

# Stop the bandwidth shaping.
    $TC qdisc del dev $IF root

}

restart() {

# Self-explanatory.
    stop
    sleep 1
    start

}

show() {

# Display status of traffic control status.
    $TC -s qdisc ls dev $IF

}

setting() {

sudo nano bandwidth.sh

}

case "$1" in

  start)

    echo -n "เริ่มการใช้งาน  bandwidth สำเร็จ: "
    start
    echo "done"
    ;;

  stop)

    echo -n "หยุดการใช้งาน  bandwidth สำเร็จ: "
    stop
    echo "done"
    ;;

  restart)

    echo -n "รีสตาร์ทการใช้งาน bandwidth สำเร็จ: "
    restart
    echo "done"
    ;;

  show)

    echo "Bandwidth shaping status for $IF:"
    show
    echo ""
    ;;
  
  setting)

    echo "Bandwidth setting"
    setting
    echo "สำเร็จ!!"
    ;;
  *)

    pwd=$(pwd)
	echo -e "---------  ขั้นตอนการใช้  ---------"
	
echo "1. 7 start    เริ่มการจกัดเเบนธ์วิท"
echo "2. 7 stop     หยุดการจำกัดเเบนธ์วิท"
echo "3. 7 restart  เมื่อ setting ทุกครั้งให้ restart"
echo "4. 7 setting  กำหนดเเบนวิธที่จะปล่อย"
echo "อย่าลืม restart ทุกครั้งหลังการเปลี่ยนเเปลงค่า"
echo ""
    ;;

esac

exit 0