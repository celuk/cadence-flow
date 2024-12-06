create_library_set -name TC_stdcell_libs  -timing "$NCCOM_LIB"
create_library_set -name BC_stdcell_libs  -timing "$BCCOM_LIB"
create_library_set -name LT_stdcell_libs  -timing "$LTCOM_LIB"
create_library_set -name ML_stdcell_libs  -timing "$MLCOM_LIB"
create_library_set -name WC_stdcell_libs  -timing "$WCCOM_LIB"
create_library_set -name WCL_stdcell_libs -timing "$WCLCOM_LIB"
create_library_set -name WCZ_stdcell_libs -timing "$WCZCOM_LIB"

create_library_set -name TC_iocell_libs  -timing "$NCCOM1_LIB"
create_library_set -name BC_iocell_libs  -timing "$BCCOM1_LIB"
create_library_set -name LT_iocell_libs  -timing "$LTCOM1_LIB"
create_library_set -name ML_iocell_libs  -timing "$MLCOM1_LIB"
create_library_set -name WC_iocell_libs  -timing "$WCCOM1_LIB"
create_library_set -name WCL_iocell_libs -timing "$WCLCOM1_LIB"
create_library_set -name WCZ_iocell_libs -timing "$WCZCOM1_LIB"

create_opcond -name TC_opcond  -process 1 -voltage 1.2 -temperature 25
create_opcond -name BC_opcond  -process 1 -voltage 1.32 -temperature 0
create_opcond -name LT_opcond  -process 1 -voltage 1.32 -temperature -40
create_opcond -name ML_opcond  -process 1 -voltage 1.32 -temperature 125
create_opcond -name WC_opcond  -process 1 -voltage 1.08 -temperature 125
create_opcond -name WCL_opcond -process 1 -voltage 1.08 -temperature -40
create_opcond -name WCZ_opcond -process 1 -voltage 1.08 -temperature 0

create_timing_condition -name TC_tc  -opcond TC_opcond  -library_sets "TC_stdcell_libs  TC_iocell_libs"
create_timing_condition -name BC_tc  -opcond BC_opcond  -library_sets "BC_stdcell_libs  BC_iocell_libs"
create_timing_condition -name LT_tc  -opcond LT_opcond  -library_sets "LT_stdcell_libs  LT_iocell_libs"
create_timing_condition -name ML_tc  -opcond ML_opcond  -library_sets "ML_stdcell_libs  ML_iocell_libs"
create_timing_condition -name WC_tc  -opcond WC_opcond  -library_sets "WC_stdcell_libs  WC_iocell_libs"
create_timing_condition -name WCL_tc -opcond WCL_opcond -library_sets "WCL_stdcell_libs WCL_iocell_libs"
create_timing_condition -name WCZ_tc -opcond WCZ_opcond -library_sets "WCZ_stdcell_libs WCZ_iocell_libs"

create_rc_corner -name RC_corner_typical -cap_table $PARASITICS_NOM_CAPTABLE -qrc_tech $QRC_TECH_FILE
create_rc_corner -name RC_corner_rcworst -cap_table $PARASITICS_MAX_CAPTABLE -qrc_tech $QRC_TECH_FILE
create_rc_corner -name RC_corner_rcbest  -cap_table $PARASITICS_MIN_CAPTABLE -qrc_tech $QRC_TECH_FILE

#create_rc_corner -name RC_corner_typical -qrc_tech $QRC_TECH_FILE
#create_rc_corner -name RC_corner_rcworst -qrc_tech $QRC_TECH_FILE
#create_rc_corner -name RC_corner_rcbest  -qrc_tech $QRC_TECH_FILE

#create_rc_corner -name RCcorner_cworst  -qrc_tech $QRC_TECH_FILE
#create_rc_corner -name RCcorner_cbest   -qrc_tech $QRC_TECH_FILE

create_delay_corner -name TC_dc  -timing_condition TC_tc  -rc_corner RC_corner_typical
create_delay_corner -name BC_dc  -timing_condition BC_tc  -rc_corner RC_corner_rcbest
create_delay_corner -name LT_dc  -timing_condition LT_tc  -rc_corner RC_corner_rcbest
create_delay_corner -name ML_dc  -timing_condition ML_tc  -rc_corner RC_corner_rcbest
create_delay_corner -name WC_dc  -timing_condition WC_tc  -rc_corner RC_corner_rcworst
create_delay_corner -name WCL_dc -timing_condition WCL_tc -rc_corner RC_corner_rcworst
create_delay_corner -name WCZ_dc -timing_condition WCZ_tc -rc_corner RC_corner_rcworst

create_constraint_mode -name standard_cm -sdc_files "$CONSTRAINT_FILE"

create_analysis_view -name TC_av  -delay_corner TC_dc  -constraint_mode standard_cm
create_analysis_view -name BC_av  -delay_corner BC_dc  -constraint_mode standard_cm
create_analysis_view -name LT_av  -delay_corner LT_dc  -constraint_mode standard_cm
create_analysis_view -name ML_av  -delay_corner ML_dc  -constraint_mode standard_cm
create_analysis_view -name WC_av  -delay_corner WC_dc  -constraint_mode standard_cm
create_analysis_view -name WCL_av -delay_corner WCL_dc -constraint_mode standard_cm
create_analysis_view -name WCZ_av -delay_corner WCZ_dc -constraint_mode standard_cm

set_analysis_view \
    -hold  "BC_av LT_av ML_av" \
    -setup "WC_av WCL_av WCZ_av" \
    -leakage ML_av \
    -dynamic LT_av
