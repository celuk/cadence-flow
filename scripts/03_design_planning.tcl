# This file is part of https://github.com/celuk/cadence-flow
# Copyright (C) 2024  Seyyid Hikmet Celik
# 					  seyyid4091@gmail.com
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

source scripts/00_setup.tcl

set PREVIOUS_STEP $INIT_BLOCK
set CURRENT_STEP $DPLAN_BLOCK

read_db ${DB_DIR}/${PREVIOUS_STEP}.db

set_innovus_options

read_io_file $IO_FILE

create_floorplan -box_size {0 0 1000 1000 75 75 925 925 125 125 875 875}

legalize_floorplan -check_orient
legalize_floorplan -check_site

#connect_global_net VDD -all -type pgpin -pin vdd!
#connect_global_net VSS -all -type pgpin -pin vss!
#connect_global_net VDDPST -all -type pgpin -pin vddpst!

connect_global_net VSS -type pg_pin -pin_base_name VSS*
connect_global_net VDD -type pg_pin -pin_base_name VDD*

delete_all_floorplan_objs

split_row

set_db add_rings_extend_over_row true
add_rings -center 1 -type core_rings -nets {VDD VDD VDD VDD VSS VSS VSS VSS} -layer {top M7 bottom M7 left M6 right M6} -spacing 2 -width 4 -use_wire_group 1
add_rings -center 1 -type core_rings -nets {VDD VDD VDD VDD VSS VSS VSS VSS} -layer {top M7 bottom M7 left M8 right M8} -spacing 2 -width 4 -use_wire_group 1

set_db add_stripes_break_at block_ring
add_stripes -direction vertical -nets {VDD VSS} -width 3 -spacing 5 -layer M6 -start_offset 50 -set_to_set_distance 72

add_stripes -direction horizontal -nets {VDD VSS} -width 3 -spacing 5 -layer M7 -start_offset 10 -set_to_set_distance 72

set_db route_special_via_connect_to_shape noshape
set_db route_special_core_pin_ignore_obs block_halo
route_special -connect {pad_pin} -allow_layer_change 0 -pad_pin_port_connect {all_port all_geom} -pad_ring_layer M3

route_special -connect {core_pin} -core_pin_target {first_after_row_end} -allow_layer_change 0 -nets {VDD VSS}

#create_route_blockage -area 75 170 150 200
#create_route_blockage -area 75 320 150 350
#create_route_blockage -area 75 470 150 500
#create_route_blockage -area 75 620 150 650
#create_route_blockage -area 75 770 150 800
#
#create_route_blockage -area 770 75 800 150
#create_route_blockage -area 620 75 650 150
#create_route_blockage -area 470 75 500 150
#create_route_blockage -area 320 75 350 150
#create_route_blockage -area 170 75 200 150
#
#create_route_blockage -area 770 850 800 925
#create_route_blockage -area 620 850 650 925
#create_route_blockage -area 470 850 500 925
#create_route_blockage -area 320 850 350 925
#create_route_blockage -area 170 850 200 925
#
#create_route_blockage -area 850 170 925 200
#create_route_blockage -area 850 320 925 350
#create_route_blockage -area 850 470 925 500
#create_route_blockage -area 850 620 925 650
#create_route_blockage -area 850 770 925 800

write_db ${DB_DIR}/${CURRENT_STEP}.db
