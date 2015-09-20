<html>
<head>
<title>Raspberry Control Panel :D</title>
</head>
<body>

<?php

if (isset($_GET['submit'])) {

$num=0;
$dur=1;


if ( is_int($_GET['duration'])){
	$dur = $_GET['duration'];
}

if ( isset($_GET['number']) ) {
	$num = $_GET['number'];
	exec("/var/www/sh/php_root /var/www/sh/light_led.sh $num $dur");
	echo "Ok printing";
} else {
	echo "Please provide number on Number field<br/>";
		
}
echo "Num: $num Dur: $dur";
}

?>

<form target="#" method="GET">
Number: <input type="text" name="number" value="1234"/> <br/>
Duration: <input type="text" name="duration" value="1"/><br/>
<input type="submit" name="submit" value="Execute">
</form>

</body>
</html>
