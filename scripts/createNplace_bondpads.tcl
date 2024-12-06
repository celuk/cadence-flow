#get_db insts .base_cell.name -u
#get_db base_cell:$BONDPAD_CELL .class
#get_db base_cells -if {.class == pad}
#get_db base_cells -if {.class == block}
#get_db insts .name -u
#get_db insts -if {.base_cell.class == pad} -u
#get_db [get_db insts -if {.base_cell.class == pad} -u] .name
#get_db [get_db insts -if {.base_cell.class == block} -u] .name

proc createNplace_bondpads {args} {
  
  set bond_pad_ref_name ""

    # Manually parse the arguments
    foreach arg $args {
        if {[string match "-inline_pad_ref_name" $arg]} {
            # Get the next argument as the bond pad reference name
            set bond_pad_ref_name [lindex $args [expr {[lsearch $args $arg] + 1}]]
        }
    }

    # Check if the bond_pad_ref_name has been specified
    if {$bond_pad_ref_name eq ""} {
        echo "==== INFO: Please specify the inline bond pad reference name."
        return
    }

    # Check if the specified inline bond pad cell exists
    if {[get_db base_cells $bond_pad_ref_name] == ""} {
        echo "==== INFO: The specified inline bond pad cell $bond_pad_ref_name does not exist in the physical library."
        return
    }

  ## Get bond pad height & width
  set bond_pad_bbox [get_db [get_db base_cells $bond_pad_ref_name] .bbox]
  scan $bond_pad_bbox "{%f %f %f %f}" x0 y0 x1 y1
  set pad_width [expr {$x1 - $x0}]
  set pad_height [expr {$y1 - $y0}]

  ## Get all IO cells and filter out corner cells
  set io_cell_names [get_db [get_db insts -if {.base_cell.class == pad} -u] .name]
  set filtered_io_cell_list {}
  foreach cell $io_cell_names {
      if {![string match "CornerCell*" $cell]} {
          lappend filtered_io_cell_list $cell
      }
  }

  ## Remove pre-existing inline bond pad cells
  set exist_bond_pad_list [get_db [get_db [get_db insts -if {.base_cell.class == block} -u] -if {.name == "*_PAD"}] .name]
  if {$exist_bond_pad_list ne ""} {
      echo "==== INFO: Removing pre-existing inline bond pad cells for $bond_pad_ref_name."
      foreach pad $exist_bond_pad_list {
          delete_inst -inst $pad
      }
  }

  ## Place bond pads for each IO cell
  foreach io_cell $filtered_io_cell_list {
      set io_cell_bbox [get_db [get_cells $io_cell] .bbox]
      set io_cell_orient [get_db [get_cells $io_cell] .orient]

      scan $io_cell_bbox "{%f %f %f %f}" io_cell_LL_X io_cell_LL_Y io_cell_UR_X io_cell_UR_Y

      set bond_pad_name ""
      append bond_pad_name [get_db [get_cells $io_cell] .name] "_PAD"

      ## Update location and orientation based on IO cell orientation
      switch $io_cell_orient {
          "r90" {
              set new_orientation "r90"
              set bond_pad_LL_X [expr $io_cell_LL_X + 0.5]
              set bond_pad_LL_Y $io_cell_LL_Y
          }
          "r0" {
              set new_orientation "r0"
              set bond_pad_LL_X $io_cell_LL_X
              set bond_pad_LL_Y [expr $io_cell_UR_Y - $pad_height - 0.5]
          }
          "r270" {
              set new_orientation "r270"
              set bond_pad_LL_X [expr $io_cell_UR_X - $pad_height - 0.5]
              set bond_pad_LL_Y $io_cell_LL_Y
          }
          "r180" {
              set new_orientation "r180"
              set bond_pad_LL_X $io_cell_LL_X
              set bond_pad_LL_Y [expr $io_cell_LL_Y + 0.5]
          }
      }

      ## Create and place the bond pad
      create_inst \
          -base_cell $bond_pad_ref_name \
          -name $bond_pad_name \
          -location [list $bond_pad_LL_X $bond_pad_LL_Y] \
          -orient $new_orientation \
          -physical \
          -place_status fixed
  }

  ## Report the total number of added inline bond pads
  set new_bond_pad_list [get_db [get_db [get_db insts -if {.base_cell.class == block} -u] -if {.name == "*_PAD"}] .name]
  echo "==== INFO: Total added" [llength $new_bond_pad_list] "inline bond pad cells for $bond_pad_ref_name."
}
