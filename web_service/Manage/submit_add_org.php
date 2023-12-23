<?php
require("inc_db.php");
$org_name = $_POST["org_name"];

$sql = "INSERT INTO organizations(org_name,description,created_user_id,created_at,updated_user_id,updated_at)";
$sql .= " VALUES('$org_name','',1,NOW(),1,NOW())";
mysqli_query($cn, $sql);

header('Location: orgs.php');
