<?php
require("inc_db.php");

if (isset($_GET["org_id"])) {
    $org_id = $_GET["org_id"];
} else {
    $org_id = $_GET["org_id"];
}
$sql = "SELECT L.id, O.org_name, L.lift_name, L.mac_address, L.max_level, L.floor_name";
$sql .= " FROM lifts L";
$sql .= " INNER JOIN organizations O ON L.org_id=O.id";
if ($org_id != 0) {
    $sql .= " WHERE L.org_id=$org_id";
}
$rs = mysqli_query($cn, $sql);
?>
<style>
    table,
    th,
    td {
        border: 1px solid black;
        border-collapse: collapse;
    }

    th,
    td {
        padding: 10px;
    }
</style>
<table width="80%">
    <tr>
        <th>ID</th>
        <th>Org</th>
        <th>Name</th>
        <th>MAC Address</th>
        <th>Max Level</th>
        <th>Floor</th>
        <th>Operation</th>
    </tr>
    <?php
    while ($row = mysqli_fetch_assoc($rs)) {
    ?>
        <tr>
            <td><?php print($row["id"]); ?></td>
            <td><?php print($row["org_name"]); ?></td>
            <td><?php print($row["lift_name"]); ?></td>
            <td><?php print($row["mac_address"]); ?></td>
            <td><?php print($row["max_level"]); ?></td>
            <td><?php print($row["floor_name"]); ?></td>
            <td><a href="edit_lift.php?lift_id=<?php print($row["id"]); ?>">Edit</a></td>
        </tr>
    <?php
    }
    ?>
</table>
<a href="add_lift.php">Add</a>