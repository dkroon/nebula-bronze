#!/bin/sh
# This program runs the Fastq/QseqToTagCountPlugin plugin in TASSEL 3. The output of this
# plugin is tag count files per flow cell lane and a log file RJE20120831

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

####### File Locations

TASSELFOLDER="CHANGE_ME" # Where the TASSEL3 run_pipeline.pl resides
INPUTFOLDER="CHANGE_ME" # Where the input sequence files reside
OUTPUTFOLDER="CHANGE_ME" # Where output of script should go
NODE="1" # Use this for identifying multiple runs of the script for large projects.
KEYFILE="CHANGE_ME" # Location of Keyfile including filename

######## TASSEL Options

ENZYME="ApeKI"
MINCOUNT="1" # Minimum number tag count for tag to be included in the cnt file
MAXGOODREADS="150000000"
MINRAM="-Xms512m" # Minimum RAM for Java Machine
MAXRRAM="-Xmx5g" # Maximum RAM for Java Machine

########
# Variables used by script
#######

DATE=$(date +%Y%m%d) #Date from system in the format YYYYMMDD

########
# Generate the XML Files to run this process
########


  echo '<?xml version="1.0" encoding="UTF-8" standalone="no"?>' > "$OUTPUTFOLDER"/"$PROJECT"_QseqToTagCounts_node_"$NODE".xml
  echo ' <TasselPipeline>' >> "$OUTPUTFOLDER"/"$PROJECT"_QseqToTagCounts_node_"$NODE".xml
  echo '    <fork1>' >> "$OUTPUTFOLDER"/"$PROJECT"_QseqToTagCounts_node_"$NODE".xml
  echo '        <QseqToTagCountPlugin>' >> "$OUTPUTFOLDER"/"$PROJECT"_QseqToTagCounts_node_"$NODE".xml
  echo '            <i>'$INPUTFOLDER'</i>' >> "$OUTPUTFOLDER"/"$PROJECT"_QseqToTagCounts_node_"$NODE".xml
  echo '            <o>'$OUTPUTFOLDER'</o>' >> "$OUTPUTFOLDER"/"$PROJECT"_QseqToTagCounts_node_"$NODE".xml
  echo '            <k>'$KEYFILE'</k>' >> "$OUTPUTFOLDER"/"$PROJECT"_QseqToTagCounts_node_"$NODE".xml
  echo '            <e>'$ENZYME'</e>' >> "$OUTPUTFOLDER"/"$PROJECT"_QseqToTagCounts_node_"$NODE".xml
  echo '            <s>'$MAXGOODREADS'</s>' >> "$OUTPUTFOLDER"/"$PROJECT"_QseqToTagCounts_node_"$NODE".xml
  echo '            <c>'$MINCOUNT'</c>' >> "$OUTPUTFOLDER"/"$PROJECT"_QseqToTagCounts_node_"$NODE".xml
  echo '        </QseqToTagCountPlugin>' >> "$OUTPUTFOLDER"/"$PROJECT"_QseqToTagCounts_node_"$NODE".xml
  echo '    </fork1>' >> "$OUTPUTFOLDER"/"$PROJECT"_QseqToTagCounts_node_"$NODE".xml
  echo '    <runfork1/>' >> "$OUTPUTFOLDER"/"$PROJECT"_QseqToTagCounts_node_"$NODE".xml
  echo '</TasselPipeline>' >> "$OUTPUTFOLDER"/"$PROJECT"_QseqToTagCounts_node_"$NODE".xml


###########
# Record files used in run_pipeline
###########

date | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log
echo "Name of Machine Script is running on:" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log
hostname | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log
echo "Files available for this run:" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log
ls -1 "$INPUTFOLDER"* | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log
echo "MD5SUM of files used to run pipeline:" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log
echo "MD5SUMS will not be run on these files for the Workshop to save time." | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log
#md5sum "$INPUTFOLDER"* | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log
echo "md5sum of tassel jar file:" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log
md5sum "$TASSELFOLDER"/sTASSEL.jar | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log

######## Put the contents of the XML files into the log

echo "Contents of the XML file used to run pipeline:" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log
cat $OUTPUTFOLDER"/"$PROJECT"_QseqToTagCounts_node_"$NODE".xml" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log

echo "Contents of the the shell script used to run pipeline:" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log
cat "$0" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log 
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log
echo "" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log
echo "Starting Pipeline" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log
echo "" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log


#######
# Run TASSEL 
#######
date | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log

echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log
#Run tassel pipeline, redirect stderr to stdout, copy stdout to log file.
"$TASSELFOLDER"/run_pipeline.pl  "$MINRRAM" "$MAXRRAM" -configFile "$OUTPUTFOLDER"/"$PROJECT"_QseqToTagCounts_node_"$NODE".xml 2>&1 | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log
date | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log


echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log
echo "End of Pipeline" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log

########
# Record md5sums of output files in log
########



echo "md5sum of Count File(s)" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log

md5sum   $OUTPUTFOLDER"/*.cnt"| tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log

echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log
date | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log

