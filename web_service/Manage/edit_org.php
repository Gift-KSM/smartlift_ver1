<?php
require("inc_db.php");
$org_id = $_GET["org_id"];


$sql = "SELECT * FROM organizations WHERE id = $org_id";

$rs = mysqli_query($cn, $sql);
$org = mysqli_fetch_assoc($rs);
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
<form action="submit_edit_org.php" method="post">
  <table>
    <tr>
      <td>Organization:</td>
      <td>
        <input type="hidden" name="id" value="<?php print($org["id"]); ?>">
        <input type="text" name="org_name" size="30" value="<?php print($org["org_name"]); ?>">
      </td>
    </tr>
    <tr>
      <td colspan="2"><input type="submit"></td>
    </tr>
  </table>
</form>