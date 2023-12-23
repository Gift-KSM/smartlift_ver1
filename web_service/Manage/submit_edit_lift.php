<?php
require("inc_db.php");

$id = $_POST["id"];
$org_id = $_POST["org_id"];
$lift_name = $_POST["lift_name"];
$mac_address = $_POST["mac_address"];
$max_level = $_POST["max_level"];
$floor_name = $_POST["floor_name"];

$sql = "UPDATE lifts SET org_id='$org_id', lift_name='$lift_name', mac_address='$mac_address',";
$sql .= " max_level='$max_level', floor_name='$floor_name' WHERE id=$id";
mysqli_query($cn, $sql);

$sql = "SELECT * FROM organizations WHERE id=$org_id";
$rs = mysqli_query($cn, $sql);
$org_name = mysqli_fetch_assoc($rs);

$redis->lSet('Lift-' . str_pad($id, 4, "0", STR_PAD_LEFT), 0, $org_name["org_name"]);
$redis->lSet('Lift-' . str_pad($id, 4, "0", STR_PAD_LEFT), 1, $lift_name);
$redis->lSet('Lift-' . str_pad($id, 4, "0", STR_PAD_LEFT), 2, $max_level);
$redis->lSet('Lift-' . str_pad($id, 4, "0", STR_PAD_LEFT), 8, $floor_name);
$redis->lSet('Lift-' . str_pad($id, 4, "0", STR_PAD_LEFT), 9, $mac_address);

header('Location: lifts.php');
