// MT32-Pi controls for 3.5" bay
// By Hans Christian Saustrup <hc@saustrup.net>
model_version = "v0.0.1";

use <lib/rotaryencoder.scad>
use <lib/oled128x64-13.scad>
use <lib/pushbutton.scad>
use <lib/shapes.scad>
use <lib/traymount.scad>

$fn = $preview ? 0 : 25; 

test = false;

// Unit size
unit_size = [
    42,
    147,
    61 
];

// Front plate size (width, height, depth)
unit_front_size = [42, 149, 6];

// Minimum width of unit walls (behind front plate)
unit_brim = 10;

// Holes for mounting
unit_screws = [
    [47, 10],
    [47, 20]
];

// General plate thickness
unit_t = 2;

// Screw hole diameter
screw_hole_d = 3;

// Screw threaded hole diameter
screw_thread_d = 2.5;

// Position of the OLED display
display_y = 118;

// Position of the rotary encoder
rotary_y = 95;

// Position of the LED
led_y = 80;

// Slot(s)
dualmode = false;
slots = [dualmode ? [0, 20] : [11], 60];

__build();

module __build() {

    __unit_inside_size = [
        unit_size.x - (2*unit_t),
        unit_size.y - (2*unit_t),
        unit_size.z - (1*unit_t)
    ];

    echo("Inside dimensions: ", __unit_inside_size);

    // usb = [7,15];
    // button_d = 3.5;
    // b1_y = 5;
    // b2_y = b1_y + 7.25;
    // b3_y = b2_y + 9.00;
    // b_x = 10;

    // for (x = slots.x) {
    //     x2 = (x - unit_t) + b_x;

    //     for (s = [b1_y, b2_y]) {
    //         translate([x2, 40 + s, -unit_t])
    //             cylinder(r=button_d/2, h=unit_t);
    //     }

    //     translate([x2 - (usb.x/2) , b3_y, -unit_t])
    //         cube([usb.x, usb.y, unit_t]);

    //     // translate([x, slots.y - unit_brim + unit_t, 0]) cube([unit_t, unit_brim - unit_t, __unit_inside_size.z]);
    // }

    module led(positive) {
        if (positive) {
        } else {
            translate([0,0,-unit_t])
               cylinder(r=2.5, h=unit_t);
        }
    }

    module display(positive) {
        oled_128x64_13(positive, tfront=unit_t);
    }

    module rotary(positive) {
        if (positive) {
        } else {
            translate([0,0,-unit_t])
                cylinder(r=2.5, h=unit_t);
        }
    }

    module components(positive=true) {

        center_x    = __unit_inside_size.x/2;
        // slots       = [0, __unit_inside_size.y - slots.y];
        led         = [center_x, led_y];
        rotary      = [center_x, rotary_y];
        display     = [center_x, display_y];

        // translate(slots)    slots(positive);
        translate(display)  display(positive);
        translate(led)      led(positive);
        translate(rotary)   rotary(positive);
    }

    difference() {
        union() {
            difference() {
                union() {
                    // Positive

                    // The unit
                    cube(unit_size);

                    // The unit front plate (decoration)
                    translate([
                        (unit_size.x-unit_front_size.x)/2,
                        (unit_size.y-unit_front_size.y)/2,
                    ]) cube(unit_front_size);

                }
                union() {
                    // Remove sides - leave a brim
                    for (side=[0,1]) {
                        translate([side * (unit_size.x-unit_t), unit_brim, unit_brim])
                            cube([
                                unit_t,
                                unit_size.y - (unit_brim*2),
                                unit_size.z - unit_brim
                            ]);
                    }

                    // Go inside unit
                    translate([unit_t, unit_t, unit_t]) {
                        // Hollow out unit
                        cube(__unit_inside_size);
                    }
                }
            }

            translate([unit_t, unit_t, unit_t]) {
                components(true);
            }
        }
        union() {
            translate([unit_t, unit_t, unit_t]) {
                components(false);
            }
        }
    }
}

echo("---");
