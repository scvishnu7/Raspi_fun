Controls the DIY seven_segment display connected to raspi 
through the webpage hosted on raspi

To run the project
-> install apace2 webserver and php
-> then run the install.sh script
-> restart webserver and access the url http://<ip of your raspi>/sh/ from any machine on same network


index.php file has the php which will fire the command on raspi using the parameter passed from html 

This thing utilized code from php_root repo to run the code with root privilages(to manuplate the GPIO)
plus the seven_seg_disply script for raspi

As this way raspi could be used to remotely manage home appliance like light,fan, water pump etc which attract my attention


