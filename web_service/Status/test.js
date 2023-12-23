// const orgName = document.getElementById("orgName");
// const liftName = document.getElementById("liftName");
const container = document.getElementById("container");
// let con = document.getElementsByClassName("item-1")
// let colsArrowUp = document.getElementById("colsArrowUp");
// let colsArrowDown = document.getElementById("colsArrowDown");
// let colsLiftFloor = document.getElementById("colsLiftFloor");
// let tableFloor = document.getElementById("maxLevel");
// let maxLevel = [];
let previousData = null;
let previousCount = 0; // เก็บค่าจำนวนรอบก่อนหน้า
let tableFloorCreated = false; // ตัวแปรสำหรับตรวจสอบว่า Table ถูกสร้างแล้วหรือไม่
let tableArrowUpCreated = false;
let tableArrowDownCreated = false;
let tableLiftFloorCreated = false;

function getData() {
  let loadData = new XMLHttpRequest();
  loadData.onreadystatechange = function () {
    if (loadData.readyState === 4 && loadData.status === 200) {
      let data = JSON.parse(loadData.responseText);

      if (JSON.stringify(data) !== JSON.stringify(previousData)) {
        container.innerHTML = " ";

        for (let key in data) {
          if (data.hasOwnProperty(key)) {
            let item = data[key];
            // console.log(key);
            // console.log("orgName: " + item.org_name);
            // console.log("liftName: " + item.lift_name);
            // console.log("liftName: " + item.max_level);
            let conLift = document.createElement("div");
            let liftName = document.createElement("h4");
            // let floor = document.createElement("table");
            // orgName.innerText = `${item.org_name}`;
            liftName.innerText = `${item.lift_name}`;
            // maxLevel.push(item.max_level);
            maxLevel = item.max_level;
            levelName = item.floor_name;
            sLevelName = levelName.split(",");
            // ids = key;
            // console.log(ids);
            // updateFloorArrow(liftName, maxLevel, sLevelName, data.length);
            // console.log(item);
            // updateFloorArrow(maxLevel);
            // console.log("maxlevel", maxLevel);
            // // console.log("level", levelName);
            // console.log("slevel", sLevelName);
            updateFloorArrow(liftName, maxLevel, sLevelName);
            conLift.classList.add("item-1");
            container.classList.add("container");
            conLift.appendChild(liftName);
            // conLift.appendChild(floor)
            container.appendChild(conLift);
          }
        }
        // updateFloorArrow(maxLevel, sLevelName, data.length);
        previousData = data;
      }
      if (Object.keys(data).length === Object.keys(previousData).length) {
        clearInterval(interval);
      }
    }
  };
  loadData.open(
    "GET",
    "http://52.221.67.113/smartlift/api/org_id.php?id=3",
    true
  );
  loadData.send();
}
// Table ลิฟต์
function createTableFloor(liftName, maxLevel, sLevelName) {
  for (let index in maxLevel) {
    if (maxLevel.hasOwnProperty(index)) {
      let item = maxLevel[index];
      for (p = 0; p < item; p++) {
        let Table = document.createElement("table"); //สร้าง Table
        // คำนวณจำนวน Row และ Column
        let numRows = Math.ceil(maxLevel / 5); // จำนวน Row
        let numCols = Math.ceil(maxLevel / numRows); // จำนวน Column
        let counter = 1; // ตัวแปรนับค่าตัวเลขในช่อง
        for (let i = 0; i < numRows; i++) {
          let row = document.createElement("tr"); // สร้าง Row ใหม่
          Table.appendChild(row);
          for (let j = 0; j < numCols; j++) {
            let cell = document.createElement("td"); // สร้าง Column ใหม่
            // เพิ่มตัวเลขลงใน Column
            if (counter <= sLevelName.length) {
              cell.textContent = sLevelName[counter - 1];
              counter++;
            } else {
              break;
            }
            row.appendChild(cell); // เพิ่ม Column ลงใน Row
          }
          Table.appendChild(row); // เพิ่ม Row ลงใน Table
        }
        // liftName.appendChild(Table);
        liftName.appendChild(Table.cloneNode(true));
        // for (let o = 0; o < liftName.length; o++) {
        //   let liftNames = liftName[o];
        //   let table = Table.cloneNode(true);
        //   liftNames.appendChild(table);
        //   // liftNames.appendChild(Table.cloneNode(true));
        // }
        tableFloorCreated = true; //สร้าง Table แล้ว
      }
    }
  }
}

//ลูกศรขึ้น
function createArrowUp(maxLevel) {
  let tableArrowUp = document.createElement("table");

  for (let i = 0; i < maxLevel; i++) {
    let divArrowUp = document.createElement("div");
    divArrowUp.innerHTML = "&#8679;";

    if (i === 0) {
      divArrowUp.classList.add("column_arrow_none");
    } else {
      divArrowUp.classList.add("column_arrow_UpDown");
    }
    tableArrowUp.appendChild(divArrowUp);
  }
  colsArrowUp.appendChild(tableArrowUp);
  tableArrowUpCreated = true;
}

//ลูกศรลง
function createArrowDown(maxLevel) {
  let tableArrowDown = document.createElement("table");

  for (let i = 0; i < maxLevel; i++) {
    let divArrowDown = document.createElement("div");
    divArrowDown.innerHTML = "&#8681;";

    if (i === maxLevel - 1) {
      divArrowDown.classList.add("column_arrow_none");
    } else {
      divArrowDown.classList.add("column_arrow_UpDown");
    }
    tableArrowDown.appendChild(divArrowDown);
  }
  colsArrowDown.appendChild(tableArrowDown);
  tableArrowDownCreated = true;
}

//ชั้นลิฟต์แนวตั้ง
function createLiftFloor(maxLevel, sLevelName) {
  let counter = maxLevel;
  let tableLiftFloor = document.createElement("table");

  for (let i = 0; i < maxLevel; i++) {
    let divLiftFloor = document.createElement("div");
    if (counter <= sLevelName.length) {
      divLiftFloor.innerText = sLevelName[counter - 1];
      counter--;
    } else {
      break;
    }
    if (i === maxLevel - 2) {
      let mainLift = document.getElementById("overlay");
      let liftdiv = document.createElement("div");
      mainLift.className = "mainLift";
      // <div class="lift" id="lift1" flag="free"></div>
      liftdiv.className = "lift";
      liftdiv.setAttribute("id", "lift");

      //adding flag="free" attribute in <div class="lift" id="lift1" flag="free"></div>
      liftdiv.setAttribute("flag", `free`);

      // <div class="gates" id="gates"></div>
      let gates = document.createElement("div");
      gates.className = "gates";
      gates.setAttribute("id", `gates`);

      // <div class="gate1"></div>
      let gate1 = document.createElement("div");
      gate1.className = "gate1";
      // <div class="gate1"></div> append in this div <div class="gates" id="gates"></div>
      gates.appendChild(gate1);

      // <div class="gate2"></div>
      let gate2 = document.createElement("div");
      gate2.className = "gate2";
      // <div class="gate2"></div> append in this div <div class="gates" id="gates"></div>
      gates.appendChild(gate2);

      // <div class="gates" id="gates"></div> append in this div <div class="lift" id="lift1" flag="free"></div>
      liftdiv.appendChild(gates);

      // <div class="lift" id="lift1" flag="free"></div> append in this div <div class="mainLift"></div>
      mainLift.appendChild(liftdiv);
      divLiftFloor.appendChild(mainLift);
    }

    divLiftFloor.classList.add("num_liftFloor");
    tableLiftFloor.appendChild(divLiftFloor);
  }
  colsLiftFloor.appendChild(tableLiftFloor);
  tableLiftFloorCreated = true;
}

//ฟังช์ชันสร้าง ชั้น, ลูกศร ใหม่เมื่อค่า maxLevel เปลี่ยนแปลง
function updateFloorArrow(liftName, maxLevel, sLevelName) {
  if (maxLevel !== previousCount) {
    // สร้าง Table เมื่อมีการเปลี่ยนแปลงในค่าจำนวนรอบ
    if (tableFloorCreated) {
      // ลบ Table เก่า (ถ้ามี)
      tableFloor.innerHTML = "";
    }
    createTableFloor(liftName, maxLevel, sLevelName); //สร้าง Table

    // if (tableArrowUpCreated) {
    //   colsArrowUp.innerHTML = "";
    // }
    // createArrowUp(maxLevel);

    // if (tableArrowDownCreated) {
    //   colsArrowDown.innerHTML = "";
    // }
    // createArrowDown(maxLevel);

    // if (tableLiftFloorCreated) {
    //   colsLiftFloor.innerHTML = "";
    // }
    // createLiftFloor(maxLevel, sLevelName);
  }
  previousCount = maxLevel; // อัปเดตค่าจำนวนรอบก่อนหน้า
}

function checkLevel(statusString, level) {
  if (level <= 8) {
    value = parseInt("0x" + statusString.substring(0, 2));
    let mask = 1 << (level - 1);
    if (value & (mask != 0)) {
      return true;
    }
  } else if (level <= 16) {
    value = parseInt("0x" + statusString.substring(2, 4));
    let mask = 1 << (level - 9);
    if (value & (mask != 0)) {
      return true;
    }
  } else if (level <= 24) {
    value = parseInt("0x" + statusString.substring(4, 6));
    let mask = 1 << (level - 17);
    if (value & (mask != 0)) {
      return true;
    }
  } else {
    value = parseInt("0x" + statusString.substring(6, 8));
    let mask = 1 << (level - 25);
    if (value & (mask != 0)) {
      return true;
    }
  }
  return false;
}

function checkUpDownArrow(statusString) {
  let value = parseInt("0x" + statusString.substring(2, 4));
  let downArrow = value & (1 << 6);
  let upArrow = value & (1 << 7);
  if (downArrow != 0 && upArrow == 0) {
    return Icon(
      Icons.south,
      (Icon.style.width = "20px"),
      (Icon.style.backgroundColor = "orange")
    );
  } else {
    return Icon(
      Icons.north,
      (Icon.style.width = "20px"),
      (Icon.style.backgroundColor = "green")
    );
  }
}

function showFloorColor(carStatus) {
  let floorCell = document.getElementById("maxLevel");

  if (carStatus !== null && carStatus !== undefined) {
    for (let i = 0; i < floorCell.length; i++) {
      let cellNumber = parseInt(floorCell[i].textContent);
      if (cellNumber === checkLevel()) {
        floorCell[i].classList.add("showColorCarStatus");
      } else {
        floorCell[i].classList.remove("showColorCarStatus");
      }
    }
  }
}

window.onload = getData(); // เรียกใช้ฟังก์ชัน getData() เพื่อโหลดข้อมูลเมื่อหน้าเว็บโหลดเสร็จ
let interval = setInterval(getData, 10000);
// setInterval(getData, 5000); // ใช้ setInterval เพื่อเรียกใช้ฟังก์ชัน getData() ทุก 1 วินาทีเพื่ออัปเดตข้อมูลอัตโนมัติ
