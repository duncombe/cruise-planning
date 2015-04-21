
# generate all the lines of the cruise

# generate the stations
# ./stngen.zsh 

# exclude stations outside the depth limits 
gawk -f exclude-stns.awk -v MaxDepth=351 -v MinDepth=20 allstns.stns > stngen.stns

# switch alternate lines from inshore to offshore
gawk -f alternatelines.awk stngen.stns > stngen.snts 

# do not simplify the cruise 
# gawk -f linelimits.awk stngen.snts > limits.snts
cat stngen.snts > limits.snts


# calculate the cruise time using the simplified cruiseplan
{ echo 31.00000000	-29.88333333	 Durban	
  cat limits.snts 
  echo 25.60000000	-33.96666667	 Port Elizabeth	
} | gawk -f mathlib.awk -f cruise-time.awk	\
	-v TimeOnStation=0	\
	-v SPD=8 		\
	-v Bathy=1500		\
	-v Samples=12		\
	> limits.txt

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

grdcontour $TOPO -Ccontours.cnt -JM -R -B1:."ECMS High-Density Cruise Plan": -K -O  >> cruise-plan.ps

psxy limits.snts -R -JM -W/255/0/0 -K -O >> cruise-plan.ps

pscoast -R -JM -W -N1 -Di -O >> cruise-plan.ps



