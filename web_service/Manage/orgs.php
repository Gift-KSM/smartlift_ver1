<?php
require("inc_db.php");

$sql = "SELECT * FROM organizations";
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
        <th>Org Name</th>
        <th>Operation</th>
    </tr>
    <?php
    while ($row = mysqli_fetch_assoc($rs)) {
    ?>
        <tr>
            <td><?php print($row["org_name"]); ?></td>
            <td>
                <a href="edit_org.php?org_id=<?php print($row["id"]); ?>">Edit</a>
                <a href="../Status/index.php?org_id=<?php print($row["id"]); ?>">Status</a>
            </td>
        </tr>
    <?php
    }
    ?>
</table>
<a href="add_org.php">Add</a>