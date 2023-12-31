<?php
require("inc_db.php");

$lift_id = $_GET["lift_id"];
$lift_state = $_GET["lift_state"];
$up_status = $_GET["up_status"];
$down_status = $_GET["down_status"];
$car_status = $_GET["car_status"];
$last_update = date("Y-m-d H:i:s");

$redis->lSet('Lift-' . str_pad($lift_id, 4, "0", STR_PAD_LEFT), 3, $lift_state);
$redis->lSet('Lift-' . str_pad($lift_id, 4, "0", STR_PAD_LEFT), 4, $up_status);
$redis->lSet('Lift-' . str_pad($lift_id, 4, "0", STR_PAD_LEFT), 5, $down_status);
$redis->lSet('Lift-' . str_pad($lift_id, 4, "0", STR_PAD_LEFT), 6, $car_status);
$redis->lSet('Lift-' . str_pad($lift_id, 4, "0", STR_PAD_LEFT), 7, $last_update);

$data1 = $redis->lRange('Lift-' . str_pad($lift_id, 4, "0", STR_PAD_LEFT), 0, 8);
$data2 = $redis->lRange('Name-' . str_pad($lift_id, 4, "0", STR_PAD_LEFT), 0, 1);
//print($data[0]." ".$data[1]." ".$data[2]." ".$data[3]." ".$data[4]." ".$data[5]." ".$data[6]." ".$data[7]);
$array = array();
$array["org_name"] = $data1[0];
$array["lift_name"] = $data1[1];
$array["max_level"] = $data1[2];
$array["lift_state"] = $data1[3];
$array["up_status"] = $data1[4];
$array["down_status"] = $data1[5];
$array["car_status"] = $data1[6];
$array["last_update"] = $data1[7];
$array["level_name"] = $data2[0];
echo json_encode($array, JSON_FORCE_OBJECT);
