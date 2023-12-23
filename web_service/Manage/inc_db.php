<?php
$host = "localhost";
$user = "smartlift";
$passwd = "Smart123!";
$db = "smartlift";
$cn = mysqli_connect($host, $user, $passwd, $db);
$redis = new Redis();
$redis->connect('52.221.67.113', 6379);
$redis->auth('kuse@fse2023');
