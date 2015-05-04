#! /bin/bash

# use a configuration file
source config.zsh

# Test all required are provided or assign a default 
# leave and return to cape town, allow no additional time on station, vessel speed is 10 knots, cast
# always to the bottom, using a 12 bottle carousel
STATIONSFILE=${STATIONSFILE:-allstns.stns}
DEPART=${DEPART:-"18.43666667    -33.90833333     Cape Town Docks"}
ARRIVE=${ARRIVE:-$DEPART}
MAXDEPTH=${MAXDEPTH:-9999}
MINDEPTH=${MINDEPTH:--9999}
SKIPNM=${SKIPNM:-0}
LINENM=${LINENM:-0}
TIMEONSTATION=${TIMEONSTATION:-0}
SPEED=${SPEED:-10}
MAXCAST=${MAXCAST:-9000}
SAMPLES=${SAMPLES:-12}
TOPO=${TOPO:-/usr/local/bathy/etopo1/ETOPO1_Ice_g_gmt4-.grd}
Range=${Range:--R20/35/-36.5/-20.5}


NMILE=1.85325 # km
SKIP=`echo "$SKIPNM * $NMILE" | bc`
LINE=`echo "$LINENM * $NMILE" | bc`

# generate all the lines of the cruise

# generate the stations
ANS="Y" 
[ -s $STATIONSFILE ] && { read -p "$STATIONSFILE exists. Recalculate? (y/N) " ANS ;} 
[ "$ANS" = "y" -o "$ANS" = "Y" ] && ./stngen.zsh 

# exclude stations outside the depth limits 
gawk -f exclude-stns.awk -v LINE=$LINE -v SKIP=$SKIP -v MAXDEPTH=$MAXDEPTH -v MINDEPTH=$MINDEPTH allstns.stns > stngen.stns

# switch alternate lines from inshore to offshore
gawk -f alternatelines.awk stngen.stns > stngen.snts 

# do not simplify the cruise 
if ${LINELIMITS} ; then 
	gawk -f linelimits.awk stngen.snts > limits.snts
else
	cat stngen.snts > limits.snts
fi


# calculate the cruise time using the simplified cruiseplan including
# from and to ports

{ echo $DEPART
  cat limits.snts 
  echo $ARRIVE
} | gawk -f mathlib.awk -f cruise-time.awk	\
	-v TimeOnStation=$TIMEONSTATION	\
	-v SPD=$SPEED 		\
	-v Maxcast=$MAXCAST		\
	-v Samples=$SAMPLES		\
> limits.txt

# 

cat << ENDIN > contours.cnt
200	C
500	C
1000	C
2000	C
3000	C
4000	C
5000	C
ENDIN

makecpt -Cocean -T0/6000/500 -I > contours.cpt

{
  grdimage $TOPO -Ccontours.cpt -JM5i $Range -K -P  
  grdcontour $TOPO -Ccontours.cnt -JM $Range -B1:."$TITLE": -K -O 
  psxy limits.snts $Range -JM -W/255/0/0 -K -O 
  pscoast $Range -JM -W -N1 -Di -O 
} > cruise-plan.ps
