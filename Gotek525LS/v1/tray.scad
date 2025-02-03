// MT32-Pi controls for 3.5" bay
// By Hans Christian Saustrup <hc@saustrup.net>
model_version = "v0.0.1";

use <lib/rotaryencoder.scad>
use <lib/display.scad>
use <lib/pushbutton.scad>
use <lib/shapes.scad>

$fn = $preview ? 0 : 25; 

test = false;

front_width = 42;
front_height = 148;
front_thickness = 4;

box_width= front_width;
box_height= 146;
box_front_depth = 5;
box_front_overlap_height = 5;
box_front_overlap_size = 10;
box_thickness = 2;

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
    rotary_y = front_height - 60;

    led_x = front_width/2;
    led_y = front_width/2;
    led_dia = 5;
    led_height = 3;
    led_rim_dia = 6;

    rotary_thread_height = 4;

    ds = 2.5;

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
        


    translate([0,(front_height-box_height)/2,front_thickness]) {
        difference() {
            union() {
                cube([box_width, box_height, box_front_depth]);
            }
            union() {
                translate([box_thickness, box_thickness, 0])
                cube([box_width - (2*box_thickness), box_height - (2*box_thickness), box_front_depth]);
            }
        }

        translate([box_thickness, box_thickness])
            edge(box_height/2 - (2*box_thickness));
        

        // translate([box_thickness, box_height - (2*box_thickness)])
        //     cube([box_width - (2*box_thickness), box_thickness, box_front_overlap_size]);

    }
}
