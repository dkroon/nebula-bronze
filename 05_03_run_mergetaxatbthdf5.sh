#!/bin/sh
# This program runs the ModifyTBTHDF5Plugin plugin in TASSEL 3 to merge taxa by library prep id in TBTHDF5 according to user modfied parameters
# and generates a log file RJE 20120831

#    		Copyright 2012 Robert J. Elshire
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

########
# This program depends on TASSEL 3, md5sum 
########

########
# User Modified Parameters
########

######## Meta Information

PROJECT=$USER # PI  or Project NAME

####### File Locations

TASSELFOLDER="CHANGE_ME" # Where the TASSEL4 run_pipeline.pl resides
INPUTFOLDER="CHANGE_ME" # Where the input sequence files reside
OUTPUTFOLDER="CHANGE_ME" # Where output of script should go
INPUTFILE="CHANGE_ME" # Base name of Input HDF5 files. (outputfile from 05_02_run_mergetbthdf5.sh)
OUTPUTFILE="CHANGE_ME" # Base name of Output HDF5 file.
######## TASSEL Options

MINRAM="-Xms512m" # Minimum RAM for Java Machine
MAXRRAM="-Xmx5g" # Maximum RAM for Java Machine

########
# Variables used by script. Do Not Modify.
#######

DATE=$(date +%Y%m%d) #Date from system in the format YYYYMMDD

########
# Generate the XML Files for each node to run this process
########


INPUTNAME=$INPUTFOLDER'/'$INPUTFILE'_????????.h5' # This assigns the input name TBT_Node#_YYYYMMDD.h5 this is the output from run_mergetbthdf5.

  echo '<?xml version="1.0" encoding="UTF-8" standalone="no"?>' > "$OUTPUTFOLDER"/"$PROJECT"_MERGETaxaTBTHDF5.xml
  echo ' <TasselPipeline>' >> "$OUTPUTFOLDER"/"$PROJECT"_MERGETaxaTBTHDF5.xml
  echo '    <fork1>' >> "$OUTPUTFOLDER"/"$PROJECT"_MERGETaxaTBTHDF5.xml
  echo '        <ModifyTBTHDF5Plugin>' >> "$OUTPUTFOLDER"/"$PROJECT"_MERGETaxaTBTHDF5.xml
  echo '            <o>'$OUTPUTFOLDER'/'$OUTPUTFILE'_'$DATE'.h5</o>' >> "$OUTPUTFOLDER"/"$PROJECT"_MERGETaxaTBTHDF5.xml
  echo '            <c></c>' >> "$OUTPUTFOLDER"/"$PROJECT"_MERGETaxaTBTHDF5.xml
  echo '            <L>FAKELOG_DELETEME.txt</L>' >> "$OUTPUTFOLDER"/"$PROJECT"_MERGETaxaTBTHDF5.xml
  echo '        </ModifyTBTHDF5Plugin>' >> "$OUTPUTFOLDER"/"$PROJECT"_MERGETaxaTBTHDF5.xml
  echo '    </fork1>' >> "$OUTPUTFOLDER"/"$PROJECT"_MERGETaxaTBTHDF5.xml
  echo '    <runfork1/>' >> "$OUTPUTFOLDER"/"$PROJECT"_MERGETaxaTBTHDF5.xml
  echo '</TasselPipeline>' >> "$OUTPUTFOLDER"/"$PROJECT"_MERGETaxaTBTHDF5.xml

###########
# Copy the Output file of the mergetbthdf5 to the run directory. This plugin operates on one file only. We'll use the copy made next.
###########

cp $INPUTNAME $OUTPUTFOLDER"/"$OUTPUTFILE"_"$DATE".h5"


###########
# Record files used in run_pipeline
###########

date | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MERGETAXATBTHDF5_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MERGETAXATBTHDF5_"$DATE".log
echo "Name of Machine Script is running on:" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MERGETAXATBTHDF5_"$DATE".log
hostname | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MERGETAXATBTHDF5_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MERGETAXATBTHDF5_"$DATE".log
echo "Files available for this run:" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MERGETAXATBTHDF5_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MERGETAXATBTHDF5_"$DATE".log
ls -1 "$OUTPUTFOLDER"/"$OUTPUTFILE"_"$DATE".h5 | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MERGETAXATBTHDF5_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MERGETAXATBTHDF5_"$DATE".log
echo "MD5SUM of files used to run pipeline:" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MERGETAXATBTHDF5_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MERGETAXATBTHDF5_"$DATE".log
md5sum "$OUTPUTFOLDER"/"$OUTPUTFILE"_"$DATE".h5 | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MERGETAXATBTHDF5_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MERGETAXATBTHDF5_"$DATE".log
echo "md5sum of tassel jar file:" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MERGETAXATBTHDF5_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MERGETAXATBTHDF5_"$DATE".log
md5sum "$TASSELFOLDER"/sTASSEL.jar | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MERGETAXATBTHDF5_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MERGETAXATBTHDF5_"$DATE".log

######## Put the contents of the XML files into the log

echo "Contents of the XML file for node $NODE used to run pipeline:" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MERGETAXATBTHDF5_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MERGETAXATBTHDF5_"$DATE".log
cat $OUTPUTFOLDER"/"$PROJECT"_MERGETaxaTBTHDF5.xml" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MERGETAXATBTHDF5_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MERGETAXATBTHDF5_"$DATE".log

echo "Contents of the the shell script used to run pipeline:" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MERGETAXATBTHDF5_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MERGETAXATBTHDF5_"$DATE".log
cat "$0" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MERGETAXATBTHDF5_"$DATE".log 
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MERGETAXATBTHDF5_"$DATE".log
echo "" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MERGETAXATBTHDF5_"$DATE".log
echo "Starting Pipeline" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MERGETAXATBTHDF5_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MERGETAXATBTHDF5_"$DATE".log
echo "" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MERGETAXATBTHDF5_"$DATE".log


#######
# Run TASSEL 
#######

  echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MERGETAXATBTHDF5_"$DATE".log
  #Run tassel pipeline, redirect stderr to stdout, copy stdout to log file.
  "$TASSELFOLDER"/run_pipeline.pl  "$MINRRAM" "$MAXRRAM" -configFile "$OUTPUTFOLDER"/"$PROJECT"_MERGETaxaTBTHDF5.xml 2>&1 | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MERGETAXATBTHDF5_"$DATE".log
date | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MERGETAXATBTHDF5_"$DATE".log


echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MERGETAXATBTHDF5_"$DATE".log
echo "End of Pipeline" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MERGETAXATBTHDF5_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MERGETAXATBTHDF5_"$DATE".log

########
# Record md5sums of output files in log
########



echo "md5sum of TBTHDF5 File" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MERGETAXATBTHDF5_"$DATE".log

md5sum   $OUTPUTFOLDER"/"$OUTPUTFILE"_"$DATE".h5"| tee -a "$OUTPUTFOLDER"/"$PROJECT"_MERGETAXATBTHDF5_"$DATE".log

echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MERGETAXATBTHDF5_"$DATE".log
date | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MERGETAXATBTHDF5_"$DATE".log

