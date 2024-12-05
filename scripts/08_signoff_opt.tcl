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

set PREVIOUS_STEP $SEXTRACT_BLOCK
set CURRENT_STEP $SOPT_BLOCK

read_db ${DB_DIR}/${PREVIOUS_STEP}.db

set_innovus_options

set_interactive_constraint_modes [all_constraint_modes -active]

set_propagated_clock [all_clocks]
set_db timing_analysis_async_checks async

time_design_signoff -report_prefix $REPORTS_DIR/${CURRENT_STEP}/${TOP_MODULE}_signoff_time -report_only -report_dir $REPORTS_DIR/${CURRENT_STEP}

delete_filler

set_db opt_signoff_setup_target_slack 0.2

opt_signoff -drv \
    -no_eco_route \
    -report_prefix $REPORTS_DIR/${CURRENT_STEP}/${TOP_MODULE}_signoff_opt_drv \
    -report_dir $REPORTS_DIR/${CURRENT_STEP} \

opt_signoff -hold \
    -no_eco_route \
    -report_prefix $REPORTS_DIR/${CURRENT_STEP}/${TOP_MODULE}_signoff_opt_hold \
    -report_dir $REPORTS_DIR/${CURRENT_STEP}

opt_signoff -setup \
    -no_eco_route \
    -report_prefix $REPORTS_DIR/${CURRENT_STEP}/${TOP_MODULE}_signoff_opt_setup \
    -report_dir $REPORTS_DIR/${CURRENT_STEP}

add_fillers
route_eco
extract_rc

time_design_signoff -report_prefix $REPORTS_DIR/${CURRENT_STEP}/${TOP_MODULE}_signoff_time_opt -report_only -report_dir $REPORTS_DIR/${CURRENT_STEP}

write_db ${DB_DIR}/${CURRENT_STEP}.db
