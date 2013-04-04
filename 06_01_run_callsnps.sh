#!/bin/sh
# This program runs the TagsToSNPByAlignmentPlugin plugin in TASSEL 3 according to user modfied parameters to 
# call SNPs and generates a log file RJE 20120829

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
STAGE="UNFILTERED" # These are some suggested stage names: UNFILTERED / MERGEDUPSNPS / HAPMAPFILTERED / BPEC / IMPUTED
BUILD="CHANGE_ME" #Build Designation
BUILDSTAGE="CHANGE_ME" #this is version number

####### File Locations

TASSELFOLDER="CHANGE_ME" # Where the TASSEL3 run_pipeline.pl resides
INPUTFOLDER="CHANGE_ME" # Where the input pivotTBT files reside
OUTPUTFOLDER="CHANGE_ME" # Where output of script should go
INPUTFILE="CHANGE_ME"  # Base name of Input HDF5 files.
TOPMBASE="CHANGE_ME" # location of TOPM file including the base name of the file
PEDIGREE_FILE="CHANGE_ME" #location of the pedigree file

######## TASSEL Options
# Use careful consideration when assigning numbers to these variables. Biology & Genetics really matters here.
MINRAM="-Xms512m" # Minimum RAM for Java Machine
MAXRRAM="-Xmx5g" # Maximum RAM for Java Machine
STARTCHRM="" # Chromosome to start with
ENDCHRM="" # Chromosome to end with
MNF="" # Minimum value of F (inbreeding coeffficient) not tested by default
MNMAF="" # Minimum minor allele frequency. Defaults to 0.01 SNPS that pass either the specified mnMAF or mnMAC (see next) will be output.
MNMAC="" # Minimum minor allele count. Defaults to 10. SNPS that pass either the specified mnMAF or mnMAC (see previous) will be output.
MNLCOV="" # Minimum locus coverage, the proportion of taxa with at least 1 tag at a locus. Default 0.1
INCLRARE="" # not implemented in this script -- placeholder
INCLGAPS="" # not implemented in this script -- placeholder

########
# Variables used by script. Do Not Modify.
#######

DATE=$(date +%Y%m%d) #Date from system in the format YYYYMMDD
CHRM="1" # This is used in looping in the body of the program
CHRME="1"  # This is used in looping in the body of the program
INPUTNAME=$INPUTFOLDER"/"$INPUTFILE"_????????.h5" # This assigns the input name _YYYYMMDD.h5 this is the output.
TOPM=$TOPMBASE"_????????.topm"

########
# Generate the XML Files for each chromosome to run this process
########

CHRM=$STARTCHRM
CHRME=$((ENDCHRM+1))
while [ $CHRM -lt $CHRME ]; do
  echo '<?xml version="1.0" encoding="UTF-8" standalone="no"?>' > "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_chr"$CHRM".xml
  echo ' <TasselPipeline>' >> "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_chr"$CHRM".xml
  echo '    <fork1>' >> "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_chr"$CHRM".xml
  echo '        <TagsToSNPByAlignmentPlugin>' >> "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_chr"$CHRM".xml
  echo '            <i>' $INPUTNAME '</i>' >> "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_chr"$CHRM".xml 
  echo '            <o>'$OUTPUTFOLDER'</o>' >> "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_chr"$CHRM".xml
  echo '            <m>' $TOPM '</m>' >> "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_chr"$CHRM".xml
  echo '            <mnF>'$MNF'</mnF>' >> "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_chr"$CHRM".xml
  echo '            <mnMAF>'$MNMAF'</mnMAF>' >> "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_chr"$CHRM".xml
  echo '            <mnMAC>'$MNMAC'</mnMAC>' >> "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_chr"$CHRM".xml
  echo '            <mnLCov>'$MNLCOV'</mnLCov>' >> "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_chr"$CHRM".xml
  echo '            <s>'$CHRM'</s>' >> "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_chr"$CHRM".xml
  echo '            <e>'$CHRM'</e>' >> "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_chr"$CHRM".xml
 # echo '            <p>'$PEDIGREE_FILE'</p>' >> "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_chr"$CHRM".xml
  echo '        </TagsToSNPByAlignmentPlugin>' >> "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_chr"$CHRM".xml
  echo '    </fork1>' >> "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_chr"$CHRM".xml
  echo '    <runfork1/>' >> "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_chr"$CHRM".xml
  echo '</TasselPipeline>' >> "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_chr"$CHRM".xml
  CHRM=$((CHRM+1))
done

###########
# Record files used in run_pipeline
###########

date | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log
echo "Name of Machine Script is running on:" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log
hostname | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log
echo "Files available for this run:" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log
ls $INPUTNAME | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log
ls $TOPM | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log
# ls $PEDIGREE_FILE | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log
echo "MD5SUM of files used to run pipeline:" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log
md5sum $INPUTNAME | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log
md5sum $TOPM | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log
# md5sum $PEDIGREE_FILE | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log
echo "md5sum of tassel jar file:" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log
md5sum "$TASSELFOLDER"/sTASSEL.jar | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log

######## For Each chromosome put the contents of the XML files into the log

CHRM=$STARTCHRM
CHRME=$((ENDCHRM+1))
while [ $CHRM -lt $CHRME ]; do
  echo "Contents of the XML file for chromosome $CHRM used to run pipeline:" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log
  echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log
  cat $OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_chr"$CHRM".xml" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log
  echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log
  CHRM=$((CHRM+1))
done

echo "Contents of the the shell script used to run pipeline:" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log
cat "$0" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log 
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log
echo "" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log
echo "Starting Pipeline" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log
echo "" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log

#######
# Run TASSEL for each chromosome
#######

date | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log
CHRM=$STARTCHRM
CHRME=$((ENDCHRM+1))
while [ $CHRM -lt $CHRME ]; do
  echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log
  #Run tassel pipeline, redirect stderr to stdout, copy stdout to log file.
  "$TASSELFOLDER"/run_pipeline.pl  "$MINRRAM" "$MAXRRAM" -configFile "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_chr"$CHRM".xml 2>&1 | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log
  date | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log
  CHRM=$((CHRM+1))
done
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log
echo "End of Pipeline" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log

########
# Record md5sums of output files in log
########

######################################  This section will need some help. Specifically with renaming the files to something reasonable and then md5summing them.

echo "md5sum of hapmap File" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log
CHRM=$STARTCHRM
CHRME=$((ENDCHRM+1))
while [ $CHRM -lt $CHRME ]; do
md5sum "$OUTPUTFOLDER"/*chr"$CHRM".hmp.txt.gz | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log
  CHRM=$((CHRM+1))
done
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log
date | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log

########
# Create zip archive of hapmap files, log, name list and release notes
########

#zip -D "$OUTPUTFOLDER"/"$PROJECT"_"$STAGE"_"$BUILD"_"$BUILDSTAGE"_"$DATE".zip "$OUTPUTFOLDER"/*.hmp.txt.gz "$PEDIGREE_FILE" "$RELEASENOTES" "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log
