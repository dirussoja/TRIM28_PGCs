#The below script is written in ImageJ macro language. It is optimized for images taken as a z-stack with 4 channels on a LSM880.

//The first lines of code will be to select a good Z-stack, to split and re-merge the channels. This should prepare a z-stack for quantification. 
window = getTitle();
stack = getNumber("Select the Z-slice you wish to quantify.", 2);
run("Z Project...", "start=" + stack + " stop=" + stack + " projection=[Max Intensity]");
max_project = getTitle();
  //splits the image and merges them back together to create the image from which everything will be quantified.
selectWindow(max_project);
run("Split Channels");
selectWindow("C3-" + max_project);
run("Brightness/Contrast...");
waitForUser("Adjust VASA", "Adjust VASA.");
selectWindow("C4-" + max_project);
run("Grays");
run("Brightness/Contrast...");
waitForUser("Adjust DAPI", "Adjust DAPI.");
run("Merge Channels...", "c1=C2-" + max_project + " c2=C3-" + max_project + " c3=C4-" + max_project + " c6=C1-" + max_project + " create");
merged = getTitle();
run("Set Measurements...", "area mean display redirect=None decimal=3");
  //We now have a merged master image to work from. We will get snaps of both TFAP2C and Nanog Windows to quantify. 
selectWindow(merged);
run("Duplicate...", "duplicate channels=4");
run("Magenta");
tfap2c = getTitle();
selectWindow(merged);
run("Duplicate...", "duplicate channels=1");
run("Cyan");
nanog = getTitle();
  //The next steps will be user-guided thresholding of each of these marks
selectWindow(tfap2c);
run("Duplicate...");
tfap2c_threshold = getTitle();
selectWindow(tfap2c_threshold);
run("Threshold...");
waitForUser("Adjust Threshold", "Press Apply when Done");
run("Despeckle");
run("Remove Outliers...", "radius=8 threshold=50 which=Bright");
run("Watershed");
selectWindow(tfap2c_threshold);
run("Analyze Particles...", "size=15.00-Infinity clear overlay add");
selectWindow(merged);
  //run("Duplicate...", "duplicate channels=1,3");
run("Make Substack...", "channels=2,4");
setTool("freehand");
tfap2c_check = getTitle();
selectWindow(tfap2c_check);
roiManager("Show None");
roiManager("Show All");
waitForUser("Check Cells", "Make sure the thresholding selected what you want hit OK to continue");
selectWindow(tfap2c_check);
run("Set Measurements...", "area mean display redirect=" + tfap2c +" decimal=3");
count=roiManager("count");

array=newArray(count);
  for (i=0; i<array.length; i++) {
      array[i] = i;
  }
roiManager("select", array);
roiManager("Measure");
waitForUser("TFAP2C Mean Intensity Results. Copy to Excel.");
run("Clear Results");
close();
  //Now the same series for Nanog. 
selectWindow(merged);
run("Make Substack...", "channels=1,2");
nanog_check = getTitle();
selectWindow(nanog_check);
roiManager("Show None");
roiManager("Show All");
waitForUser("Check Cells", "Make sure the thresholding selected what you want hit OK to continue");
count=roiManager("count");

array=newArray(count);
  for (i=0; i<array.length; i++) {
      array[i] = i;
  }
roiManager("select", array);
run("Set Measurements...", "area mean display redirect=" + nanog +" decimal=3");
roiManager("Measure");
waitForUser("Nanog mean Intensity Results. Copy to Excel.");
run("Clear Results");
roiManager("Delete");
selectWindow(nanog_check);
close();
  //Now the series for DAPI, which will be the "background" number. 
selectWindow(merged);
run("Duplicate...", "duplicate channels=3");
run("Grays");
dapi=getTitle();
run("Duplicate...");
dapi_threshold = getTitle();
selectWindow(dapi_threshold);
run("Threshold...");
waitForUser("Adjust Threshold", "Press Apply when Done");
run("Despeckle");
run("Remove Outliers...", "radius=10 threshold=50 which=Bright");
run("Watershed");
run("Erode");
run("Erode");
imageCalculator("Subtract create", dapi_threshold, tfap2c_threshold);
run("Analyze Particles...", "size=15.00-Infinity clear overlay add");
dapi_only=getTitle();
//
selectWindow(dapi);
roiManager("Show None");
roiManager("Show All");
waitForUser("Check Cells", "Make sure the thresholding selected what you want hit OK to continue");
//
selectWindow(merged);
run("Make Substack...", "channels=2,4");
pgc_check=getTitle();
selectWindow(pgc_check);
roiManager("Show None");
roiManager("Show All");
waitForUser("Check Cells", "Make sure the thresholding selected what you want hit OK to continue");
count=roiManager("count");

array=newArray(count);
  for (i=0; i<array.length; i++) {
      array[i] = i;
  }

roiManager("select", array);
run("Set Measurements...", "area mean display redirect=" + tfap2c + " decimal=3");
roiManager("Measure");
waitForUser("TFAP2C Background. Copy to Excel.");
run("Clear Results");
run("Set Measurements...", "area mean display redirect=" + nanog + " decimal=3");
roiManager("Measure");
waitForUser("Nanog Background. Copy to Excel.");
roiManager("Delete");
run("Clear Results");
run("Close All");
