#!/bin/bash

# by bidaribishnu7@gmail.com for FUN
# 
# Connect LDR (Light Dependent Resister) between GPIO pins 13&12 and 13&16
# Focus light to those two LDRs 
# Or push switch could be used instead 


inp1=12
inp2=16
outp=13

read_pin() {
state=`cat /sys/class/gpio/gpio$1/value`
#echo $1 > /sys/class/gpio/unexport
echo "$state"
}


# initialize the pins for input and one pin is used for output

echo $outp > /sys/class/gpio/export
echo $inp1 > /sys/class/gpio/export
echo $inp2 > /sys/class/gpio/export
echo out > /sys/class/gpio/gpio$outp/direction
echo in > /sys/class/gpio/gpio$inp1/direction
echo in > /sys/class/gpio/gpio$inp2/direction

echo 1 > /sys/class/gpio/gpio$outp/value


if [ -t 0 ]; then stty -echo -icanon -icrnl time 0 min 0; fi

count=0
keypress=''
while [ "x$keypress" = "x" ]; do
  let count+=1
  PIN1=$(read_pin $inp1)
  PIN2=$(read_pin $inp2)
  echo -ne "INPUT >> [ $PIN1 : $PIN2 ]"'\r'
  keypress="`cat -v`"




done
if [ -t 0 ]; then stty sane; fi


# Cleaning up the pins state
echo $outp > /sys/class/gpio/unexport
echo $inp1 > /sys/class/gpio/unexport
echo $inp2 > /sys/class/gpio/unexport

echo "Thank You"
