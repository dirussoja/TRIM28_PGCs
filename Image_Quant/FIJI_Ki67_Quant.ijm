\\This script optimized for a 4-channel image with 647/594/488/405 wavelengths. For quant, Ki67 is in 647 and VASA (PGC marker) is in 488. DAPI is in 405. 

name=getTitle();
selectWindow(name);
stack = getNumber("Select which z-stack you would like to use (one only)", 2);
run("Z Project...", "start=" + stack + " stop=" + stack + " projection=[Max Intensity]");
run("Split Channels");

magenta="C1-MAX_"+name
vasa="C3-MAX_"+name

selectWindow(magenta);
run("Brightness/Contrast...");
waitForUser("manually adjust the brightness and contrast");

selectWindow(vasa);
run("Brightness/Contrast...");
waitForUser("manually adjust the brightness and contrast");

run("Merge Channels...", "c2=" + vasa + " c6=" + magenta  + " create");
merge=getTitle();
selectWindow(merge);
run("Duplicate...", "duplicate channels=2");
ki67=getTitle();
run("Set Measurements...", "area mean integrated display redirect=" + ki67 + " decimal=3");
selectImage(merge);
run("ROI Manager...");
setTool("freehand");
waitForUser("Select all VASA+ cells using freehand ROI too. Add by pressing t after each circle.");

count=roiManager("count");

array=newArray(count);
  for (i=0; i<array.length; i++) {
      array[i] = i;
  }
roiManager("select", array);
roiManager("Measure");
waitForUser("Copy to Excel.");
roiManager("Delete");

run("ROI Manager...");
setTool("freehand");
selectWindow(merge);
waitForUser("Select 5-10 Ki67 negative cells. Add by pressing t after each circle.");

count=roiManager("count");

array=newArray(count);
  for (i=0; i<array.length; i++) {
      array[i] = i;
  }

roiManager("Select", array);
roiManager("Measure");
waitForUser("Copy to Excel. This press OK to close all images and end macro.");
roiManager("Delete");
run("Close All");
