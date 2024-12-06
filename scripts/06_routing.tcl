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

set PREVIOUS_STEP $CTS_BLOCK
set CURRENT_STEP $ROUTING_BLOCK

read_db ${DB_DIR}/${PREVIOUS_STEP}.db

set_innovus_options

#add_io_fillers -cells $IO_PAD_FILLER_CELLS
add_io_fillers -cells $IO_PAD_FILLER_CELLS

#set_db add_fillers_cells $STD_FILLER_CELLS
set_db add_fillers_cells $STD_FILLER_CELLS
set_db add_fillers_prefix FILLER
add_fillers

set_db route_design_fix_clock_nets true
set_db route_design_with_timing_driven 1
set_db route_design_with_si_driven 0
set_db route_design_detail_post_route_swap_via multiCut

route_design -global_detail -via_opt -wire_opt

check_drc
#-limit 1000
check_connectivity
#delete_routes -regular_wire_with_drc
route_eco -fix_drc

delete_routes -regular_wire_with_drc
route_eco -fix_drc

check_drc
check_connectivity

set_db extract_rc_engine post_route
set_db extract_rc_effort_level medium
set_db delaycal_enable_si true
set_db opt_post_route_drv_recovery true
set_db opt_effort high

opt_design -post_route -setup -hold -report_prefix ${TOP_MODULE}_opt_post_route_setup_hold -report_dir $REPORTS_DIR/${CURRENT_STEP}
opt_design -post_route -drv -report_prefix ${TOP_MODULE}_opt_post_route_drv -report_dir $REPORTS_DIR/${CURRENT_STEP}

write_db ${DB_DIR}/${CURRENT_STEP}.db
