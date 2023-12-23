<?php
require("inc_db.php");

$org_id = $_POST["org_id"];
$lift_name = $_POST["lift_name"];
$mac_address = $_POST["mac_address"];
$max_level = $_POST["max_level"];
$floor_name = $_POST["floor_name"];

$sql = "INSERT INTO lifts(org_id,lift_name,mac_address,max_level,floor_name,created_user_id,created_at,updated_user_id,updated_at)";
$sql .= " VALUES($org_id,'$lift_name','$mac_address','$max_level','$floor_name',1,NOW(),1,NOW())";
mysqli_query($cn, $sql);

$last_id = mysqli_insert_id($cn);


$sql = "SELECT * FROM organizations WHERE id=$org_id";
$rs = mysqli_query($cn, $sql);
$org_name = mysqli_fetch_assoc($rs);

$redis->RPUSH('Lift-' . str_pad($last_id, 4, "0", STR_PAD_LEFT), $org_name["org_name"]);
$redis->RPUSH('Lift-' . str_pad($last_id, 4, "0", STR_PAD_LEFT), $lift_name);
$redis->RPUSH('Lift-' . str_pad($last_id, 4, "0", STR_PAD_LEFT), $max_level);
$redis->RPUSH('Lift-' . str_pad($last_id, 4, "0", STR_PAD_LEFT), "000000000000");
$redis->RPUSH('Lift-' . str_pad($last_id, 4, "0", STR_PAD_LEFT), "00000000");
$redis->RPUSH('Lift-' . str_pad($last_id, 4, "0", STR_PAD_LEFT), "00000000");
$redis->RPUSH('Lift-' . str_pad($last_id, 4, "0", STR_PAD_LEFT), "00000000");
$redis->RPUSH('Lift-' . str_pad($last_id, 4, "0", STR_PAD_LEFT), "2023-07-01 12:11:02");
$redis->RPUSH('Lift-' . str_pad($last_id, 4, "0", STR_PAD_LEFT), $floor_name);
$redis->RPUSH('Lift-' . str_pad($last_id, 4, "0", STR_PAD_LEFT), $mac_address);


header('Location: lifts.php');
