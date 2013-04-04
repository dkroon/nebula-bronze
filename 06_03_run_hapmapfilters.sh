#!/bin/sh
# This program runs the GBSHapMapFiltersPlugin plugin in TASSEL 3 according to user modfied parameters
# and generates a log file RJE 20120829

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
# This program depends on TASSEL 3 and md5sum 
########

########
# User Modified Parameters
########

######## Meta Information

PROJECT=$USER # PI  or Project NAME
STAGE="HAPMAPFILTERED" #UNFILTERED / MERGEDUPSNPS / HAPMAPFILTERED / BPEC / IMPUTED
BUILD="CHANGE_ME" #Build Designation
BUILDSTAGE="CHANGE_ME" #this is version number

####### File Locations


TASSELFOLDER="CHANGE_ME" # Where the TASSEL3 run_pipeline.pl resides
INPUTFOLDER="CHANGE_ME" # Where the input hapmap files reside
INPUTBASENAME=$PROJECT"_MERGEDUPSNPS_"$BUILD"_"$BUILDSTAGE"_chr" # Base name of input files. This precedes $CHRM.hmp.txt.gz 
OUTPUTFOLDER="CHANGE_ME" # Where output of script should go



######## TASSEL Options
# Choose the parameters below carefully. Biology and Genetics matter.

MINRAM="-Xms512m" # Minimum RAM for Java Machine
MAXRRAM="-Xmx5g" # Maximum RAM for Java Machine
STARTCHRM="1" # Chromosome to start with
ENDCHRM="12" # Chromosome to end with
#PEDIGREE_FILE="CHANGE_ME"
MNTCOV="0.05" # Minimum taxa coverage (default: no filter)
MNSCOV="0.2" #  Minimum presence (default: no filter)
MNF="-2.0" #  Minimum F (inbreeding coefficient) (default -2.0 = no filter)
MNMAF="0" #  Minimum minor allele frequency (default: 0.0 = no filter)
MXMAF="1" #  Maximum minor allele frequency (default: 1.0 = no filter)
# HLD     Filter for high LD This is a switch comment on / off below
MNR2="0.01" # -mnR2    Minimum R-square value for the LD filter (default: 0.01)
MNBONP="0.01" #  -mnBonP  Minimum Bonferroni-corrected p-value for the LD filter (default: 0.01)


########
# Variables used by script. Do Not Modify. Except to uncomment lines in the XML generation section.
#######

DATE=$(date +%Y%m%d) #Date from system in the format YYYYMMDD
CHRM="1" # This is used in looping in the body of the program
CHRME="1"  # This is used in looping in the body of the program

########
# Generate the XML Files for each chromosome to run this process
########

CHRM=$STARTCHRM
CHRME=$((ENDCHRM+1))
while [ $CHRM -lt $CHRME ]; do
  echo '<?xml version="1.0" encoding="UTF-8" standalone="no"?>' > "$OUTPUTFOLDER"/"$PROJECT"_"$STAGE"_chr"$CHRM".xml
  echo ' <TasselPipeline>' >> "$OUTPUTFOLDER"/"$PROJECT"_"$STAGE"_chr"$CHRM".xml
  echo '    <fork1>' >> "$OUTPUTFOLDER"/"$PROJECT"_"$STAGE"_chr"$CHRM".xml
  echo '        <GBSHapMapFiltersPlugin>' >> "$OUTPUTFOLDER"/"$PROJECT"_"$STAGE"_chr"$CHRM".xml
  echo '            <hmp>'$INPUTFOLDER'/'$INPUTBASENAME''$CHRM'.hmp.txt.gz</hmp>' >> "$OUTPUTFOLDER"/"$PROJECT"_"$STAGE"_chr"$CHRM".xml 
  echo '            <o>'$OUTPUTFOLDER'/'$PROJECT'_'$STAGE'_'$BUILD'_'$BUILDSTAGE'_chr'$CHRM'.hmp.txt.gz</o>' >> "$OUTPUTFOLDER"/"$PROJECT"_"$STAGE"_chr"$CHRM".xml
 # echo '            <p>'$PEDIGREE_FILE'</p>' >> "$OUTPUTFOLDER"/"$PROJECT"_"$STAGE"_chr"$CHRM".xml
  echo '            <mnSCov>'$MNSCOV'</mnSCov>' >> "$OUTPUTFOLDER"/"$PROJECT"_"$STAGE"_chr"$CHRM".xml
  echo '            <mnTCov>'$MNTCOV'</mnTCov>' >> "$OUTPUTFOLDER"/"$PROJECT"_"$STAGE"_chr"$CHRM".xml
#  echo '            <mnF>'$MNF'</mnF>' >> "$OUTPUTFOLDER"/"$PROJECT"_"$STAGE"_chr"$CHRM".xml
  echo '            <mnMAF>'$MNMAF'</mnMAF>' >> "$OUTPUTFOLDER"/"$PROJECT"_"$STAGE"_chr"$CHRM".xml
  echo '            <mxMAF>'$MXMAF'</mxMAF>' >> "$OUTPUTFOLDER"/"$PROJECT"_"$STAGE"_chr"$CHRM".xml
  echo '            <hLD></hLD>' >> "$OUTPUTFOLDER"/"$PROJECT"_"$STAGE"_chr"$CHRM".xml
  echo '            <mnR2>'$MNR2'</mnR2>' >> "$OUTPUTFOLDER"/"$PROJECT"_"$STAGE"_chr"$CHRM".xml
  echo '            <mnBonP>'$MNBONP'</mnBonP>' >> "$OUTPUTFOLDER"/"$PROJECT"_"$STAGE"_chr"$CHRM".xml
  echo '            <sC>'$CHRM'</sC>' >> "$OUTPUTFOLDER"/"$PROJECT"_"$STAGE"_chr"$CHRM".xml
  echo '            <eC>'$CHRM'</eC>' >> "$OUTPUTFOLDER"/"$PROJECT"_"$STAGE"_chr"$CHRM".xml
  echo '        </GBSHapMapFiltersPlugin>' >> "$OUTPUTFOLDER"/"$PROJECT"_"$STAGE"_chr"$CHRM".xml
  echo '    </fork1>' >> "$OUTPUTFOLDER"/"$PROJECT"_"$STAGE"_chr"$CHRM".xml
  echo '    <runfork1/>' >> "$OUTPUTFOLDER"/"$PROJECT"_"$STAGE"_chr"$CHRM".xml
  echo '</TasselPipeline>' >> "$OUTPUTFOLDER"/"$PROJECT"_"$STAGE"_chr"$CHRM".xml
  CHRM=$((CHRM+1))
done

###########
# Record files used in run_pipeline
###########

date | tee -a "$OUTPUTFOLDER"/"$PROJECT"_"$STAGE"_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_"$STAGE"_"$DATE".log
echo "Name of Machine Script is running on:" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_"$STAGE"_"$DATE".log
hostname | tee -a "$OUTPUTFOLDER"/"$PROJECT"_"$STAGE"_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_"$STAGE"_"$DATE".log
echo "Files available for this run:" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_"$STAGE"_"$DATE".log
CHRM=$STARTCHRM
CHRME=$((ENDCHRM+1))
while [ $CHRM -lt $CHRME ]; do
  ls -1 "$INPUTFOLDER"/"$INPUTBASENAME""$CHRM."hmp.txt.gz | tee -a "$OUTPUTFOLDER"/"$PROJECT"_"$STAGE"_"$DATE".log
  CHRM=$((CHRM+1))
done
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_"$STAGE"_"$DATE".log
echo "MD5SUM of files used to run pipeline:" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_"$STAGE"_"$DATE".log
CHRM=$STARTCHRM
CHRME=$((ENDCHRM+1))
while [ $CHRM -lt $CHRME ]; do
  md5sum "$INPUTFOLDER"/"$INPUTBASENAME""$CHRM."hmp.txt.gz | tee -a "$OUTPUTFOLDER"/"$PROJECT"_"$STAGE"_"$DATE".log
  CHRM=$((CHRM+1))
done
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_"$STAGE"_"$DATE".log
echo "md5sum of tassel jar file:" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_"$STAGE"_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_"$STAGE"_"$DATE".log
md5sum "$TASSELFOLDER"/sTASSEL.jar | tee -a "$OUTPUTFOLDER"/"$PROJECT"_"$STAGE"_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_"$STAGE"_"$DATE".log

######## For Each chromosome put the contents of the XML files into the log

CHRM=$STARTCHRM
CHRME=$((ENDCHRM+1))
while [ $CHRM -lt $CHRME ]; do
  echo "Contents of the XML file for chromosome $CHRM used to run pipeline:" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_"$STAGE"_"$DATE".log
  echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_"$STAGE"_"$DATE".log
  cat $OUTPUTFOLDER"/"$PROJECT"_"$STAGE"_chr"$CHRM".xml" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_"$STAGE"_"$DATE".log
  echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_"$STAGE"_"$DATE".log
  CHRM=$((CHRM+1))
done

echo "Contents of the the shell script used to run pipeline:" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_"$STAGE"_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_"$STAGE"_"$DATE".log
cat "$0" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_"$STAGE"_"$DATE".log 
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_"$STAGE"_"$DATE".log
echo "" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_"$STAGE"_"$DATE".log
echo "Starting Pipeline" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_"$STAGE"_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_"$STAGE"_"$DATE".log
echo "" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_"$STAGE"_"$DATE".log

#######
# Run TASSEL for each chromosome
#######

date | tee -a "$OUTPUTFOLDER"/"$PROJECT"_"$STAGE"_"$DATE".log
CHRM=$STARTCHRM
CHRME=$((ENDCHRM+1))
while [ $CHRM -lt $CHRME ]; do
  echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_"$STAGE"_"$DATE".log
  #Run tassel pipeline, redirect stderr to stdout, copy stdout to log file.
  "$TASSELFOLDER"/run_pipeline.pl  "$MINRRAM" "$MAXRRAM" -configFile "$OUTPUTFOLDER"/"$PROJECT"_"$STAGE"_chr"$CHRM".xml 2>&1 | tee -a "$OUTPUTFOLDER"/"$PROJECT"_"$STAGE"_"$DATE".log
  date | tee -a "$OUTPUTFOLDER"/"$PROJECT"_"$STAGE"_"$DATE".log
  CHRM=$((CHRM+1))
done
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_"$STAGE"_"$DATE".log
echo "End of Pipeline" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_"$STAGE"_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_"$STAGE"_"$DATE".log

########
# Record md5sums of output files in log
########

echo "md5sum of hapmap File" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_"$STAGE"_"$DATE".log
CHRM=$STARTCHRM
CHRME=$((ENDCHRM+1))
while [ $CHRM -lt $CHRME ]; do
md5sum "$OUTPUTFOLDER"/*chr"$CHRM".hmp.txt.gz | tee -a "$OUTPUTFOLDER"/"$PROJECT"_"$STAGE"_"$DATE".log
  CHRM=$((CHRM+1))
done
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_"$STAGE"_"$DATE".log
date | tee -a "$OUTPUTFOLDER"/"$PROJECT"_"$STAGE"_"$DATE".log

########
# Create zip archive of hapmap files, log, name list and release notes
########

#zip -D "$OUTPUTFOLDER"/"$PROJECT"_"$STAGE"_"$BUILD"_"$BUILDSTAGE"_"$DATE".zip "$OUTPUTFOLDER"/*.hmp.txt.gz "$PEDIGREE_FILE" "$RELEASENOTES" "$OUTPUTFOLDER"/"$PROJECT"_"$STAGE"_"$DATE".log | tee -a "$OUTPUTFOLDER"/"$PROJECT"_"$STAGE"_"$DATE".log
