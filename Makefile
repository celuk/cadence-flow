GENUS_EXEC ?= genus
INNOVUS_EXEC ?= innovus

all:
	cd synth && ./run_synth.sh && cd .. && cd pr && ./run_pr_batch.sh

syn:
	cd synth && ./run_synth.sh && cd ..

pr:
	cd pr && ./run_pr_batch.sh && cd ..

clean:
	rm -rf \
		synth/rtl/netlist.sv \
		synth/rtl/xcelium.d \
		synth/rtl/*log* \
		synth/rtl/*history* \
		synth/rtl/*.txt \
		synth/.cadence \
		synth/LEC/ \
		synth/*.cmd \
		synth/*.log \
		synth/*.swp \
		synth/genus_synth* \
		synth/results \
		synth/reports \
		synth/.rs* \
		synth/.st_launch* \
		synth/.oa_import* \
		synth/*log* \
		pr/.cadence \
		pr/*log* \
		pr/ecoTimingDB \
		pr/results_pr \
		pr/saved \
		pr/timingReports \
		pr/reports \
		pr/.c0_soc* \
		pr/*.cmd \
		pr/*.bin \
		pr/*temp* \

cleansyn:
	rm -rf \
		synth/rtl/netlist.sv \
		synth/rtl/xcelium.d \
		synth/rtl/*log* \
		synth/rtl/*history* \
		synth/rtl/*.txt \
		synth/.cadence \
		synth/LEC/ \
		synth/*.cmd \
		synth/*.log \
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
		pr/*log* \
		pr/ecoTimingDB \
		pr/results_pr \
		pr/saved \
		pr/timingReports \
		pr/reports \
		pr/.c0_soc* \
		pr/*.cmd \
		pr/*.bin \
		pr/*temp* \
