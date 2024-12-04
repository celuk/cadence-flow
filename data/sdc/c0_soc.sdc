set_units -capacitance 1.0pF
set_units -time 1.0ns
set_time_unit -nanoseconds
set_load_unit -picofarads

#create_clock clk_i -period 10

create_clock -p 10 [get_pins PDDW0204CDG_IN_CLK/C]

set_input_transition 1 [all_inputs]

set_load 2 [all_outputs]

set_dont_touch [get_cells u_pads_pwr]

