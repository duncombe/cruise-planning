#!/bin/zsh
# 14.5		-22.9467	10 0 0 ML	Walvis Bay
# 17.8583	-32.8267	10 0 0 TL	C. Columbine
#
# generate station lines from Columbine to Walvis Bay @ 30 mile intervals
#
# echo $TOPO
TOPO=${TOPO-/usr/local/bathy/etopo1/ETOPO1_Ice_g_gmt4.grd}

NMILE=1.85325
LSPACE=$((30.0*$NMILE))
SSPACE=$((10.0*$NMILE))

#
#
# count for the station labels, starting at EE (AA=64 A=65)

COUNT=58

Range=-R0/20/-36/-10 
Proj=-JM5i
Nup=7.0
Ndown=18.0
Nstn=21.0

#
# generate all points on the coast which lie in the range
pscoast $Range $Proj -Dh -M -W | egrep -v ">|#" > stngen.coast

#
# output a little story at the top
echo "## Station Listing"
echo "## Station Lines are identified by a line with "
########echo "## \"Line\" LineName CentrePos"
echo "## \"Line\" LineName CentrePos CoastPnt"
echo "## Station positions are identified by a line with "
echo "## Longitude Latitude DistFromCoast Depth StationNumber StationLabel"
##echo "## (where stationname may be optional? where stationname is a number?)"

# 
# from a point near Walvis Bay (-C) generate points within a range (-L)
# towards another point (-E) spacing them a distance (-G) apart
for CENTRE in `
#
# works best if opR8 in multiples of the line spacing UR trying to genR8
project -Q						\
	-C14.5/$((-0.25-22.9467))			\
	-E17.8583/-32.8267				\
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
	# project -C$CENTRE -A254 -L-70/500 -G$((10*$NMILE)) -Q
#
# for each point (-C) find the closest coastal point along a line
# perpendicular to topography (-A)
	COAST=`project stngen.coast -C$CENTRE -A254 -M |
		awk '	BEGIN{min=99999}
			{a=$4<0?-$4:$4; if (a<min){min=a; p=$5 "/" $6}}
			END{print p}' `
	echo "# Line $LABEL \t$CENTRE\t$COAST"
#
# and generate a string of stations along the line at intervals
# starting away from coast (-L)
	project -C$COAST -A254		\
		-L$SSPACE/$(($Nstn*$SSPACE))	\
		-G$SSPACE -Q |
		grdtrack -G$TOPO |
		awk -v Label=$LABEL '
	BEGIN{	SNum=0}
	{printf "%7.4f\t%8.4f\t%5.1f\t%5.0f\t%2d\t%-3s\n", \
		$1,$2,$3,$4,++SNum,Label SNum}
# {printf "%7.4f %8.4f %5.1f %5.0f %2d %-3s\n",$1,$2,$3,$4,++SNum,Label SNum}
# {print $0 "\t" ++SNum "\t" Label SNum } '

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

	# project -C$COAST -A254 -L10/250 -G$((10.0*$NMILE)) -Q
	# echo $COAST|sed "s-/- -"
done

#


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

