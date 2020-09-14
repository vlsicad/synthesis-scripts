##rtl.tcl file adapted from http://ece.colorado.edu/~ecen5007/cadence/
##this tells the compiler where to look for the libraries

##set_attribute lib_search_path /net/ra05u/hplp/osuflow/osu_stdcells/lib/tsmc018/signalstorm
#set_attribute lib_search_path /home/hplp/osuflow/osu_stdcells/lib/tsmc018/signalstorm
set_attribute lib_search_path /home/vlsi/libfortech/osu_freepdk/lib/files


## This defines the libraries to use

set_attribute library {gscl45nm.lib}

##This must point to your VHDL/verilog file
##it is recommended that you put your VHDL/verilog in a folder called HDL in
##the directory that you are running RC out of

## CHANGE THIS LINE to your VHDL/verilog file name, if you follow the tutorial
## you do not need to change anything


file mkdir ../results/rtl

read_hdl -vhdl [list ../code/xxxxx.vhd]

set my_toplevel xxxxx

## This buils the general block
elaborate

##this allows you to define a clock and the maximum allowable delays
## READ MORE ABOUT THIS SO THAT YOU CAN PROPERLY CREATE A TIMING FILE
#set clock [define_clock -period 300 -name clk]
#external delay -input 300 -edge rise clk
#external delay -output 2000 -edge rise p1

ungroup -all -flatten
##This synthesizes your code
#synthesize -to_mapped
synthesize -effort low -to_mapped

## This writes all your files
## change the tst to the name of your top level verilog
## CHANGE THIS LINE: CHANGE THE "accu" PART REMEMBER THIS
## FILENAME YOU WILL NEED IT WHEN SETTING UP THE PLACE & ROUTE

set filename [format "%s%s"  $my_toplevel "rc.vh"]
##write_sdc ../results/dc45/$filename

write -mapped > ../results/rtl/$filename
write -mapped >   /Cadence/CMOSedu/all_vh_files/$filename
write -mapped > ../enc/$filename

## THESE FILES ARE NOT REQUIRED, THE SDC FILE IS A TIMING FILE
write_script > ../results/rtl/script

set filename [format "%s%s"  $my_toplevel "rc.sdc"]

write_sdc    > ../results/rtl/$filename
write_sdc    > ../enc/$filename
