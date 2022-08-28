#!/usr/bin/php
<?php

$file = fopen('/var/dashboard/services/PF', 'w');
fwrite($file, "stop\n");
fclose($file);