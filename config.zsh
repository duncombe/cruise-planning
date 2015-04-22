#! /bin/zsh

export TITLE="ECMS SA Agulhas Cruise Plan"

export STATIONSFILE=allstns.stns

export TOPO=/usr/local/bathy/etopo1/ETOPO1_Ice_g_gmt4-.grd

# defines line spacing
export LSPACENM=5.0

# defines station spacing
export SSPACENM=0.5

# defines line orientation (compass direction)
export ANGLE=125

# defines area over which to calculate stations.
# Counts NUP lines north of origin
# Counts NDOWN lines south of origin
export NUP=-4
export NDOWN=120

# defines number of stations in a line
export NSTN=411

# near Maputo to Port Elizabeth	
export ORIGIN=32.57703200/-25.96559000
export REMOTE=25.60000000/-33.96666667

# only print stations at the end of lines
export LINELIMITS=false

# only do stations over ground that is between MAXDEPTH And MINDEPTH
export MAXDEPTH=5000
export MINDEPTH=300

# ensure stations are more than SKIPNM and LINENM nautical mile apart
export SKIPNM=10
export LINENM=30

# Departure and arrival ports
export DEPART="31.00000000	-29.88333333	 Durban"
export ARRIVE="25.60000000	-33.96666667	 Port Elizabeth"

export TIMEONSTATION=0
export SPEED=10
export MAXCAST=2500
export SAMPLES=12
# For GENERIC MAPPING TOOLS figures
# Range also partly defines area over which to read coastline 
# database and limits of line calculation 
export Range=-R20/35/-36.5/-20.5
export Proj=-JM5i

