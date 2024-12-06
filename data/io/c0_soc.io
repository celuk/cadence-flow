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

(globals
    version = 3
    io_order = default
)
(iopad
    (topright
	(inst name="trcorner"	cell="PCORNER" )
    )
    (top
	(inst  name="u_pads_pwr/VSS_0"	offset=200 place_status=placed )
	(inst  name="PDDW0204CDG_IN0"	offset=400 place_status=placed )
	(inst  name="PDDW0204CDG_IN1"	offset=600 place_status=placed )
	(inst  name="u_pads_pwr/VDDPST_0"	offset=800 place_status=placed )
    )
    (topleft
	(inst name="tlcorner"	cell="PCORNER" )
    )
    (left
	(inst  name="u_pads_pwr/VDDPST_1"	offset=200 place_status=placed )
	(inst  name="PDDW0204CDG_IN_RSTN"	offset=400 place_status=placed )
	(inst  name="PDDW0204CDG_IN_CLK"	offset=600 place_status=placed )
	(inst  name="u_pads_pwr/VDD_0"	offset=800 place_status=placed )
    )
    (bottomleft
	(inst name="blcorner"	cell="PCORNER" )
    )
    (bottom
	(inst  name="u_pads_pwr/VDD2POC"	offset=200 place_status=placed )
	(inst  name="PDDW0204CDG_OUT0"	offset=400 place_status=placed )
	(inst  name="PDDW0204CDG_OUT1"	offset=600 place_status=placed )
	(inst  name="u_pads_pwr/VDD_1"	offset=800 place_status=placed )
    )
    (bottomright
	(inst name="brcorner"	cell="PCORNER" )
    )
    (right
	(inst  name="u_pads_pwr/VSS_1"	offset=200 place_status=placed )
	(inst  name="PDDW0204CDG_OUT2"	offset=400 place_status=placed )
	(inst  name="PDDW0204CDG_OUT3"	offset=600 place_status=placed )
	(inst  name="PDDW0204CDG_OUT4"	offset=800 place_status=placed )
    )
)
