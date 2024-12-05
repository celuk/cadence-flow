proc bmp2lay { args } {
  set options(-px) "1"
  set options(-py) "1"
  set options(-layer) "METAL1"
  set options(-offsetx) "0"
  set options(-offsety) "0"
  parse_proc_arguments -args $args options
  set file_name $options(-f)
  set layer_name $options(-layer)

# Get all layers (you may need to specify the type if required, e.g., metal)
#set all_layers [getAllLayers]
# Check if the specified layer exists
#set layer_exists 0
#foreach layer $all_layers {
#    if {$layer == $layer_name} {
#        set layer_exists 1
#        break
#    }
#}
## Conditional check and error message
#if {!$layer_exists} {
#    puts "xx_error: layer $layer_name does not exist!"
#} else {
#    drawbmp $file_name $options(-layer) $options(-px) $options(-py) $options(-offsetx) $options(-offsety)
#}


#  if { [get_layers $layer_name -q]=="" } {
#    puts "xx_error: layer $layer_name does not exist !"
#  } 
#else {
    drawbmp $file_name $options(-layer) $options(-px) $options(-py) $options(-offsetx) $options(-offsety)
#  }
} 
define_proc_arguments bmp2lay \
  -info "draw bmp in layout" \
  -define_args {
    {-f       "BMP File Name" AString string required}
    {-layer   "layer to use" AString string required}
    {-px      "Pixel Size X in layout"  AnFloat float optional}
    {-py      "Pixel Size Y in layout"  AnFloat float optional}
    {-offsetx "Offset in X direction" AnFloat float optional}
    {-offsety "Offset in Y direction" AnFloat float optional}
    {-info    "Description of variable" AString string optional}
  }

proc drawbmp {filename layer px_size py_size offset_x offset_y} {

  set f [open $filename r]

  # Read the BMP header information

  binary scan [read $f 2] "a2" header_type
  binary scan [read $f 4] "i" header_fsize
  binary scan [read $f 4] "i" header_freserve
  binary scan [read $f 4] "i" header_offset
  binary scan [read $f 4] "i" header_bisize
  binary scan [read $f 4] "i" header_width
  binary scan [read $f 4] "i" header_height
  binary scan [read $f 2] "s" header_biplanes
  binary scan [read $f 2] "s" header_bitcount
  binary scan [read $f 4] "i" header_compress
  seek $f 16 current 
  binary scan [read $f 4] "i" header_colors

  if { $header_type != "BM" } {
    puts stderr "$filename is not a BMP file format."
    return
  }

  if { $header_colors == 0 } {
    seek $f 0x22 start
    binary scan [read $f 4] "i" imagesize 
  } else {
    set imagesize [expr $header_fsize - $header_offset]
  }
  
  puts "header_bitcount $header_bitcount"
  switch $header_bitcount {
    1 { set is_single_bit 1}
    default { puts "xx_error: format not support !"
      return
    }
  }
  
  seek $f $header_offset start
  set Xsize [expr ($imagesize / $header_height)]
  set fix [expr $header_width % 4]

  for { set ym 0 } { $ym < $header_height } { incr ym } {
    for { set xm 0 } { $xm < $Xsize } { incr xm } {
      binary scan [read $f 1] "H2" data
      set imagedata "0x$data"
      set lx [expr $xm * 8 * $px_size + $offset_x]
      set ly [expr $ym * $py_size + $offset_y]
      set hy [expr $ly + $py_size]

      if {$imagedata & 0x80} {
        set bb [list $lx $ly [expr $lx + $px_size] $hy]
        create_shape -layer $layer -rect $bb
      }
      if {$imagedata & 0x40} {
        set bb [list [expr $lx + 1 * $px_size] $ly [expr $lx + 2 * $px_size] $hy]
        create_shape -layer $layer -rect $bb
      }
      if {$imagedata & 0x20} {
        set bb [list [expr $lx + 2 * $px_size] $ly [expr $lx + 3 * $px_size] $hy]
        create_shape -layer $layer -rect $bb
      }
      if {$imagedata & 0x10} {
        set bb [list [expr $lx + 3 * $px_size] $ly [expr $lx + 4 * $px_size] $hy]
        create_shape -layer $layer -rect $bb
      }
      if {$imagedata & 0x08} {
        set bb [list [expr $lx + 4 * $px_size] $ly [expr $lx + 5 * $px_size] $hy]
        create_shape -layer $layer -rect $bb
      }
      if {$imagedata & 0x04} {
        set bb [list [expr $lx + 5 * $px_size] $ly [expr $lx + 6 * $px_size] $hy]
        create_shape -layer $layer -rect $bb
      }
      if {$imagedata & 0x02} {
        set bb [list [expr $lx + 6 * $px_size] $ly [expr $lx + 7 * $px_size] $hy]
        create_shape -layer $layer -rect $bb
      }
      if {$imagedata & 0x01} {
        set bb [list [expr $lx + 7 * $px_size] $ly [expr $lx + 8 * $px_size] $hy]
        create_shape -layer $layer -rect $bb
      }
    }
  }
  
  echo "compress $header_compress , bmp size: $header_width x $header_height"
  close $f
}