function getData(id) {
  let loadData = new XMLHttpRequest();
  loadData.onreadystatechange = function () {
    if (loadData.readyState === 4 && loadData.status === 200) {
      let data = JSON.parse(loadData.responseText);
      liftState = data.lift_state;
      maxLevel = data.max_level;
      upStatus = data.up_status;
      downStatus = data.down_status;
      carStatus = data.car_status;
      connectionStatus = data.connection_status;
      updateUI(id, maxLevel, liftState, upStatus, downStatus, carStatus, connectionStatus);
    }
  };
  loadData.open(
    "GET",
    "http://52.221.67.113/smartlift/get_status.php?lift_id=" + id,
    true
  );
  loadData.send();
}
function updateUI(id, maxLevel, liftState, upStatus, downStatus, carStatus, connectionStatus) {
  updateLiftState(id, maxLevel, liftState, connectionStatus);
  updateUpStatus(id, maxLevel, upStatus);
  updateDownStatus(id, maxLevel, downStatus);
  updateCarStatus(id, maxLevel, carStatus);
}
function updateLiftState(id, maxLevel, liftState, connectionStatus) {
  current_level = parseInt(liftState.substring(0, 2), 16);
  door = document.getElementById("door_" + id);
  mode = document.getElementById("mode_" + id);
  connection = document.getElementById("connection_" + id);
  door.innerHTML = checkDoorText(liftState);
  mode.innerHTML = checkWorkingStatus(liftState);
  error = checkError(liftState);
  connection.innerHTML = connectionStatus;
  if (connectionStatus == "Offline") {
    connection.style.backgroundColor = "red";
  } else {
    connection.style.backgroundColor = "transparent";
  }
  for (i = 0; i < maxLevel; i++) {
    lift_level = document.getElementById("num_" + id + "_" + (i + 1));
    if (current_level == i + 1) {
      if (error != "1" && error != "2") {
        lift_level.style.backgroundColor = "green";
      } else {
        lift_level.style.backgroundColor = "red";
      }
    } else {
      lift_level.style.backgroundColor = "transparent";
    }
  }
}
function updateUpStatus(id, maxLevel, upStatus) {
  for (i = 0; i < maxLevel; i++) {
    level = document.getElementById("upArrow_" + id + "_" + (i + 1));
    if (checkLevel(upStatus, i + 1)) {
      level.style.backgroundColor = "green";
    } else {
      level.style.backgroundColor = "transparent";
    }
  }
}
function updateDownStatus(id, maxLevel, downStatus) {
  for (i = 0; i < maxLevel; i++) {
    level = document.getElementById("downArrow_" + id + "_" + (i + 1));
    if (checkLevel(downStatus, i + 1)) {
      level.style.backgroundColor = "green";
    } else {
      level.style.backgroundColor = "transparent";
    }
  }
}
function updateCarStatus(id, maxLevel, carStatus) {
  for (i = 0; i < maxLevel; i++) {
    level = document.getElementById("car_" + id + "_" + (i + 1));
    if (checkLevel(carStatus, i + 1)) {
      level.style.backgroundColor = "green";
    } else {
      level.style.backgroundColor = "transparent";
    }
  }
}

function updateConnectionStatus(id, maxLevel, carStatus) {
  for (i = 0; i < maxLevel; i++) {
    level = document.getElementById("car_" + id + "_" + (i + 1));
    if (checkLevel(carStatus, i + 1)) {
      level.style.backgroundColor = "green";
    } else {
      level.style.backgroundColor = "transparent";
    }
  }
}

function checkLevel(statusString, level) {
  if (level <= 8) {
    value = parseInt(statusString.substring(0, 2), 16);
    mask = 1 << (level - 1);
    if ((value & mask) != 0) {
      return true;
    }
  } else if (level <= 16) {
    value = parseInt(statusString.substring(2, 4), 16);
    mask = 1 << (level - 9);
    if ((value & mask) != 0) {
      return true;
    }
  } else if (level <= 24) {
    value = parseInt(statusString.substring(4, 6), 16);
    mask = 1 << (level - 17);
    if ((value & mask) != 0) {
      return true;
    }
  } else {
    value = parseInt(statusString.substring(6, 8), 16);
    mask = 1 << (level - 25);
    if ((value & mask) != 0) {
      return true;
    }
  }
  return false;
}

function checkDoorText(statusString) {
  value = parseInt(statusString.substring(2, 4), 16);
  doorStatus = value & 3;
  if (doorStatus == 0) {
    return "Opened";
  } else if (doorStatus == 1) {
    return "Closed";
  } else if (doorStatus == 2) {
    return "Closing";
  } else if (doorStatus == 3) {
    return "Opening";
  } else {
    return "Opened";
  }
}
function checkSpeed(statusString) {
  value = parseInt(statusString.substring(8, 12), 16);
  return (parseInt(value / 100) / 10);
}

function checkError(statusString) {
  value = parseInt(statusString.substring(6, 8), 16);
  return value;
}

function checkWorkingStatus(statusString) {
  value = parseInt(statusString.substring(4, 6), 16);
  workingStatus = value & 15;
  if (workingStatus == 0) {
    return "Auto";
  } else if (workingStatus == 1) {
    return "INSP";
  } else if (workingStatus == 2) {
    return "Fire";
  } else if (workingStatus == 3) {
    return "Driving";
  } else if (workingStatus == 4) {
    return "Special";
  } else if (workingStatus == 5) {
    return "Learning";
  } else if (workingStatus == 6) {
    return "Lock";
  } else if (workingStatus == 7) {
    return "Reset";
  } else if (workingStatus == 8) {
    return "UPS";
  } else if (workingStatus == 9) {
    return "Idle";
  } else if (workingStatus == 10) {
    return "Break";
  } else if (workingStatus == 11) {
    return "Bypass";
  } else {
    return "Error";
  }
}