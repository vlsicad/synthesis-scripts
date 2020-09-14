###################################
# Run the design through Encounter
###################################

# Setup design and create floorplan
loadConfig ../enc/encounter_rc.conf 
#commitConfig

file mkdir ../results/enc

set my_toplevel xxxx

# Create Initial Floorplan
floorplan -r 1.0 0.6 20 20 20 20

# Create Power structures
addRing -spacing_bottom 5 -width_left 5 -width_bottom 5 -width_top 5 -spacing_top 5 -layer_bottom metal5 -width_right 5 -around core -center 1 -layer_top metal5 -spacing_right 5 -spacing_left 5 -layer_right metal6 -layer_left metal6 -nets { gnd vdd }

# Place standard cells
amoebaPlace

# Route power nets
sroute -noBlockPins -noPadRings

# Perform trial route and get initial timing results
trialroute
#buildTimingGraph
#setCteReport
#reportTA -nworst  10 -net > ../results/enctiming.rep.1.placed

# Run in-place optimization
# to fix setup problems
#setIPOMode -mediumEffort -fixDRC -addPortAsNeeded
#initECO ./ipo1.txt
#fixSetupViolation
#endECO

#buildTimingGraph
#setCteReport
#reportTA -nworst  10 -net > ../results/enctiming.rep.2.ipo1

# Run Clock Tree Synthesis
createClockTreeSpec -output ../results/enc/encounter.cts -bufFootprint buf -invFootprint inv
specifyClockTree -clkfile ../results/enc/encounter.cts
ckSynthesis -rguide ../results/enc/cts.rguide -report ../results/enc/report.ctsrpt -macromodel ../results/enc/report.ctsmdl -fix_added_buffers

# Output Results of CTS
trialRoute -highEffort -guide ../results/enc/cts.rguide
extractRC
reportClockTree -postRoute -localSkew -report ../results/enc/skew.post_troute_local.ctsrpt
reportClockTree -postRoute -report ../results/enc/report.post_troute.ctsrpt

# Run Post-CTS Timing analysis
setAnalysisMode -setup -async -skew -autoDetectClockTree
#buildTimingGraph
#setCteReport
#reportTA -nworst  10 -net > ../results/enctiming.rep.3.cts

# Perform post-CTS IPO
#setIPOMode -highEffort -fixDrc -addPortAsNeeded -incrTrialRoute  -restruct -topomap
initECO ../results/enc/ipo2.txt
setExtractRCMode -default -assumeMetFill
extractRC
fixSetupViolation -guide ../results/enc/cts.rguide

# Fix all remaining violations
setExtractRCMode -detail -assumeMetFill
extractRC
if {[isDRVClean -maxTran -maxCap -maxFanout] != 1} {
fixDRCViolation -maxTran -maxCap -maxFanout
}

endECO
cleanupECO

# Run Post IPO-2 timing analysis
#buildTimingGraph
#setCteReport
#reportTA -nworst  10 -net > ../results/enctiming.rep.4.ipo2

# Add filler cells
addFiller -cell FILL -prefix FILL -fillBoundary

# Connect all new cells to VDD/GND
globalNetConnect vdd -type tiehi
globalNetConnect vdd -type pgpin -pin vdd -override

globalNetConnect gnd -type tielo
globalNetConnect gnd -type pgpin -pin gnd -override

# Run global Routing
globalDetailRoute

# Get final timing results
setExtractRCMode -detail -noReduce
extractRC
#buildTimingGraph
#setCteReport
#reportTA -nworst  10 -net > ../results/enctiming.rep.5.final

clearClockDomains
setClockDomains -all
timeDesign -reportOnly -idealClock -pathReports -drvReports -slackReports -numPaths 50 -prefix $my_toplevel -outDir ../results/enc/timingReports


# Output GDSII
streamOut ../results/enc/final.gds2 -mapFile /home/vlsi/libfortech/osu_freepdk/lib/files/gds2_encounter.map -stripes 1 -units 1000 -mode ALL
streamOut ../results/enc/fdm -mapFile ../results/enc/streamOut.map -libName DesignLib -structureName $my_toplevel -units 2000 -mode ALL
saveNetlist -excludeLeafCell ../results/enc/final.v

# Output DSPF RC Data
rcout -spf ../results/enc/final.dspf

# Run DRC and Connection checks
verifyGeometry
verifyConnectivity -type all

win

puts "**************************************"
puts "* Encounter script finished          *"
puts "*                                    *"
puts "* Results:                           *"
puts "* --------                           *"
puts "* Layout:  final.gds2                *"
puts "* Netlist: final.v                   *"
puts "* Timing:  timing.rep.5.final        *"
puts "*                                    *"
puts "* Type 'exit' to quit                *"
puts "*                                    *"
puts "**************************************"
