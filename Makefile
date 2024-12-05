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

SETUP_TCL ?= scripts/00_setup.tcl

OUTPUTS_DIR ?= outputs
REPORTS_DIR ?= reports
LOGS_DIR ?= logs
DB_DIR ?= dlibs

SYNTH_BLOCK     = 01-synthesize
INIT_BLOCK      = 02-init_design
DPLAN_BLOCK     = 03-design_planning
PLACE_BLOCK     = 04-placement
CTS_BLOCK       = 05-cts
ROUTING_BLOCK   = 06-routing
SEXTRACT_BLOCK  = 07-signoff_extraction
SOPT_BLOCK      = 08-signoff_opt
SMFILL_BLOCK    = 09-signoff_metal_fill
SDRC_BLOCK      = 10-signoff_drc
SLVS_BLOCK      = 11-signoff_lvs
STREAMOUT_BLOCK = 12-streamout

ALL_BLOCKS = $(SYNTH_BLOCK) \
			 $(INIT_BLOCK) \
			 $(DPLAN_BLOCK) \
			 $(PLACE_BLOCK) \
			 $(CTS_BLOCK) \
             $(ROUTING_BLOCK) \
			 $(SEXTRACT_BLOCK) \
			 $(SOPT_BLOCK) \
			 $(SMFILL_BLOCK) \
             $(SDRC_BLOCK) \
			 $(SLVS_BLOCK) \
			 $(STREAMOUT_BLOCK)

script1  ?= scripts/$(subst -,_,$(SYNTH_BLOCK)).tcl
script2  ?= scripts/$(subst -,_,$(INIT_BLOCK)).tcl
script3  ?= scripts/$(subst -,_,$(DPLAN_BLOCK)).tcl
script4  ?= scripts/$(subst -,_,$(PLACE_BLOCK)).tcl
script5  ?= scripts/$(subst -,_,$(CTS_BLOCK)).tcl
script6  ?= scripts/$(subst -,_,$(ROUTING_BLOCK)).tcl
script7  ?= scripts/$(subst -,_,$(SEXTRACT_BLOCK)).tcl
script8  ?= scripts/$(subst -,_,$(SOPT_BLOCK)).tcl
script9  ?= scripts/$(subst -,_,$(SMFILL_BLOCK)).tcl
script10 ?= scripts/$(subst -,_,$(SDRC_BLOCK)).tcl
script11 ?= scripts/$(subst -,_,$(SLVS_BLOCK)).tcl
script12 ?= scripts/$(subst -,_,$(STREAMOUT_BLOCK)).tcl

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
	rm -rf \
		xcelium.d \
		*log* \
		*.log* \
		*rpt* \
		*old* \
		*history* \
		*.txt \
		.cadence \
		LEC/ \
		*cmd* \
		*log* \
		*.swp \
		genus_synth* \
		outputs \
		reports \
		logs \
		dlibs \
		.rs* \
		*.tstamp \
		.st_launch* \
		.oa_import* \
		.Genus* \
		ecoTimingDB \
		*cmd* \
		*.bin \
		*temp* \
		*.rpt \
		*.map \
		*_launch* \
		*_client* \
		.timing* \
		open_block.tcl

show show_cli:
	$(eval IS_CLI := $(filter show_cli,$(MAKECMDGOALS))) \
	$(eval SHOW_ARGS := $(if $(IS_CLI),$(shell echo "$(MAKECMDGOALS)" | sed -n 's/.*show_cli *\([^ ]*\).*/\1/p'),$(shell echo "$(MAKECMDGOALS)" | sed -n 's/.*show *\([^ ]*\).*/\1/p'))) \
	$(eval LATEST_BLOCK_NAME := $(lastword $(ALL_BLOCKS))) \
	if [ -n "$(SHOW_ARGS)" ]; then \
		block=$$(echo "$(ALL_BLOCKS)" | tr ' ' '\n' | grep -E "^0?$(SHOW_ARGS)-" | head -n 1); \
		if [ -z "$$block" ]; then \
			echo "No matching block found for input: '$(SHOW_ARGS)'."; \
			exit 1; \
		fi; \
	else \
		block_found=false; \
		for block in $$(echo "$(ALL_BLOCKS)" | tr ' ' '\n' | tac); do \
			latest_block=$$(echo $$block); \
			if [ -f "$(DB_DIR)/$$latest_block.db" ] || [ -d "$(DB_DIR)/$$latest_block.db" ]; then \
				block=$$latest_block; \
				block_found=true; \
				break; \
			fi; \
		done; \
		if [ "$$block_found" = false ]; then \
			echo "No matching block found."; \
			exit 1; \
		fi; \
	fi; \
	echo "read_db $(DB_DIR)/$$block.db" > open_block.tcl; \
	echo "source $(SETUP_TCL);" >> open_block.tcl; \
	if [ -n "$(IS_CLI)" ]; then \
		$(INNOVUS_EXEC) -stylus -abort_on_error -no_gui -files open_block.tcl; \
	else \
		echo "gui_set_draw_view place" >> open_block.tcl; \
		echo "gui_show" >> open_block.tcl; \
		$(INNOVUS_EXEC) -stylus -abort_on_error -files open_block.tcl; \
	fi; 
	rm -f open_block.tcl

%:
	@:
