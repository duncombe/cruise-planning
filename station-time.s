#! /bin/bash

Range=-R8/40/-40/-10

BATHYSOURCE=/usr/local/etopo5/etopo5.grd
BATHYSOURCE=/usr/local/bathy/etopo1/ETOPO1_Ice_g_gmt4.grd 

if [ ! -e topo.grd ]; then 
	grdcut $BATHYSOURCE $Range -Gtopo.grd
fi

psbasemap $Range -JM6i -B5:."Station Time for CTD and Bongo": -P -K 

# bathymetry is topography over the sea, zero over the land
if [ ! -e bathy.grd ]; then 
	grdmath topo.grd 0 LE topo.grd MUL -1 MUL = bathy.grd
else
	echo No need to calculate bathy.grd, file exists 1>&2
fi
# deploy and recover 5 min, cast at 1 m/s, 10 min close bottles
if [ ! -e ctd.grd ]; then 
	grdmath bathy.grd 1100 MIN 2 MUL 60 DIV 10 ADD 5 ADD = ctd.grd
else
	echo No need to calculate ctd.grd, file exists 1>&2
fi
# deploy and recover 3 min, cast at 1 m/s
if [ ! -e bongo.grd ]; then 
	grdmath bathy.grd 200 MIN 2 MUL 60 DIV 3 ADD = bongo.grd
else
	echo No need to calculate bongo.grd, file exists 1>&2
fi


# sum grids
grdmath bongo.grd ctd.grd ADD = station.grd
# plot the station time

grdcontour station.grd -R -JM6i -C15 -A60 -O -K
pscoast -R -JM -Di -W -A0/0/1 -O



