<?php
require("inc_db.php");

$id = $_POST["id"];
$org_name = $_POST["org_name"];

$sql = "UPDATE organizations SET org_name='$org_name' WHERE id=$id";
mysqli_query($cn, $sql);

header('Location: orgs.php');
