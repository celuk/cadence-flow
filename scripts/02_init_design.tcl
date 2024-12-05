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

set CURRENT_STEP $INIT_BLOCK

set_innovus_options

set_db init_power_nets  {VDD VDDPST}
set_db init_ground_nets {VSS}

source ${DB_DIR}/${DESIGN_NAME}.invs_setup.tcl

read_io_file c0_soc.io

create_floorplan -box_size {0 0 1000 1000 75 75 925 925 125 125 875 875}

legalize_floorplan -check_orient
legalize_floorplan -check_site

write_db ${DB_DIR}/${CURRENT_STEP}.db
