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

set PREVIOUS_STEP $SMFILL_BLOCK
set CURRENT_STEP $SDRC_BLOCK

read_db ${DB_DIR}/${PREVIOUS_STEP}.db

set_innovus_options

#delete_routes -regular_wire_with_drc
#route_eco -fix_drc
#route_eco

redirect -file $REPORTS_DIR/${CURRENT_STEP}/${TOP_MODULE}_check_drc.rpt {check_drc}

#write_stream ${OUTPUTS_DIR}/${DESIGN_NAME}.gds -unit 1000 -merge $GDS_FILES_TO_MERGE -map_file $GDSOUT_MAP_FILE
#run_pvs_drc_rules $DRC_DECK -gds_file ${OUTPUTS_DIR}/${DESIGN_NAME}.gds

#read_markers c0_soc.ascii -rule_map_file $DRC_DECK -type pvs
#route_fix_signoff_drc

write_db ${DB_DIR}/${CURRENT_STEP}.db
