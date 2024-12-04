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

set TSMCHOME ""

set STD_LEF ""
set IO_LEF ""
set BONDPAD_LEF ""

set TSMCHOME_STD_LEF ""
set EDITED_STD_LEF ""
set TSMCHOME_IO_LEF ""
set TSMCHOME_BONDPAD_LEF ""

set STD_TIMING_LIB_PATH ""
set IO_TIMING_LIB_PATH ""

set NCCOM_LIB  ""
set BCCOM_LIB  ""
set LTCOM_LIB  ""
set MLCOM_LIB  ""
set WCCOM_LIB  ""
set WCLCOM_LIB ""
set WCZCOM_LIB ""

set NCCOM1_LIB  ""
set BCCOM1_LIB  ""
set LTCOM1_LIB  ""
set MLCOM1_LIB  ""
set WCCOM1_LIB  ""
set WCLCOM1_LIB ""
set WCZCOM1_LIB ""

set TSMCHOME_STD_TIMING_LIB_PATH ""
set TSMCHOME_IO_TIMING_LIB_PATH ""

set GDSOUT_MAP_FILE ""

set TSMCHOME_GDSOUT_MAP_FILE ""
set VIRTUOSO_GDSOUT_MAP_FILE ""

set QRC_TECH_FILE ""

set PARASITICS_MAX_CAPTABLE ""
set PARASITICS_NOM_CAPTABLE ""
set PARASITICS_MIN_CAPTABLE ""

set TSMCHOME_PARASITICS_MAX_CAPTABLE ""
set TSMCHOME_PARASITICS_NOM_CAPTABLE ""
set TSMCHOME_PARASITICS_MIN_CAPTABLE ""

set GDS_FILES_TO_MERGE [list \
];

set TSMCHOME_STD_GDS ""
set TSMCHOME_IO_GDS ""
set TSMCHOME_BONDPAD_GDS ""
set TSMCHOME_WB_BONDPAD_GDS ""
set TSMCHOME_SEALRING_WLCSP_GDS ""

set METAL_FILL_FEOL_DECK ""
set METAL_FILL_BEOL_DECK ""
set DRC_DECK ""
set ANTENNA_DRC_DECK ""
set MIM_ANTENNA_DRC_DECK ""
set LVS_DECK ""

set TIE_CELLS [list \
];

set BONDPAD_CELL ""

set CTS_INV_CELLS [list \
];

set CTS_BUF_CELLS [list \
];

set STD_FILLER_CELLS [list \
];

set IO_PAD_FILLER_CELLS [list \
];

set BUFFER_CELLS [list \
];

set STDCELL_LIB_NAME ""
set IO_LIB_NAME ""
set BONDPAD_LIB_NAME ""
set SEALRING_LIB_NAME ""

set CTS_INV_CELL_REGEXP ""
set CTS_BUF_CELL_REGEXP ""

set TAP_CELL ""

set METAL_FILLER_CELLS [list \
];

set BOUNDARY_CELLS $METAL_FILLER_CELLS
set BOUNDARY_CELL ""

set NON_METAL_FILLER_CELLS [list \
];

set ALL_TIE_CELLS [list \
];

set ALL_IO_PAD_FILLER_CELLS [list \
];

set STD_LEVEL_SHIFTER_CELLS [list \
];
set IO_LEVEL_SHIFTER_CELLS [list \
];

set STD_ISOLATION_CELLS [list \
];
set IO_ISOLATION_CELLS [list \
];

set TT_OPC_STDCELL ""
set BC_OPC_STDCELL ""
set LT_OPC_STDCELL ""
set ML_OPC_STDCELL ""
set WC_OPC_STDCELL ""
set WCZ_OPC_STDCELL ""
set WCL_OPC_STDCELL ""

set TT_OPC_IO ""
set BC_OPC_IO ""
set LT_OPC_IO ""
set ML_OPC_IO ""
set WC_OPC_IO ""
set WCZ_OPC_IO ""
set WCL_OPC_IO ""
