<?php
require("inc_db.php");

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
<form action="submit_add_org.php" method="post">
  <table>
    <tr>
      <td>Organization:</td>
      <td>
        <input type="text" name="org_name" size="30" value="<?php print($org["org_name"]); ?>">
      </td>
    </tr>
    <tr>
      <td colspan="2"><input type="submit"></td>
    </tr>
  </table>
</form>