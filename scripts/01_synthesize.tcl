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

set CURRENT_STEP $SYNTH_BLOCK

set_genus_options

read_mmmc scripts/mmmc.tcl

set_db init_power_nets  {VDD VDDPST}
set_db init_ground_nets {VSS}

read_physical -lefs " \
    $STD_LEF \
    $IO_LEF \
    $BONDPAD_LEF \
"

#read_physical -oa_ref_libs " \
#    $STDCELL_LIB_NAME \
#    $IO_LIB_NAME \
#    $BONDPAD_LIB_NAME \
#    $SEALRING_LIB_NAME \
#"

#read_stream "
#    $TSMCHOME_STD_GDS
#    $TSMCHOME_IO_GDS
#    $TSMCHOME_WB_BONDPAD_GDS
#    $TSMCHOME_SEALRING_WLCSP_GDS
#" -layer_map "$TSMCHOME_GDSOUT_MAP_FILE"

read_hdl -sv $VERILOG_FILES

elaborate $TOP_MODULE
timestat ELABORATE

init_design -top $TOP_MODULE

syn_generic $DESIGN_NAME
timestat GENERIC

syn_map $DESIGN_NAME
timestat MAPPED

syn_opt $DESIGN_NAME
timestat OPT

redirect -file $REPORTS_DIR/${CURRENT_STEP}/${TOP_MODULE}_timing_intent.rpt {check_timing_intent -verbose}
redirect -file $REPORTS_DIR/${CURRENT_STEP}/${TOP_MODULE}_design.rpt {check_design -unresolved}
redirect -file $REPORTS_DIR/${CURRENT_STEP}/${TOP_MODULE}_qor.rpt {report_qor $DESIGN_NAME}
redirect -file $REPORTS_DIR/${CURRENT_STEP}/${TOP_MODULE}_timing.rpt {report_timing}

write_design -innovus -basename ${DB_DIR}/$DESIGN_NAME

write_db ${DB_DIR}/${CURRENT_STEP}.db
