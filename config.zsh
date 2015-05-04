#! /bin/zsh


export TITLE="IEP Tow-Yo Cruise Plan"

export STATIONSFILE=allstns.stns

export TOPO=/usr/local/bathy/etopo1/ETOPO1_Ice_g_gmt4-.grd

# defines line spacing (n.miles)
export LSPACENM=10.0

# defines station spacing (n.miles)
export SSPACENM=1.0

# defines line orientation (compass direction)
export ANGLE=245

# defines area over which to calculate stations.
# Counts NUP lines north of origin
# Counts NDOWN lines south of origin
export NUP=-1
export NDOWN=38

# defines number of stations in a line
export NSTN=201

export ORIGIN=16.45/-28.6333333    
export REMOTE=16.433/-32.7442

# only print stations at the end of lines
export LINELIMITS=true

# only do stations over ground that is between MAXDEPTH And MINDEPTH
export MAXDEPTH=1501
export MINDEPTH=50

# ensure stations are more than SKIPNM and LINENM nautical mile apart
export SKIPNM=0
export LINENM=0

# Departure and arrival ports
export DEPART="18.43666667    -33.90833333     Cape Town Docks"
export ARRIVE="18.43666667    -33.90833333     Cape Town Docks"

export TIMEONSTATION=1
export SPEED=8
export MAXCAST=0
export SAMPLES=0
# For GENERIC MAPPING TOOLS figures
# Range also partly defines area over which to read coastline 
# database and limits of line calculation 
export Range=-R10/20/-36.5/-27.5 
export Proj=-JM5i

