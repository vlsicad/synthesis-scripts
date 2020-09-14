

#/**************************************************/
#/* Compile Script for Synopsys                    */
#/*                                                */
#/* dc_shell-t -f compile_dc.tcl                   */
#/*                                                */
#/* OSU FreePDK 45nm                               */
#/**************************************************/
file mkdir ../results/dc45
#/* All verilog files, separated by spaces         */
set my_vhdl_files [list  ../code/ ]


#/* Top-level Module                               */
set my_toplevel xxxxxx

#/* The name of the clock pin. If no clock-pin     */
#/* exists, pick anything                          */
set my_clock_pin clk

#/* Target frequency in MHz for optimization       */
set my_clk_freq_MHz 500

#/* Delay of input signals (Clock-to-Q, Package etc.)  */
set my_input_delay_ns 0.1

#/* Reserved time for output signals (Holdtime etc.)   */
set my_output_delay_ns 0.1


#/**************************************************/
#/* No modifications needed below                  */
#/**************************************************/
set OSU_FREEPDK /home/vlsi/libfortech/osu_freepdk/lib/files
set search_path [concat  $search_path $OSU_FREEPDK]
set alib_library_analysis_path $OSU_FREEPDK

set link_library [set target_library [concat  [list gscl45nm.db] [list dw_foundation.sldb]]]
set target_library "gscl45nm.db"
define_design_lib WORK -path ../WORK
set verilogout_show_unconnected_pins "true"
set_ultra_optimization true
set_ultra_optimization -force

analyze -f vhdl $my_vhdl_files

elaborate $my_toplevel

current_design $my_toplevel

link
uniquify

set my_period [expr 1000 / $my_clk_freq_MHz]

set find_clock [ find port [list $my_clock_pin] ]
if {  $find_clock != [list] } {
   set clk_name $my_clock_pin
   create_clock -period $my_period $clk_name
} else {
   set clk_name vclk
   create_clock -period $my_period -name $clk_name
}

set_driving_cell  -lib_cell INVX1  [all_inputs]
set_input_delay $my_input_delay_ns -clock $clk_name [remove_from_collection [all_inputs] $my_clock_pin]
set_output_delay $my_output_delay_ns -clock $clk_name [all_outputs]

compile -ungroup_all -map_effort medium

compile -incremental_mapping -map_effort medium

check_design
report_constraint -all_violators

set filename [format "%s%s"  $my_toplevel "s45.v"]
write -f verilog -output ../results/dc45/$filename
write -f verilog -output ../enc/$filename

set filename [format "%s%s"  $my_toplevel "s45.sdc"]
write_sdc ../results/dc45/$filename
write_sdc ../enc/$filename

#set filename [format "%s%s"  $my_toplevel "45.db"]
#write -f db -hier -output ../results/$filename 

redirect ../results/dc45/timing45.rep { report_timing }
redirect ../results/dc45/cell45.rep { report_cell }
redirect ../results/dc45/power45.rep { report_power }

redirect  ../results/dc45/report_time45.txt {report_timing -path full -delay max -max_paths 1 -nworst 1}
redirect ../results/dc45/report_area45.txt {report_area}
redirect ../results/dc45/report_power45.txt {report_power}
exec cat ../results/dc45/report_area45.txt ../results/dc45/report_power45.txt ../results/dc45/report_time45.txt >  ../results/dc45/report_all45.txt

