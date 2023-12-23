<?php
$host = "localhost";
$user = "smartlift";
$passwd = "Smart123!";
$db = "smartlift";

$org_id = $_GET["org_id"];
$cn = mysqli_connect($host, $user, $passwd, $db);
$sql = "SELECT * FROM organizations WHERE id=$org_id";
$rs1 = mysqli_query($cn, $sql);
$org = mysqli_fetch_assoc($rs1);
$sql = "SELECT * FROM lifts L WHERE org_id=$org_id";
$rs2 = mysqli_query($cn, $sql);
?>
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Lift RMS</title>
  <link rel="stylesheet" href="stlye.css" />
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
  <link rel="apple-touch-icon" sizes="180x180" href="apple-touch-icon.png">
  <link rel="icon" type="image/png" sizes="32x32" href="favicon-32x32.png">
  <link rel="icon" type="image/png" sizes="16x16" href="favicon-16x16.png">
  <link rel="manifest" href="site.webmanifest">
  <!-- <script src="script.js" defer></script> -->
</head>

<body>

  <!-- ***** Header Area Start ***** -->
  <header class="header">
    <img class="logo" src="assets/images/icon_company.png" alt="" />
    </div>
  </header>
  <!-- ***** Header Area End ***** -->

  <main>
    <section class="parent">
      <section class="child1">
        <header class="head">
          <h2><?php print($org["org_name"]); ?></h2>
        </header>

        <div class="container">
          <?php
          while ($row = mysqli_fetch_assoc($rs2)) {
          ?>
            <div class="flex-item item-1">
              <h4><?php print($row["lift_name"]); ?></h4>
              <table id="carLevel_<?php print($row["id"]); ?>">
                <?php
                $maxLevel = $row["max_level"];
                $floorName = explode(",", $row["floor_name"]);
                $numRows = ceil($maxLevel / 5);
                $numCols = ceil($maxLevel / $numRows);
                $counter = 1;
                for ($i = 0; $i < $numRows; $i++) {
                  print("\t\t\t<tr>\n");
                  for ($j = 0; $j < $numCols; $j++) {
                    if ($counter <= count($floorName)) {
                      print("\t\t\t\t<td id=\"car_" . $row["id"] . "_$counter\">" . $floorName[$counter - 1] . "</td>\n");
                      $counter++;
                    } else {
                      break;
                    }
                  }
                  print("\t\t\t</tr>\n");
                }
                ?>
              </table>
              <br>
              <table width="100%">
                <tr>
                  <th>DOOR</th>
                  <th>MODE</th>
                  <th>CONN</th>
                </tr>
                <tr>
                  <th id="door_<?php print($row["id"]); ?>"></th>
                  <th id="mode_<?php print($row["id"]); ?>"></th>
                  <th id="connection_<?php print($row["id"]); ?>"></th>
                </tr>
              </table>
              <br>
              <div class="lift_simulation">
                <div class="column_arrow_Down" id="colsArrowDown_<?php print($row["id"]); ?>">
                  <table id="down_<?php print($row["id"]); ?>">
                    <?php
                    for ($i = $maxLevel - 1; $i >= 0; $i--) {
                      if ($i == 0) {
                        print("<div class=\"column_arrow_none\" id=\"downArrow_" . $row["id"] . "_" . ($i + 1) . "\">&#8681;</div>");
                      } else {
                        print("<div class=\"column_arrow_UpDown\" id=\"downArrow_" . $row["id"] . "_" . ($i + 1) . "\">&#8681;</div>");
                      }
                    }
                    ?>
                  </table>
                </div>
                <div class="column_arrow_Up" id="colsArrowUp_<?php print($row["id"]); ?>">
                  <table id="up_<?php print($row["id"]); ?>">
                    <?php
                    for ($i = $maxLevel - 1; $i >= 0; $i--) {
                      if ($i == $maxLevel - 1) {
                        print("<div class=\"column_arrow_none\" id=\"upArrow_" . $row["id"] . "_" . ($i + 1) . "\">&#8679;</div>");
                      } else {
                        print("<div class=\"column_arrow_UpDown\" id=\"upArrow_" . $row["id"] . "_" . ($i + 1) . "\">&#8679;</div>");
                      }
                    }
                    ?>
                  </table>
                </div>
                <div class="column_liftFloor" id="colsLiftFloor_<?php print($row["id"]); ?>">
                  <table id="lift_<?php print($row["id"]); ?>">
                    <?php
                    for ($i = $maxLevel - 1; $i >= 0; $i--) {
                      print("<div class=\"num_liftFloor\" id=\"num_" . $row["id"] . "_" . ($i + 1) . "\">" . $floorName[$i] . "</div>");
                    }
                    ?>
                  </table>
                </div>
              </div>
            </div>
          <?php
          }
          ?>
        </div>
      </section>

</body>
<script src="script.js"></script>
<script>
  <?php
  $sql = "SELECT * FROM lifts WHERE org_id=$org_id";
  $rs2 = mysqli_query($cn, $sql);
  while ($row = mysqli_fetch_assoc($rs2)) {
  ?>
    setInterval(function() {
      getData(<?php print($row["id"]); ?>);
    }, 1000);
  <?php
  }
  ?>
</script>

</html>