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

XCELIUM_EXEC ?= xrun
GENUS_EXEC ?= genus
INNOVUS_EXEC ?= innovus

TSMCHOME ?=

TOP_MODULE = c0_soc
OUTPUTS_DIR = outputs
NETLIST_PATH = $(OUTPUTS_DIR)
NETLIST = $(NETLIST_PATH)/$(TOP_MODULE)_netlist.sv

RTL_PATH = data/rtl

IO_VERILOG_MODEL =
XRUN_PARAMS :=
XRUN_PARAMS += -v $(IO_VERILOG_MODEL)
XRUN_PARAMS += -timescale 1ns/1ps
XRUN_PARAMS += +nowarnTRNNOP

rwildcard = $(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2) $(filter $(subst *,%,$2),$d))
#rwildcard = $(foreach d,$(wildcard $1*),$(if $(wildcard $d),$(call rwildcard,$d/,$2),$(filter $(subst *,%,$2),$d)))
VERILOG_FILES = $(call rwildcard,$(RTL_PATH),*)

all: netlist

netlist: $(NETLIST)
	@$(XCELIUM_EXEC) \
		-clean \
		-elaborate $(NETLIST) $(XRUN_PARAMS) \
		-incdir $(RTL_PATH) \
		-top $(TOP_MODULE)

$(NETLIST): $(VERILOG_FILES)
	@mkdir -p $(dir $@)
	cat $(VERILOG_FILES) > $@

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
