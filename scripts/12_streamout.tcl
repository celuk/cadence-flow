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

set PREVIOUS_STEP $SLVS_BLOCK
set CURRENT_STEP $STREAMOUT_BLOCK

read_db ${DB_DIR}/${PREVIOUS_STEP}.db

set_innovus_options

set_db write_stream_label_all_pin_shape true
set_db write_stream_check_map_file true

write_stream ${OUTPUTS_DIR}/${DESIGN_NAME}.gds -unit 1000 -merge $GDS_FILES_TO_MERGE -map_file $GDSOUT_MAP_FILE

redirect -file $REPORTS_DIR/${CURRENT_STEP}/${TOP_MODULE}_check_drc.rpt {check_drc}
redirect -file $REPORTS_DIR/${CURRENT_STEP}/${TOP_MODULE}_check_connectivity.rpt {check_connectivity}

write_db ${DB_DIR}/${CURRENT_STEP}.db

source scripts/bmp2lay_offset.tcl
bmp2lay -f $LOGO_FILE -layer AP -px 1 -py 1 -offsetx 244 -offsety 244

write_stream ${OUTPUTS_DIR}/${DESIGN_NAME}.wlogo.gds -unit 1000 -merge $GDS_FILES_TO_MERGE -map_file $GDSOUT_MAP_FILE

redirect -file $REPORTS_DIR/${CURRENT_STEP}/${TOP_MODULE}_check_drc_wlogo.rpt {check_drc}
redirect -file $REPORTS_DIR/${CURRENT_STEP}/${TOP_MODULE}_check_connectivity_wlogo.rpt {check_connectivity}


# write_sdf -edges noedge -max_view WC_av -min_view BC_av ${OUTPUTS_DIR}/${DESIGN_NAME}.sdf
write_sdf -edges noedge -max_view WCL_av -min_view BC_av \
    -version 3.0 \
    -recompute_delaycal \
    -recompute_parallel_arcs \
    ${OUTPUTS_DIR}/${DESIGN_NAME}.sdf

#save flattened netlist
#write_netlist -flat \
#    -include_pg_ports \
#    -include_phys_insts \
#    -omit_floating_ports \
#    -exclude_leaf_cells \
#    ${OUTPUTS_DIR}/${DESIGN_NAME}_flat.v

# write_netlist \
#     -include_pg_ports \
#     -include_phys_insts \
#     -omit_floating_ports \
#     -exclude_leaf_cells \
#     ${OUTPUTS_DIR}/${DESIGN_NAME}_nonflat.v

write_netlist ${OUTPUTS_DIR}/${DESIGN_NAME}.noPower.v

#write_netlist  -flat  ${OUTPUTS_DIR}/${DESIGN_NAME}.noPower.flat.v

# create_pin_text -cells "$TOP_MODULE" ${OUTPUTS_DIR}/${DESIGN_NAME}_pins.txt

# write_def -floorplan ${OUTPUTS_DIR}/${DESIGN_NAME}_floorplan.def

report_qor -format html -file $reportDir/15_qor.html
report_area -out_file $reportDir/15_area.rpt

write_db ${DB_DIR}/${CURRENT_STEP}.db
