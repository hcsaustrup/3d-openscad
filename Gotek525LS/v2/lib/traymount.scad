use <./shapes.scad>

module traymount(width, height, front_thickness, thickness, positive, ds=2.3) {

    tray_screw_mount_spacing = 10;
    tray_screw_mount_height = 5;
    tray_screw_mount_diameter = 8;

    // Allow tray components to get closer to the front by making an indentation
    indent_rim = 4;
    indent_width = width - (2*indent_rim);
    indent_height = height - (2*indent_rim);
    indent_depth = 2;
    indent_x = indent_rim;
    indent_y = indent_rim;

    botton_hole_offset = 15;
    botton_hole_spacing = 7;
    usb_hole_width = 7;
    usb_hole_height = 15;

    module __build() {

        // rbd = max(rotary_box_depth, thickness-rotary_thread_height);

        difference() {
            union() {
                // Make sure we using the front plate (allow cut cutting in it)
                cube([width, height, front_thickness]);
            }
            union() {
                // Provide an additional 1mm for stuff in the tray
                translate([indent_x, indent_y, front_thickness-indent_depth])
                    cube([indent_width, indent_height, indent_depth]);

                //
                for (hole=[0,1]) {
                    translate([width/2, botton_hole_offset + (hole * botton_hole_spacing)])
                        cylinder(r=3.5 / 2, h=front_thickness);
                }

                // USB
                translate([(width - usb_hole_width)/2, botton_hole_offset + (2 * botton_hole_spacing)])
                    cube([usb_hole_width, usb_hole_height, front_thickness]);

            }
        }

    }

    if (positive == true) {
        translate([0,0,-front_thickness])
            __build();
    } else {
        translate([0,0,0])
            difference() {
                hull() __build();
                __build();
            }
    }
}
