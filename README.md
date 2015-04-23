# Cruise Planning

Tools to plan a cruise campaign.

So far: 

- `plan.s` - calculates and displays a chart of station times (durations)
  dependent on the bathymetry. 

- `stngen.zsh` - generates station positions for a regular grid of stations
  in a region.  Outputs stngen.stns with a station positions, bathymetry. 

- `alternatelines.awk` - flips direction of alternate lines in
  `stngen.stns`.  `stngen.stns` stations all run from the coast to
offshore. In a survey grid, some of these lines will be run from offshore
to the coast.

- `cruise-time.awk` - given a nominal ship speed and some other station
  information, calculates how long a cruise will take from `stngen.stns`.

- `linelimits.awk` - extracts only start and end of station lines from
  `stngen.stns`.

- `cruise-path.awk` - takes a list of station names from command line and
  calculates how long cruise will take. 

##Requirements

- Generic Mapping Tools
  Tested on GMT Version 4.5.11.
- zsh
  Tested on Version 4.3.10.
- bash
  Tested on GNU bash, version 4.1.2.
- libraries
    - `[PROGS](github.com/duncombe/PROGS)/mathlib.awk` 
    - gridded topographic data readable by GMT
        Tested using ETOPO1. GMT reads NetCDF and other gridded format files.

##Installation

Clone the repository. Ensure dependencies are available. Modify `config.zsh` to taste, and run `plan.s`. 

##Community Collaboration

Enhancements and bug fixes to the packages are encouraged. Submit pull requests for consideration.


