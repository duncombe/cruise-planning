#! /bin/zsh


export TITLE="Campaign Name Survey Grid"

export STATIONSFILE=allstns.stns

export TOPO=/usr/local/bathy/etopo1/ETOPO1_Ice_g_gmt4-.grd

# defines line spacing (n.miles)
export LSPACENM=30.0

# defines station spacing (n.miles)
export SSPACENM=10.0

# defines line orientation (compass direction)
export ANGLE=125

# defines area over which to calculate stations.
# Counts NUP lines north of origin
# Counts NDOWN lines south of origin
export NUP=0
export NDOWN=6

# defines number of stations in a line
export NSTN=12

# near Maputo to Port Elizabeth	
export ORIGIN=27.91666670/-33.03333330 
export REMOTE=25.60000000/-33.96666667

# only print stations at the end of lines
export LINELIMITS=true

# only do stations over ground that is between MAXDEPTH And MINDEPTH
export MAXDEPTH=9999
export MINDEPTH=-9999

# ensure stations are more than SKIPNM nautical mile apart
export SKIPNM=0

# Departure and arrival ports
export DEPART="27.91666670	-33.03333330	 East London"
export ARRIVE="25.60000000	-33.96666667	 Port Elizabeth"

export TIMEONSTATION=0
export SPEED=10
export MAXCAST=1500
export SAMPLES=12
# For GENERIC MAPPING TOOLS figures
# Range also partly defines area over which to read coastline 
# database and limits of line calculation 
export Range=-R24/30.5/-36.0/-32.0
export Proj=-JM5i

