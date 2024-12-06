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

set PREVIOUS_STEP $PLACE_BLOCK
set CURRENT_STEP $CTS_BLOCK

read_db ${DB_DIR}/${PREVIOUS_STEP}.db

set_innovus_options

time_design -pre_cts -report_prefix ${TOP_MODULE}_pre_cts -report_dir $REPORTS_DIR/${CURRENT_STEP}
opt_design -pre_cts -setup -drv -report_prefix REPORTS_DIR/${CURRENT_STEP}/${TOP_MODULE}_pre_cts_opt -report_dir $REPORTS_DIR/${CURRENT_STEP}

#set_db cts_inverter_cells [get_db [get_lib_cells -regexp $CTS_INV_CELL_REGEXP] .base_name]
set_db cts_inverter_cells $CTS_INV_CELLS

#set_db cts_buffer_cells [get_db [get_lib_cells -regexp $CTS_BUF_CELL_REGEXP] .base_name]
set_db cts_buffer_cells $CTS_BUF_CELLS

set_db cts_target_max_transition_time 0.2

clock_design

redirect -file ${TOP_MODULE}_clock_tree_summary.rpt {report_clock_trees -summary}
redirect -file ${TOP_MODULE}_clock_tree_structure.rpt {report_clock_tree_structure}

opt_design -post_cts -report_prefix ${TOP_MODULE}_post_cts_setup -report_dir $REPORTS_DIR/${CURRENT_STEP}
opt_design -post_cts -hold -report_prefix ${TOP_MODULE}_post_cts_hold -report_dir $REPORTS_DIR/${CURRENT_STEP}
opt_design -post_cts -drv -report_prefix ${TOP_MODULE}_post_cts_drv -report_dir $REPORTS_DIR/${CURRENT_STEP}

time_design -post_cts -report_prefix ${TOP_MODULE}_time_post_cts_setup -report_dir $REPORTS_DIR/${CURRENT_STEP}
time_design -post_cts -hold -report_prefix ${TOP_MODULE}_time_post_cts_hold -report_dir $REPORTS_DIR/${CURRENT_STEP}
time_design -post_cts -drv -report_prefix ${TOP_MODULE}_time_post_cts_drv -report_dir $REPORTS_DIR/${CURRENT_STEP}

write_db ${DB_DIR}/${CURRENT_STEP}.db
