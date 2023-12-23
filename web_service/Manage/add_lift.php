<?php
require("inc_db.php");
$lift_id = $_GET["lift_id"];

$sql = "SELECT * FROM organizations";
$rs_org = mysqli_query($cn, $sql);
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
<form action="submit_add_lift.php" method="post">
    <table>
        <tr>
            <td>Organization:</td>
            <td>
                <select name="org_id">
                    <?php
                    while ($row = mysqli_fetch_assoc($rs_org)) {
                    ?>
                        <option value="<?php print($row["id"]); ?>">
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
            <td><input type="text" name="lift_name" size="20"></td>
        </tr>
        <tr>
            <td>MAC Address:</td>
            <td><input type="text" name="mac_address" size="20"></td>
        </tr>
        <tr>
            <td>Max Level:</td>
            <td><input type="text" name="max_level" size="4"></td>
        </tr>
        <tr>
            <td>Floor Name:</td>
            <td><input type="text" name="floor_name" size="40"></td>
        </tr>
        <tr>
            <td colspan="2"><input type="submit"></td>
        </tr>
    </table>
</form>