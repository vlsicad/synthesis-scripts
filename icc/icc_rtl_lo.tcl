#source ../scripts/setup.tcl
#source ../scripts/definitions.tcl
#source ../scripts/design_all.tcl

# -------- setup.tcl
#set search_path ../ref/models
#set link_library  "* saed90nm_typ_ht.db"
#set target_library  "saed90nm_typ_ht.db"
#alias h history
#alias rc "report_constraint -all_violators"
#https://github.com/pfchiu/origin/blob/master/lab1-verilog/build/icc-par/rm_setup/icc_setup.tcl
set saed90 /home/vlsi/libfortech/90nm/models
set  search_path     ${saed90}
set  link_library    ${saed90}/saed90nm_typ_ht.db
set  target_library  ${saed90}/saed90nm_typ_ht.db
set  symbol_library  ${saed90}/saed90nm.sdb
set  define_design_lib WORK -path ./WORK 
alias h history
alias rc "report_constraint -all_violators"


file mkdir ../results/icc

set my_toplevel fsmdemo1

# -------- defination.tcl

create_mw_lib  -technology  /home/vlsi/libfortech/90nm/techfiles/saed90nm_icc_1p9m.tf \
		-mw_reference_library {/home/vlsi/libfortech/90nm/saed90nm_fr }	 \
		-hier_separator {/}				 \
		-bus_naming_style {[%d]}			 \
		-open  ../results/icc/COUNT


set_tlu_plus_files   -max_tluplus /home/vlsi/libfortech/90nm/tluplus/saed90nm_1p9m_1t_Cmax.tluplus \
                     -min_tluplus /home/vlsi/libfortech/90nm/tluplus/saed90nm_1p9m_1t_Cmin.tluplus   \
                     -tech2itf_map  /home/vlsi/libfortech/90nm/tluplus/tech2itf.map


set filename [format "%s%s"  $my_toplevel "90.v"]
read_verilog  -cell fsmdemo1  ../icc/$filename
# -allow_undefined_module
#import_designs -format verilog		\
#               -top fsmdemo1		\
#	       -cel fsmdemo1 {../results/enc90/fsmdemo190.v}

set filename [format "%s%s"  $my_toplevel "90.sdc"]
source  ../icc/$filename		

# -------- degsineall.tcl

# ##	FLOORPLAN	 
# ################################################################
initialize_floorplan -core_utilization 0.33 -start_first_row -flip_first_row -left_io2core 1 -bottom_io2core 1 -right_io2core 1 -top_io2core 1


current_design $my_toplevel

set power                    "VDD"
set ground                   "VSS"
set powerPort                "VDD"
set groundPort               "VSS"
set mw_logic0_net 	     "VSS"
set mw_logic1_net 	     "VDD"

# DEFINING POWER/GROUND NETS AND PINS			 
derive_pg_connection -power_net VDD		\
			 -ground_net VSS	\
			 -power_pin VDD		\
			 -ground_pin VSS	
			 
##//CREATING POWER RECTANGULAR RING		

create_rectangular_rings  -nets  {VDD VSS}  -left_offset 0.2 -left_segment_layer M4 -right_offset 0.2 -right_segment_layer M4 -bottom_offset 0.2 -bottom_segment_layer M3 -extend_bh -top_offset 0.2 -top_segment_layer M3 

create_power_straps  -direction horizontal  -nets  {VDD}  -layer M4 -configure groups_and_step  -num_groups 28 -step 3
create_power_straps  -direction horizontal  -start_at 1.5 -nets  {VSS}  -layer M4 -configure groups_and_step  -num_groups 28 -step 3
create_power_straps  -direction vertical  -nets  {VDD}  -layer M3 -configure groups_and_step  -num_groups 28 -step 3
create_power_straps  -direction vertical  -start_at 1.5 -nets  {VSS}  -layer M3 -configure groups_and_step  -num_groups 28 -step 3

puts "start_place"

## This should be changed back once we figure out how to deal with read_def!!!!
## place_opt -effort high -optimize_dft -congestion
place_opt -effort high -continue_on_missing_scandef -congestion

legalize_placement -effort high -incremental 

set_fix_multiple_port_nets -all -buffer_constants

## This should be changed back once we figure out how to deal with read_def!!!!
## place_opt -effort high -optimize_dft -congestion
place_opt -effort high -continue_on_missing_scandef -congestion

legalize_placement -effort high -incremental 

preroute_standard_cells -nets VSS -connect horizontal
preroute_standard_cells -nets VDD -connect horizontal

verify_pg_nets  -pad_pin_connection all
save_mw_cel

puts "finish_place"

puts "start_cts"

check_legality

set_clock_tree_options -clock_trees clk \
		-insert_boundary_cell true \
		-ocv_clustering true \
		-buffer_relocation true \
		-buffer_sizing true \
		-gate_relocation true \
		-gate_sizing true \
		-delay_insertion true
		
set cts_use_debug_mode true
set cts_do_characterization true

puts "stdcell_filler"

clock_opt -fix_hold_all_clocks

# DEFINING POWER/GROUND NETS AND PINS			 
derive_pg_connection -power_net VDD		\
			 -ground_net VSS	\
			 -power_pin VDD		\
			 -ground_pin VSS	
			 
preroute_standard_cells -nets VSS -connect horizontal
preroute_standard_cells -nets VDD -connect horizontal

verify_pg_nets
verify_pg_nets  -pad_pin_connection all

save_mw_cel

puts "finish_cts"

puts "start_route"

check_routeability

set_delay_calculation -arnoldi

set_net_routing_layer_constraints \
	-max_layer_name M5 -min_layer_name M1 {*}

set_si_options -route_xtalk_prevention true\
	 -delta_delay true \
	 -min_delta_delay true \
	 -static_noise true\
	 -max_transition_mode normal_slew \
	 -timing_window true 

set_route_options -groute_timing_driven true \
	-groute_incremental true \
	-track_assign_timing_driven true \
	-same_net_notch check_and_fix 

route_opt -effort high \
	-stage global \
	-incremental 

save_mw_cel
	
route_opt -effort high \
	-stage track \
	-xtalk_reduction \
	-optimize_wire_via \
	-incremental 

save_mw_cel
	
verify_route

insert_redundant_vias -auto_mode insert

insert_stdcell_filler -cell_without_metal SHFILL1 \
	-connect_to_power VDD -connect_to_ground VSS
	
insert_stdcell_filler -cell_without_metal SHFILL2 \
	-connect_to_power VDD -connect_to_ground VSS

insert_well_filler -layer NWELL \
	-higher_edge max -lower_edge min
	
preroute_standard_cells -nets VDD -connect horizontal
preroute_standard_cells -nets VSS -connect horizontal

verify_pg_nets
verify_pg_nets  -pad_pin_connection all
	
route_search_repair -loop 500 -rerun_drc 

save_mw_cel

puts "finish_route"

close_mw_cel
close_mw_lib
set_mw_lib_reference  -mw_reference_library {/home/vlsi/libfortech/90nm/saed90nm_fr} ../results/icc/COUNT/
open_mw_lib ../results/icc/COUNT
set ::auto_restore_mw_cel_lib_setup false
open_mw_cel  $my_toplevel

set_write_stream_options -map_layer /home/vlsi/libfortech/90nm/saed90nm.gdsout.map \
                               -output_filling fill \
                               -child_depth 20 \
                               -output_outdated_fill  \
                              -output_pin  {text geometry}
                write_stream -lib ../results/icc/COUNT\
                     -format gds\
                     -cells $my_toplevel\
                     ../results/icc/$my_toplevel.gds

extract_rc

write_parasitics -output ../results/icc/$my_toplevel.spef
write_verilog -pg -no_physical_only_cells ../results/icc/$my_toplevel.v1
write_verilog -no_physical_only_cells ../results/icc/$my_toplevel.v

