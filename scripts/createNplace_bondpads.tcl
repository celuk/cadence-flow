set c0_io_lib ""

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
    if {[get_lib_cells $bond_pad_ref_name] == ""} {
        echo "==== INFO: The specified inline bond pad cell $bond_pad_ref_name does not exist in the physical library."
        return
    }

  ## Get bond pad height & width
  set bond_pad_bbox [get_db [get_lib_cells $bond_pad_ref_name] .bbox]
  set pad_width [expr [lindex $bond_pad_bbox 1] - [lindex $bond_pad_bbox 0]]
  set pad_height [expr [lindex $bond_pad_bbox 3] - [lindex $bond_pad_bbox 2]]

  ## Get all IO cells and filter out corner cells
  set io_cell_names [get_db [get_lib_cells $c0_io_lib/*] .base_name]
  set filtered_io_cell_list {}
  foreach cell $io_cell_names {
      if {![string match "CornerCell*" $cell]} {
          lappend filtered_io_cell_list $cell
      }
  }

  ## Remove pre-existing inline bond pad cells
  set exist_bond_pad_list [get_db [get_cells -hier -filter "ref_name == $bond_pad_ref_name"]]
  if {$exist_bond_pad_list ne ""} {
      echo "==== INFO: Removing pre-existing inline bond pad cells for $bond_pad_ref_name."
      foreach pad $exist_bond_pad_list {
          delete_cell $pad
      }
  }

  ## Place bond pads for each IO cell
  foreach io_cell $filtered_io_cell_list {
      set io_cell_bbox [get_db [get_cells $io_cell] .bbox]
      set io_cell_orient [get_db [get_cells $io_cell] .orient]

      set io_cell_LL_X [lindex $io_cell_bbox 0]
      set io_cell_LL_Y [lindex $io_cell_bbox 1]
      set io_cell_UR_X [lindex $io_cell_bbox 2]
      set io_cell_UR_Y [lindex $io_cell_bbox 3]

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
              set bond_pad_LL_X [expr $io_cell_UR_X - $pad_width - 0.5]
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
  set new_bond_pad_list [get_db [get_cells -hier -filter "ref_name == $bond_pad_ref_name"]]
  echo "==== INFO: Total added" [llength $new_bond_pad_list] "inline bond pad cells for $bond_pad_ref_name."
}
