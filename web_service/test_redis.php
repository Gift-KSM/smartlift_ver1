<?php
$redis = new Redis();
$redis->connect('52.221.67.113', 6379);
$redis->auth('kuse@fse2023');
//$redis->lSet('Lift-0001', 6, '11111111');
//$redis->lSet('Lift-0001', 6, '00000000');
$data = $redis->lRange('Lift-0001', 0, 7);
print($data[0] . " " . $data[1] . " " . $data[2] . " " . $data[3] . " " . $data[4] . " " . $data[5] . " " . $data[6]);
