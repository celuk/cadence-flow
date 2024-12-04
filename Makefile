GENUS_EXEC ?= genus
INNOVUS_EXEC ?= innovus

all:
	cd synth && ./run_synth.sh && cd .. && cd pr && ./run_pr_batch.sh

syn:
	cd synth && ./run_synth.sh && cd ..

pnr:
	cd pr && ./run_pr_batch.sh && cd ..

clean: cleansyn cleanpr

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
