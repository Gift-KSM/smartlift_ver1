<?php
require("inc_db.php");
$lift_id = $_GET["lift_id"];

$sql = "SELECT * FROM organizations";
$rs_org = mysqli_query($cn, $sql);

$sql = "SELECT L.id, L.org_id, L.lift_name, L.mac_address, L.max_level, L.floor_name";
$sql .= " FROM lifts L";
$sql .= " INNER JOIN organizations O ON L.org_id=O.id";
$sql .= " WHERE L.id = $lift_id";

$rs_lift = mysqli_query($cn, $sql);
$lift = mysqli_fetch_assoc($rs_lift);
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
<form action="submit_edit_lift.php" method="post">
    <table>
        <tr>
            <td>
                Lift ID:
            </td>
            <td>
                <input type="hidden" name="id" value="<?php print($lift["id"]); ?>">
                <?php print($lift["id"]); ?>
            </td>
        </tr>
        <tr>
            <td>Organization:</td>
            <td>
                <select name="org_id">
                    <?php
                    while ($row = mysqli_fetch_assoc($rs_org)) {
                    ?>
                        <option value="<?php print($row["id"]); ?>" <?php if ($lift["org_id"] == $row["id"]) print(" selected"); ?>>
                            <?php print($row["org_name"]); ?>
                        </option>
                    <?php
                    }
                    ?>
                </select>
            </td>
        </tr>
        <tr>
            <td>Lift Name:</td>
            <td><input type="text" name="lift_name" size="20" value="<?php print($lift["lift_name"]); ?>"></td>
        </tr>
        <tr>
            <td>MAC Address:</td>
            <td><input type="text" name="mac_address" size="20" value="<?php print($lift["mac_address"]); ?>"></td>
        </tr>
        <tr>
            <td>Max Level:</td>
            <td><input type="text" name="max_level" size="4" value="<?php print($lift["max_level"]); ?>"></td>
        </tr>
        <tr>
            <td>Floor Name:</td>
            <td><input type="text" name="floor_name" size="40" value="<?php print($lift["floor_name"]); ?>"></td>
        </tr>
        <tr>
            <td colspan="2"><input type="submit"></td>
        </tr>
    </table>
</form>