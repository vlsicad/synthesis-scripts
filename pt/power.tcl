
set power_enable_analysis TRUE
set power_ui_backward_compatibility  TRUE

set saed90 /home/vlsi/libfortech/90nm/models
set  search_path     ${saed90}
set  link_library    ${saed90}/saed90nm_typ_ht.db
set  target_library  ${saed90}/saed90nm_typ_ht.db

alias h history
alias rc "report_constraint -all_violators"

file mkdir ../results/pt

set my_toplevel xxxxx

read_db $target_library
read_verilog ../icc/xxxxx90.v
current_design xxxxxx
link
read_vcd ../pt/xxxxx1.vcd 
create_power_waveforms

#report_power ../result/pt/avg_power.txt

redirect ../results/pt/avgp.txt { report_power }
