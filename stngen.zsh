#!/bin/zsh
#
# Using zsh because? I think it was that at the time, bash was not able to do
# the things desired, or zsh was more advanced in certain things than bash. 
# I think it was that zsh can do real arithmmetic with $(( )) while bash
# only does integer arithmetic.
#
# 14.5		-22.9467	10 0 0 ML	Walvis Bay
# 17.8583	-32.8267	10 0 0 TL	C. Columbine
#
# generate station lines from Columbine to Walvis Bay @ 30 mile intervals
# at an angle 
#
# echo $TOPO

# check if there is information from the configuration file for all 

TITLE=${TITLE-"Campaign Name Survey Grid"}
STATIONSFILE=${STATIONSFILE-allstns.stns}

# if [ -s $STATIONSFILE ]; then
# 	echo -n "$STATIONSFILE exists. Overwrite? (yN) " 
# 	read ANS
# 	[ "$ANS" = "y" -o "$ANS" = "Y" ] || exit 
# fi

# "> filename" does not perform as expected in zsh
rm -f dummy $STATIONSFILE 
touch $STATIONSFILE 

# echo done here

TOPO=${TOPO-/usr/local/bathy/etopo1/ETOPO1_Ice_g_gmt4-.grd}
[ ! -e $TOPO ] && { echo Topo file $TOPO not found ; exit 1 ; }

NMILE=1.85325 # km

# defines line spacing
LSPACENM=${LSPACENM-5.0}
LSPACE=$((LSPACENM*NMILE))

# defines station spacing
SSPACENM=${SSPACENM-0.5}
SSPACE=$((SSPACENM*NMILE))

# defines line orientation (compass direction)
# ANGLE=254
# ANGLE=245
ANGLE=${ANGLE-125}

# 
# Not appropriate to have stngen.zsh cull stations according to depth
MAXD=91501
MIND=-9950

# count for station labels starts at A
# COUNT=58 # EE
# COUNT=65
COUNT=0

# Range=-R0/20/-36/-10 
Range=${Range--R20/35/-36.5/-20.5}
Proj=${Proj--JM5i}

# defines area over which to calculate stations, NUP lines north of
# origin, NDOWN lines south of origin
# NUP=7.0
# NDOWN=18.0
NUP=${NUP--4}
NDOWN=${NDOWN-120}


# defines number of stations in a line
NSTN=${NSTN-411}

# for a point near Walvis Bay
# ORIGIN=14.5/$((-0.25-22.9467))
# REMOTE=17.8583/-32.8267

# for a point near cape peninsula
# -32.7442 16.4333
# ORIGIN=16.45/-28.6333333    
# REMOTE=16.433/-32.7442
# 
# near Maputo to Port Elizabeth	
ORIGIN=${ORIGIN-32.57703200/-25.96559000}
REMOTE=${REMOTE-25.60000000/-33.96666667}

# print  the configuration
if false; then 
	echo Using these values: 
	echo TITLE=$TITLE
	echo TOPO=$TOPO
	echo STATIONSFILE=$STATIONSFILE
	echo LSPACENM=$LSPACENM
	echo SSPACENM=$SSPACENM
	echo NUP=$NUP
	echo NDOWN=$NDOWN
	echo NSTN=$NSTN
	echo ORIGIN=$ORIGIN
	echo REMOTE=$REMOTE
	echo ANGLE=$ANGLE
	echo MAXDEPTH=$MAXDEPTH
	echo MINDEPTH=$MINDEPTH
	echo DEPART=$DEPART
	echo ARRIVE=$ARRIVE
	echo TIMEONSTATION=$TIMEONSTATION
	echo SPEED=$SPEED
	echo MAXCAST=$MAXCAST
	echo SAMPLES=$SAMPLES
	echo Range=$Range
	echo Proj=$Proj
fi

#
# generate all points on the coast which lie in the range
# using pscoast
pscoast $Range $Proj -Dh -A0/0/1 -M -W | egrep -v ">|#" > stngen.coast
#
# Using grdcontour is not working
# generate a contour to use if we want to start at a particular depth
# cat << ENDIN > contours.cnt
# 30	C
# ENDIN
# do a little dance to get rid of the postscript output, and pass the
# contours through egrep instead of directly into stngen.coast
# ( grdcontour $Range $Proj -fog -D/dev/stderr -m -Ccontours.cnt $TOPO > /dev/null ) 2>&1 | egrep -v ">|#" > stngen.coast

#
# output a little story at the top
(
  echo "## $TITLE"
  echo "## Station Listing"
  echo "## Stations are nominally "`echo $((SSPACE/NMILE)) | awk '{print int($1*10 + 0.5)/10}'`" n.m. apart."
  echo "## Lines are nominally "`echo $(($LSPACE/$NMILE)) | awk '{print int($1*10 + 0.5)/10}'`" n.m. apart."
  echo "## Station Lines are identified by a line with "
  ########echo "## \"Line\" LineName CentrePos"
  echo "## \"Line\" LineName CentrePos CoastPnt"
  echo "## Station positions are identified by a line with "
  echo "## Longitude Latitude DistFromCoast Depth StationNumber StationLabel"
  ##echo "## (where stationname may be optional? where stationname is a number?)"
) | tee -a $STATIONSFILE

# 
# from a point $ORIGIN (-C) generate points within a range (-L)
# towards another point (-E) spacing them a distance (-G) apart
project -Q						\
	-C$ORIGIN					\
	-E$REMOTE					\
	-L$((-LSPACE*NUP))/$((LSPACE*NDOWN))	\
	-G$LSPACE > stngen.centres

DIST0=`head -n1 stngen.centres | awk '{print $3}'`

cat stngen.centres | while read line
do
	CENTRE=$(echo $line | awk '{print $1 "/" $2}')
	DIST=$(echo $line | awk '{print $3}')
#
# for each of these points (corresponding to lines) generate a line number
	(( COUNT++ ))
	LABEL=`echo $COUNT | gawk -f base26.awk `
	####echo "# Line $LABEL \t$CENTRE"
	# echo $CENTRE|sed "s-/- -" 
	# project -C$CENTRE -A$ANGLE -L-70/500 -G$((10*$NMILE)) -Q
#
# for each point (-C) find the closest coastal point along a line
# perpendicular to topography (-A)
	COAST=`project stngen.coast -C$CENTRE -A$ANGLE -M |
		awk '	BEGIN{min=99999}
			{a=$4<0?-$4:$4; if (a<min){min=a; p=$5 "/" $6}}
			END{print p}' `

	echo "# Line $LABEL \t$CENTRE\t$COAST\t$((DIST-DIST0))" | tee -a $STATIONSFILE
#
# and generate a string of stations along the line at intervals
# starting away from coast (-L)
# 	project -C$COAST -A$ANGLE -L0/$(($NSTN*$SSPACE)) -G$SSPACE -Q 
	{ project -C$COAST -A$ANGLE -L$SSPACE/$((NSTN*SSPACE)) -G$SSPACE -Q | 
		grdtrack -G$TOPO |
		awk -v Label=$LABEL -v MaxDepth=$MAXD -v MinDepth=$MIND '
	BEGIN{	SNum=0}
#             Longitude Latitude DistFromCoast Depth StationNumber StationLabel"
	$4>=MinDepth && $4<=MaxDepth{printf "%8.5f\t%9.5f\t%5.1f\t%5.0f\t%2d\t%-3s\n", \
		$1,$2,$3,$4,++SNum,Label SNum} 
# {printf "%7.4f %8.4f %5.1f %5.0f %2d %-3s\n",$1,$2,$3,$4,++SNum,Label SNum}
# {print $0 "\t" ++SNum "\t" Label SNum } 
		' | tee -a $STATIONSFILE 
	} 2> >( grep -v Inconsistent )

#  # Line S        17.4693/-31.8041        18.1476/-31.6367
#  17.9593 -31.6825        18.5325 107     1       S1
#  17.7709 -31.728 37.065  145     2       S2
#  17.5822 -31.7733        55.5975 181     3       S3
#  17.3934 -31.8182        74.13   196     4       S4
#  17.2044 -31.8629        92.6625 200     5       S5
#  17.0152 -31.9073        111.195 193     6       S6
#  16.8259 -31.9515        129.727 204     7       S7
#  16.6363 -31.9953        148.26  255     8       S8
#  16.4466 -32.0389        166.792 376     9       S9
#  16.2567 -32.0822        185.325 499     10      S10
#  16.0666 -32.1252        203.857 869     11      S11

	# project -C$COAST -A$ANGLE -L10/250 -G$((10.0*$NMILE)) -Q
	# echo $COAST|sed "s-/- -"
done

#

# plot stations

( pscoast -R -JM -W -Di -K 
  sed -n '/^#/!p' $STATIONSFILE | 
    psxy  -R -JM -Sc0.02i -G0 -B1:."$TITLE": -O ) > stngen.ps


#   # MARK
#   15.1553	-26.6427	10 0 0 ML	Luderitz
#   17.2717	-30.3050	10 0 0 ML	Hondeklip Bay
#   20.01	-34.8267	10 0 0 TL	C. Agulhas
#   14.5	-22.9467	10 0 0 ML	Walvis Bay
#   # NOMARK
#   17.8583	-32.8267	10 0 0 TL	C. Columbine
#   18.6	-28.4000	8 0 2 CB 	Orange River
#   17.5	-25.0000	12 0 1 CB 	NAMIBIA
#   18.3	-31.7000	12 0 1 LB 	SOUTH AFRICA
#   #
#   # 18.4983	-34.3567	10 0 0 ML	Cape Point

