echo "========================================="
echo "Bash script for using command line version HeterogeneityCAD module"
echo "Script written by Yang Hou, BS candidate, Purdue University and Jayender Jagadeesan, Brigham and Women's Hospital"
echo "========================================="


#select path to the module you want to run
modulepath="/PATH-TO-HeterogeneityCAD-script/HeterogeneityCAD.py"

#select path to slicer binary excutable
slicerpath="/PATH-TO-Slicer4-Superbuild/Slicer-build/Slicer"

#select path to the data
#assume that the data is /PATH-TO-DATA/Casei/Scene/Pre-tumor-vol.nrrd etc.
#compute the heterogeneity for pre-tumor-vol.nrrd, First-tumor-vol.nrrd, Fourth-tumor-vol.nrrd, Subtract-first-vol.nrrd, Subtract-fourth-vol.nrrd, T2-tumor-vol.nrrd
#tumorlabelmap is in Tumor-label.nrrd, heterogeneity is defined for this ROI
basecasepath="/PATH-TO-DATA/Case"


#input the total number of volumes. Attention: number of volumes should be equal to number of LabelMap
#number = number of cases
number=1

#count is the number of cases missing
count=0

#skipcases is the number of cases skipped
skipcases=0


#set for loop to create array of path for volumes,LabelMaps and destinations
volumes=()
labels=()
destinations=()
volumesname=()
labelsname=()

for (( i=0; i<$number; i++ ))
do
  let ii=i+skipcases
  prevol=$basecasepath$ii"/Scene/Pre-tumor-vol.nrrd"
  firstvol=$basecasepath$ii"/Scene/First-tumor-vol.nrrd"
  fourthvol=$basecasepath$ii"/Scene/Fourth-tumor-vol.nrrd"
  subtractfirstvol=$basecasepath$ii"/Scene/Subtract-first-vol.nrrd"
  subtractfourthvol=$basecasepath$ii"/Scene/Subtract-fourth-vol.nrrd"
  t2vol=$basecasepath$ii"/Scene/T2-tumor-vol.nrrd"
  
  tumorlabel=$basecasepath$ii"/Scene/Tumor-label.nrrd"
  destination=$basecasepath$ii"/Scene/HeterogeneityCAD.csv"
  
  if [[ -e $prevol ]] && [[ -e $firstvol ]] && [[ -e $fourthvol ]] && [[ -e $subtractfirstvol ]] && [[ -e $subtractfourthvol ]] && [[ -e $t2vol ]] && [[ -e $tumorlabel ]] 
  then
    prevolumes[i]=$prevol
    firstvolumes[i]=$firstvol
    fourthvolumes[i]=$fourthvol
    subtractfirstvol[i]=$subtractfirstvol
    subtractfourthvol[i]=$subtractfourthvol
    #t2vol[i]=$t2vol
    
    labels[i]=$tumorlabel
    destinations[i]=$destination
    
  else
    echo $basecasepath$ii "does not exist"
    let count=$count+1
  fi
  
done

let truenumber=$number-$count

#calling module
$slicerpath --no-main-window --python-script $modulepath $truenumber ${prevolumes[*]} ${labels[*]} ${destinations[*]} 

#calling module
$slicerpath --no-main-window --python-script $modulepath $truenumber ${firstvolumes[*]} ${labels[*]} ${destinations[*]} 

#calling module
$slicerpath --no-main-window --python-script $modulepath $truenumber ${fourthvolumes[*]} ${labels[*]} ${destinations[*]} 

#calling module
$slicerpath --no-main-window --python-script $modulepath $truenumber ${subtractfirstvol[*]} ${labels[*]} ${destinations[*]} 

#calling module
$slicerpath --no-main-window --python-script $modulepath $truenumber ${subtractfourthvol[*]} ${labels[*]} ${destinations[*]} 

#calling module
#$slicerpath --no-main-window --python-script $modulepath $truenumber ${t2vol[*]} ${labels[*]} ${destinations[*]} 

echo "finally complete"


