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

set PROCESS_NODE 65

set TOP_MODULE "c0_soc"
set DESIGN_NAME "${TOP_MODULE}"
set DESIGN_LIBRARY ${DESIGN_NAME}.nlib

set OUTPUTS_DIR "outputs"
set REPORTS_DIR "reports"
set DB_DIR "saved"
set LOGS_DIR "logs"
set LEC_DIR "LEC"

set GATE_LEVEL_VERILOG ${OUTPUTS_DIR}/${TOP_MODULE}_gate_level.v

#set_app_options -name search_path -value "."
set search_path "."
set RTL_PATH "data/rtl"
set SDC_PATH "data/sdc"
set TECH_PATH "data/tech"
set LOGO_PATH "data/logo"

lappend search_path $RTL_PATH
lappend search_path $SDC_PATH
lappend search_path $TECH_PATH
lappend search_path $LOGO_PATH

source scripts/00_pdk_setup.tcl

set LOGO_FILE "${LOGO_PATH}/kasirga_logo.bmp"

set CONSTRAINT_FILE "${SDC_PATH}/${DESIGN_NAME}.sdc"

#set GDSOUT_MAP_FILE $TSMCHOME_GDSOUT_MAP_FILE

set STREAMOUT_GDS_FILE "${OUTPUTS_DIR}/${DESIGN_NAME}.gds"
set STREAMOUT_DEF_FILE "${OUTPUTS_DIR}/${DESIGN_NAME}.def"
set STREAMOUT_SDF_FILE "${OUTPUTS_DIR}/${DESIGN_NAME}.sdf"
set STREAMOUT_PARASITICS_FILE "${OUTPUTS_DIR}/${DESIGN_NAME}.spef"

#set GDS_FILES_TO_MERGE [list \
#${TSMCHOME_SEALRING_WLCSP_GDS} \
#];

set STREAMOUT_RESOLUTION 1000

set CLK clk_i

set POWER_NET "VDD"
set GROUND_NET "VSS"

set MIN_ROUTING_LAYER 3
set MAX_ROUTING_LAYER 9

set CTS_LIB_CELL_PATTERNS "*/BUF */INV*"

#set IO_PAD_FILLER_CELLS $ALL_IO_PAD_FILLER_CELLS

set MAX_TRANSITION 0.5
set MAX_FANOUT 20

## borrowed from: https://wiki.tcl-lang.org/page/recursive%5Fglob
proc rglob {dirlist globlist} {
    set result {}
    set recurse {}
    foreach dir $dirlist {
        if ![file isdirectory $dir] {
            return -code error "'$dir' is not a directory"
        }
        foreach pattern $globlist {
            lappend result {*}[glob -nocomplain -directory $dir -- $pattern]
        }
        foreach file [glob -nocomplain -directory $dir -- *] {
            set file [file join $dir $file]
            if [file isdirectory $file] {
                set fileTail [file tail $file]
                if {!($fileTail eq "." || $fileTail eq "..")} {
                    lappend recurse $file
                }
            }
        }
    }
    if {[llength $recurse] > 0} {
        lappend result {*}[rglob $recurse $globlist]
    }
    return $result
}

set VERILOG_FILES [rglob data/rtl/ *]

set SYNTH_BLOCK 01-synthesize
set INIT_BLOCK 02-init_design
set COMPILE_BLOCK 03-compile
set DPLAN_BLOCK 04-design_planning
set PLACE_BLOCK 05-placement
set CTS_BLOCK 06-cts
set ROUTING_BLOCK 07-routing
set SEXTRACT_BLOCK 08-signoff_extraction
set SMFILL_BLOCK 09-signoff_metal_fill
set SDRC_BLOCK 10-signoff_drc
set SLVS_BLOCK 11-signoff_lvs
set STREAMOUT_BLOCK 12-streamout

if { ![file exists $OUTPUTS_DIR] } {
    file mkdir $OUTPUTS_DIR
}
if { ![file exists $REPORTS_DIR] } {
    file mkdir $REPORTS_DIR
}
if { ![file exists $DB_DIR] } {
    file mkdir $DB_DIR
}
if { ![file exists $LOGS_DIR] } {
    file mkdir $LOGS_DIR
}

set counter 1

foreach block {
    SYNTH_BLOCK
    INIT_BLOCK
    COMPILE_BLOCK
    DPLAN_BLOCK
    PLACE_BLOCK
    CTS_BLOCK
    ROUTING_BLOCK
    SEXTRACT_BLOCK
    SMFILL_BLOCK
    SDRC_BLOCK
    SLVS_BLOCK
    STREAMOUT_BLOCK
} {
    set block_name [set $block]
    if { ![file exists $REPORTS_DIR/$block_name] } {
        file mkdir $REPORTS_DIR/$block_name
    }
    incr counter
}

proc set_genus_options {} {
    global \
    LEC_DIR

    set_db design_process_node $PROCESS_NODE

    set_db syn_generic_effort medium
    set_db syn_map_effort medium
    set_db syn_opt_effort medium

    set_db information_level 6

    set_db remove_assigns true

    set_db max_cpus_per_server 8
    set_db enable_domain_name_check 0

    set_db hdl_use_cw_first false
    set_db wlec_set_cdn_synth_root true

    set_db use_power_ground_pin_from_lef true

    set_db hdl_track_filename_row_col true
    set_db verification_directory_naming_style $LEC_DIR

    set_db lp_insert_clock_gating false

    set_db auto_super_thread true
    set_db / .max_cpus_per_server 8

    set_db hdl_error_on_latch false
}

proc set_innovus_options {} {
    global \
    MIN_ROUTING_LAYER \
    MAX_ROUTING_LAYER

    set_db design_flow_effort standard
    set_db design_process_node $PROCESS_NODE
    set_db init_design_uniquify {1}
    set_db init_no_new_assigns true
    set_db route_design_bottom_routing_layer $MIN_ROUTING_LAYER
    set_db route_design_top_routing_layer $MAX_ROUTING_LAYER

    set_distributed_hosts -local
    set_multi_cpu_usage -local_cpu 8 -remote_host 1 -cpu_per_remote_host 1

    set_db timing_analysis_type ocv
    set_db timing_analysis_cppr both
}
