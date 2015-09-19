#!/bin/bash

# by bidaribishnu7@gmail.com for fun
# Raspbian on Raspberry Pi 2 Model B

# DIY Seven Segment Display Circuit using 
# 1) Masking tape
# 2) Papers
# 3) LEDs 
# 4) wires

LEDS=(5 6 12 13 23 24 25)

NO0=(${LEDS[0]} ${LEDS[1]} ${LEDS[2]} ${LEDS[3]} ${LEDS[4]} ${LEDS[5]})
NO1=(${LEDS[1]} ${LEDS[2]})
NO2=(${LEDS[0]} ${LEDS[1]} ${LEDS[6]} ${LEDS[4]} ${LEDS[3]})
NO3=(${LEDS[0]} ${LEDS[1]} ${LEDS[6]} ${LEDS[2]} ${LEDS[3]})
NO4=(${LEDS[1]} ${LEDS[6]} ${LEDS[2]} ${LEDS[5]})
NO5=(${LEDS[0]} ${LEDS[5]} ${LEDS[6]} ${LEDS[2]} ${LEDS[3]})
NO6=(${LEDS[0]} ${LEDS[5]} ${LEDS[6]} ${LEDS[2]} ${LEDS[3]} ${LEDS[4]})
NO7=(${LEDS[0]} ${LEDS[1]} ${LEDS[2]})
NO8=(${LEDS[0]} ${LEDS[1]} ${LEDS[2]} ${LEDS[6]} ${LEDS[3]} ${LEDS[4]} ${LEDS[5]})
NO9=(${LEDS[0]} ${LEDS[1]} ${LEDS[6]} ${LEDS[2]} ${LEDS[3]} ${LEDS[5]})

init() {
for LED in ${LEDS[@]}; do
	echo $LED > /sys/class/gpio/export
	echo out > /sys/class/gpio/gpio$LED/direction
done
}

close() {

for LED in ${LEDS[@]}; do
	echo 0 > /sys/class/gpio/gpio$LED/value
	echo $LED > /sys/class/gpio/unexport
done

}

turnon() {
	echo 1 > /sys/class/gpio/gpio$1/value
}
turnoff() {
	echo 0 > /sys/class/gpio/gpio$1/value
}

num() {

num_array=NO$1[@]
for LED in ${!num_array}; do
	turnon $LED
done
}

num_off() {
num_array=NO$1[@]
for LED in ${!num_array}; do
	turnoff $LED
done
}

display() {
myNum=$1
sleepTime=$2
for i in `seq 0 $(( ${#myNum} - 1))`; do
   # echo " $i :: ${myNum:$i:1}"
   n=${myNum:$i:1}
  num $n
  echo -n "$n "
  sleep $sleepTime
  num_off $n 
done

}

if [ "$#" -ne 2 ]; then
	echo "Expecting arguments"
	echo "Usage :  $0 <number to display> <seconds to diplay each digit>"
	echo

	exit 1
fi

init
echo "Displaying $1 character wise through 7-segment..."
display $1 $2 
close
echo "Thank You"
