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

set PREVIOUS_STEP $DPLAN_BLOCK
set CURRENT_STEP $PLACE_BLOCK

read_db ${DB_DIR}/${PREVIOUS_STEP}.db

set_innovus_options

set_db timing_analysis_type ocv
set_db timing_analysis_cppr both

redirect -file $REPORTS_DIR/${CURRENT_STEP}/${TOP_MODULE}_timing_check.rpt {check_timing -verbose}
time_design -pre_place -report_prefix ${TOP_MODULE}_pre_place -report_dir $REPORTS_DIR/${CURRENT_STEP}

place_opt_design -report_prefix ${TOP_MODULE}_place_opt -report_dir $REPORTS_DIR/${CURRENT_STEP}

set_db add_tieoffs_cells $TIE_CELLS
set_db add_tieoffs_max_fanout 1
add_tieoffs

#source scripts/add_bond_pads.tcl
source scripts/createNplace_bondpads.tcl
createNplace_bondpads -inline_pad_ref_name $BONDPAD_CELL

write_db ${DB_DIR}/${CURRENT_STEP}.db
