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

#XCELIUM_EXEC ?= xrun
GENUS_EXEC ?= genus
INNOVUS_EXEC ?= innovus

OUTPUTS_DIR ?= outputs
REPORTS_DIR ?= reports
LOGS_DIR ?= logs
DB_DIR ?= dlibs

script1  ?= scripts/01_synthesize.tcl
script2  ?= scripts/02_init_design.tcl
script3  ?= scripts/03_design_planning.tcl
script4  ?= scripts/04_placement.tcl
script5  ?= scripts/05_cts.tcl
script6  ?= scripts/06_routing.tcl
script7  ?= scripts/07_signoff_extraction.tcl
script8  ?= scripts/08_signoff_opt.tcl
script9  ?= scripts/09_signoff_metal_fill.tcl
script10 ?= scripts/10_signoff_drc.tcl
script11 ?= scripts/11_signoff_lvs.tcl
script12 ?= scripts/12_streamout.tcl

$(LOGS_DIR):
	mkdir -p $(LOGS_DIR)

all: s1 s2 s3 s4 s5 s6 s7 s8 s9 s10 s11 s12

s1: $(LOGS_DIR)
	$(GENUS_EXEC) -abort_on_error -batch -overwrite -files $(script1) | tee $(LOGS_DIR)/$(shell basename $(script1) .tcl | sed 's|^.*/||').log

s2:
	$(INNOVUS_EXEC) -stylus -abort_on_error -batch -files $(script2) | tee $(LOGS_DIR)/$(shell basename $(script2) .tcl | sed 's|^.*/||').log

s3:
	$(INNOVUS_EXEC) -stylus -abort_on_error -batch -files $(script3) | tee $(LOGS_DIR)/$(shell basename $(script3) .tcl | sed 's|^.*/||').log

s4:
	$(INNOVUS_EXEC) -stylus -abort_on_error -batch -files $(script4) | tee $(LOGS_DIR)/$(shell basename $(script4) .tcl | sed 's|^.*/||').log

s5:
	$(INNOVUS_EXEC) -stylus -abort_on_error -batch -files $(script5) | tee $(LOGS_DIR)/$(shell basename $(script5) .tcl | sed 's|^.*/||').log

s6:
	$(INNOVUS_EXEC) -stylus -abort_on_error -batch -files $(script6) | tee $(LOGS_DIR)/$(shell basename $(script6) .tcl | sed 's|^.*/||').log

s7:
	$(INNOVUS_EXEC) -stylus -abort_on_error -batch -files $(script7) | tee $(LOGS_DIR)/$(shell basename $(script7) .tcl | sed 's|^.*/||').log

s8:
	$(INNOVUS_EXEC) -stylus -abort_on_error -batch -files $(script8) | tee $(LOGS_DIR)/$(shell basename $(script8) .tcl | sed 's|^.*/||').log

s9:
	$(INNOVUS_EXEC) -stylus -abort_on_error -batch -files $(script9) | tee $(LOGS_DIR)/$(shell basename $(script9) .tcl | sed 's|^.*/||').log

s10:
	$(INNOVUS_EXEC) -stylus -abort_on_error -batch -files $(script10) | tee $(LOGS_DIR)/$(shell basename $(script10) .tcl | sed 's|^.*/||').log

s11:
	$(INNOVUS_EXEC) -stylus -abort_on_error -batch -files $(script11) | tee $(LOGS_DIR)/$(shell basename $(script11) .tcl | sed 's|^.*/||').log

s12:
	$(INNOVUS_EXEC) -stylus -abort_on_error -batch -files $(script12) | tee $(LOGS_DIR)/$(shell basename $(script12) .tcl | sed 's|^.*/||').log

clean:
	rm -rf xcelium.d \

cleansyn:
	rm -rf \
		synth/rtl/netlist.sv \
		synth/rtl/xcelium.d \
		synth/rtl/*log* \
		synth/rtl/*history* \
		synth/rtl/*.txt \
		synth/.cadence \
		synth/LEC/ \
		synth/*cmd* \
		synth/*log* \
		synth/*.swp \
		synth/genus_synth* \
		synth/results \
		synth/reports \
		synth/.rs* \
		synth/.st_launch* \
		synth/.oa_import* \

cleanpr:
	rm -rf \
		pr/.cadence \
		pr/.Genus* \
		pr/*.log* \
		pr/*rpt* \
		pr/*old* \
		pr/ecoTimingDB \
		pr/results_pr \
		pr/saved \
		pr/timingReports \
		pr/reports \
		pr/.c0_soc* \
		pr/*cmd* \
		pr/*.bin \
		pr/*temp* \
		pr/*.map \
		pr/*.rpt \
		pr/*_launch* \
		pr/*_client* \
		pr/.timing* \

fp: cleanpr
	cd pr && \
	innovus -stylus -files "scripts/01_initialize_design.tcl \
	scripts/02_connect_power_to_gates.tcl \
	scripts/03_create_floorplan.tcl";
#	innovus -stylus -batch -files scripts/01_initialize_design.tcl && \
#	innovus -stylus -batch -files scripts/02_connect_power_to_gates.tcl && \
#	innovus -stylus -batch -files scripts/03_create_floorplan.tcl && \
#	innovus -stylus -files scripts/load_implemented_ic2.tcl;
