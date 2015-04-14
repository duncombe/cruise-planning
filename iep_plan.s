
# generate all the lines of the cruise

# generate the stations
# ./stngen.zsh 

# switch alternate lines from inshore to offshore
gawk -f alternatelines.awk stngen.stns > stngen.snts 

# simplify the cruise 
gawk -f linelimits.awk stngen.snts > limits.snts

# calculate the cruise time using the simplified cruiseplan
{ echo 18.43666667    -33.90833333     Cape Town Docks 
  cat limits.snts 
  echo 18.43666667    -33.90833333     Cape Town Docks ; } | 
	gawk -f mathlib.awk -f cruise-time.awk -v TimeOnStation=1 -v SPD=8 > limits.txt

# 
TOPO=/usr/local/bathy/etopo1/ETOPO1_Ice_g_gmt4-.grd

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

grdimage $TOPO -Ccontours.cpt -JM -R -K -P  > cruise-plan.ps

grdcontour $TOPO -Ccontours.cnt -JM -R -B1:."IEP Tow-Yo Cruise Plan": -K -O  >> cruise-plan.ps

psxy limits.snts -R -JM -W/255/0/0 -K -O >> cruise-plan.ps

pscoast -R -JM -W  -Di -O >> cruise-plan.ps



