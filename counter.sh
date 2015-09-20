#!/bin/bash
#
# by bidaribishnu7@gmail.com for Fun
#
# Connect two LDR between pin 13&12 and 13&16 and are placed them close to each other on the same side of the door.
# point two light source on those LDR(one for each) from the other side of the door.
# When anything crosses the door, that object will block the led on following sequence
#		-> Blocks one LDR (say LDR1)
#		-> Blocks Both LDR (LDR1 and LDR2)
#		-> Blocks another LDR (LDR2)
# This script detects this sequence of the blocking of LDR and hence can detects where a person enters the room or 
# leaves the room.
# NOTE: not an strong logic, and the circut needs to be adopted to make it more sensative.

inp1=12
inp2=16
outp=13

INSEQ=(10 00 01 11)
OUTSEQ=(01 00 10 11)
BUFFERSEQ=(11 11 11 11)

noPeople=0

#Compairs equal sized array and return 0 if array are not equal
equal_array() {

aVar=$1[@]

count=0
for elem in ${!aVar}; do
	bVar=$2[$count]
	if [ $elem -ne ${!bVar} ]; then 
		return 0
	fi	
	let count+=1
done
return 1
}

# Read the status of the GPIO pin given on argument
read_pin() {
 state=`cat /sys/class/gpio/gpio$1/value`
 #echo $1 > /sys/class/gpio/unexport
 echo "$state";
}

close() {
 echo $outp > /sys/class/gpio/unexport
 echo $inp1 > /sys/class/gpio/unexport
 echo $inp2 > /sys/class/gpio/unexport
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
lastBuf=11

while [ "x$keypress" = "x" ]; do
  PIN1=$(read_pin $inp1)
  PIN2=$(read_pin $inp2)
  echo -ne "[ $PIN1 : $PIN2 ]  ( $noPeople inside room )"'\r'
  keypress="`cat -v`"

CURBUF=$PIN1$PIN2

#if [[ ( "$PIN1" != 1 ) || ( "$PIN2" != 1 ) ]] ; then
if [[ ( "$CURBUF" != "$LASTBUF" ) ]]; then
	
	echo "$count :: CurBuf = $CURBUF, lastBuf= $LASTBUF"	
	LASTBUF=$CURBUF	

	BUFFERSEQ[$count]=$CURBUF
	let count+=1
	 if [[ ( $CURBUF == 11 ) ]]; then
		equal_array INSEQ BUFFERSEQ
		res=$?
		equal_array OUTSEQ BUFFERSEQ	
		res2=$?

		if [[ ($res == 1 ) ]]; then 
			echo "<<<<   1 Man entered"
			let noPeople+=1
		elif [[ ($res2 == 1 ) ]]; then
			echo ">>>>   1 Man Leaved "
			let noPeople-=1
		else
			echo "Jpt data "
		fi
	
		count=0
		echo
		echo
	 fi

fi

done
if [ -t 0 ]; then stty sane; fi


# Cleaning up the pins state
close

echo "Thank You"
