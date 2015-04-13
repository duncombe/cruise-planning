#!/bin/zsh
#
# Using zsh because? I think it was that at the time, bash was not able to do
# the things desired, or zsh was more advanced in certain things than bash. 
#
# 14.5		-22.9467	10 0 0 ML	Walvis Bay
# 17.8583	-32.8267	10 0 0 TL	C. Columbine
#
# generate station lines from Columbine to Walvis Bay @ 30 mile intervals
# at an angle 
#
# echo $TOPO

STATIONSFILE=stngen.stns

# "> filename" does not perform as expected in zsh
rm -f dummy $STATIONSFILE 
touch $STATIONSFILE 

# echo done here

TOPO=${TOPO-/usr/local/bathy/etopo1/ETOPO1_Ice_g_gmt4-.grd}
[ ! -e $TOPO ] && { echo Topo file $TOPO not found ; exit 1 ; }

NMILE=1.85325

# defines line spacing
LSPACE=$((10.0*$NMILE))

# defines station spacing
SSPACE=$((1.0*$NMILE))

# defines line orientation (compass direction)
# ANGLE=254
ANGLE=245

# 
#
MAXD=1501
MIND=50

#
# count for the station labels, starting at EE (AA=64 A=65) 
COUNT=58

# Range=-R0/20/-36/-10 
Range=-R10/20/-36.5/-27.5 
Proj=-JM5i

# defines area over which to calculate stations, Nup lines north of
# origin, Ndown lines south of origin
# Nup=7.0
# Ndown=18.0
Nup=-1
Ndown=38


# defines number of stations in a line
Nstn=201

# for a point near Walvis Bay
# ORIGIN=14.5/$((-0.25-22.9467))
# REMOTE=17.8583/-32.8267

# for a point near cape peninsula
# -32.7442 16.4333
ORIGIN=16.45/-28.6333333    
REMOTE=16.433/-32.7442

#
# generate all points on the coast which lie in the range
pscoast $Range $Proj -Dh -M -W | egrep -v ">|#" > stngen.coast

#
# output a little story at the top
(
  echo "## Station Listing"
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
for CENTRE in `
#
# works best if opR8 in multiples of the line spacing UR trying to genR8
project -Q						\
	-C$ORIGIN					\
	-E$REMOTE					\
	-L$((-$LSPACE*$Nup))/$(($LSPACE*$Ndown))	\
	-G$LSPACE					\
	| awk '{print $1 "/" $2}' 
`
do
#
# for each of these points (corresponding to lines) generate a line number
	LABEL=`echo $COUNT |
	awk ' {	a=$1;
		if (a<65){
			a=64-(a-65);
			printf "%c%c\n",a,a
			}
			else { printf "%c\n",a}
		}'`
	(( COUNT++ ))
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
	echo "# Line $LABEL \t$CENTRE\t$COAST" | tee -a $STATIONSFILE
#
# and generate a string of stations along the line at intervals
# starting away from coast (-L)
	project -C$COAST -A$ANGLE		\
		-L$SSPACE/$(($Nstn*$SSPACE))	\
		-G$SSPACE -Q | 
		grdtrack -G$TOPO |
		awk -v Label=$LABEL -v MaxDepth=$MAXD -v MinDepth=$MIND '
	BEGIN{	SNum=0}
#             Longitude Latitude DistFromCoast Depth StationNumber StationLabel"
	$4>=MinDepth && $4<=MaxDepth{printf "%7.4f\t%8.4f\t%5.1f\t%5.0f\t%2d\t%-3s\n", \
		$1,$2,$3,$4,++SNum,Label SNum} 
# {printf "%7.4f %8.4f %5.1f %5.0f %2d %-3s\n",$1,$2,$3,$4,++SNum,Label SNum}
# {print $0 "\t" ++SNum "\t" Label SNum } 
		' | tee -a $STATIONSFILE 

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
    psxy  -R -JM -Sc0.02i -G0 -B1 -O ) > stngen.ps


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

