// MT32-Pi controls for 3.5" bay
// By Hans Christian Saustrup <hc@saustrup.net>
model_version = "v0.0.1";

use <lib/rotaryencoder.scad>
use <lib/display.scad>
use <lib/pushbutton.scad>
use <lib/shapes.scad>
use <lib/traymount.scad>

$fn = $preview ? 0 : 25; 

test = false;

front_width = 42;
front_height = 148;
front_thickness = 4;

box_width= front_width;
box_height= 146;
box_front_depth = 55;
box_front_depth_low = 10;
// box_front_overlap_height = 5;
// box_front_overlap_size = 10;
box_thickness = 2;

tray_width = box_width - (2*box_thickness);
tray_height = 70;

echo("Tray size: " , tray_width, tray_height);

if (test == true) {
    build(front_width / 1.75, front_height / 2, front_thickness);
} else {
    build(front_width, front_height, front_thickness);
}

module build(front_width, front_height, front_thickness) {

    oled_x = front_width/2 - 15;
    oled_y = front_height - 45;
    oled_height = 35;

    rotary_x = front_width/2;
    rotary_y = oled_y - 10;

    led_x = front_width/2;
    led_y = rotary_y - 16;
    led_dia = 5;
    led_height = 3;
    led_rim_dia = 6;

    rotary_thread_height = 4;

    dh = 3.0;
    ds = dh - 0.5;
    
    sunken_screw_hole_diameter = dh;
    sunken_screw_head_diameter = 6;
    sunken_screw_head_height = 2;
    
    difference() {
        union() {
            // Front
            cube([front_width, front_height, front_thickness]);

            // Attach to front:
            translate([0,0,front_thickness]) {
                translate([oled_x, oled_y])
                    oled_128x64_13(front_thickness, true, ds=ds);
                translate([rotary_x, rotary_y])
                    rotaryencoder_boxed(front_thickness, rotary_thread_height, true);

                translate([(front_width-box_width)/2, (front_height-box_height)/2])
                    translate([box_thickness, box_thickness])
                        traymount(tray_width, tray_height, front_thickness, box_thickness, true, ds=ds);               
           }

        }
        union() {
            // Cut out of front:

            // OLED
            translate([oled_x, oled_y])
                oled_128x64_13(front_thickness, false, ds=ds);

            // LED
            translate([led_x,led_y]) {
                cylinder(h=front_thickness, r=led_dia/2);
                translate([0,0,led_height])
                    cylinder(h=front_thickness - led_height, r=led_rim_dia/2);
            }

            translate([rotary_x, rotary_y])
                rotaryencoder_boxed(front_thickness, rotary_thread_height, false);

            translate([(front_width-box_width)/2, (front_height-box_height)/2])
                translate([box_thickness, box_thickness])
                    traymount(tray_width, tray_height, front_thickness, box_thickness, false, ds=ds);               

            // text_height = 1.0;
            // translate([front_width/2,3,text_height])
            // rotate([0,180,0])
            // linear_extrude(text_height)
            // text("Gotek", halign="center");

        }
    }

    module edge(height) {
        difference() {
            cube([box_width - (2*box_thickness), height, box_front_overlap_size]);
            translate([box_thickness, box_thickness])
                cube([box_width - (4*box_thickness), height - (2*box_thickness), box_front_overlap_size]);
        }
    }

    // Relative to side:
    box_screw_x = [47];
    box_screw_y = [10,20];

    translate([0,(front_height-box_height)/2,front_thickness]) {
        difference() {
            union() {
                cube([box_width, box_height, box_front_depth]);
            }
            union() {
                translate([box_thickness, box_thickness, 0])
                    cube([box_width - (2*box_thickness), box_height - (2*box_thickness), box_front_depth]);

                translate([0, box_thickness + box_front_depth_low, box_front_depth_low])
                    cube([box_width, box_height - (box_thickness*2) - (box_front_depth_low*2), box_front_depth]);

                // Work on sides
                for (side=[0,1]) {
                    side_y = (box_height - box_thickness) * side;

                    // Punch holes for mounting in case:
                    for (x=box_screw_x)
                    for (y=box_screw_y) {
                        translate([0,side_y])
                        rotate([-90,-90])
                            translate([x, box_width - y])
                            cylinder(r=ds/2,h=box_thickness);
                    }

                    // Save filament
                    side_save_diameter = box_width/3;
                    translate([0,side_y])
                    rotate([-90,-90])
                        translate([box_front_depth_low + side_save_diameter, box_width/2])
                        cylinder(r=side_save_diameter,h=box_thickness);
                }

                tray_screw_edge_spacing = 10;
                tray_screw_x_count = 2;
                screw_offset = box_thickness + tray_screw_edge_spacing;
                screw_spacing = (tray_height - (2*screw_offset)) / (tray_screw_x_count-1);

                echo("Screw spacing", screw_spacing);

                // Work on top/bottom
                for (side=[0,1]) {

                    // Move away from the box side:
                    translate([0, box_thickness])
                    for (hole=[0,1,2]) {
                        for (screw=[0:1:tray_screw_x_count-1]) {
                            translate([
                                // Side z
                                (box_width)*side,

                                // Side x
                                screw_offset + (screw_spacing * screw),

                                // Side y
                                box_front_depth_low/2
                            ])
                            rotate([180,-90,side*180])
                                sunken_screw_hole(
                                    d=sunken_screw_hole_diameter, 
                                    dh=sunken_screw_head_diameter, 
                                    hh=sunken_screw_head_height, 
                                    h=box_thickness
                                );
                        }   
                    }
                }

            }
        }


        // translate([box_thickness, box_thickness])
        //     edge(box_height/2 - (2*box_thickness));
        

        // translate([box_thickness, box_height - (2*box_thickness)])
        //     cube([box_width - (2*box_thickness), box_thickness, box_front_overlap_size]);

    }
}
