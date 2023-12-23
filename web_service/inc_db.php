<?php
$servername = "52.221.67.113";
$username = "root";
$password = " kuse@fse2018";
$dbconnect = "smartlift";
$cn = mysqli_connect($host, $user, $passwd, $db);

$redis = new Redis();
$redis->connect('52.221.67.113', 6379);
$redis->auth('kuse@fse2023');
