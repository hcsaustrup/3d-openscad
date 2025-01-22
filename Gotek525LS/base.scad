// Gotek 5.25" Vertical Mount (base)
// By Hans Christian Saustrup <hc@saustrup.net>
model_version = "v0.1.0";

use <lib/rotaryencoder.scad>
use <lib/oled128x64-13.scad>
use <lib/pushbutton.scad>
use <lib/shapes.scad>
use <lib/misc.scad>

include <inc/common.scad>

// Unit size
unit_size = [
    42,
    (5.75 * 25.4),
    55
];

// Front plate size (width, height, depth)
unit_front_size = [
    42,
    unit_size.y + 4, // 149 
    6
];

// Minimum width of unit walls (behind front plate)
unit_brim = 12;

// General plate thickness
unit_t = 2;

// Screw hole diameter
screw_hole_d = 3.1;

// Screw threaded hole diameter
screw_thread_d = 2.8;

// OLED enabled?
display_enabled = true;

// Position of the OLED display
display_y = 118;

// Rotary enabled?
rotary_enabled = true;

// Position of the rotary encoder
rotary_y = 93;

// Piezo enabled?
piezo_enabled = true;

// Piezo diameter
piezo_d = 27.5;

// Piezo position
piezo_y = 70;

// LED enabled?
led_enabled = true;

// Position of the LED
led_y = 49; // 75;

// LED diameter
led_d = 5;

// Gotek enabled?
gotek_enabled = true;

// Position of the Gotek cutouts (usb + buttons)
gotek_y = 3.75;

__build();

module __build() {

    __unit_inside_size = [
        unit_size.x - (2*unit_t),
        unit_size.y - (2*unit_t),
        unit_size.z - (1*unit_t)
    ];

    module led(positive) {
        if (positive) {
        } else {
            translate([0,0,-unit_t])
               cylinder(r=led_d/2, h=unit_t);
        }
    }

    module rotary(positive) {
        rotaryencoder_boxed(positive, tfront=unit_t);
    }

    // Starts at outer edge of first button
    module gotek(positive) {
        usb         = [7, 15, unit_t];
        button_d    = 4.25;

        button1_pos = [0, 0];
        button2_pos = [0, button1_pos.y + 7.25];
        usb_pos     = [-usb.x/2, button2_pos.y + 10.25];

        translate([ 0, (button_d/2)])
        if (positive) {
            translate(usb_pos)
            difference() {
                translate([-unit_t, -unit_t])
                cube([
                    usb.x+(1*unit_t),
                    usb.y+(2*unit_t),
                    unit_t
                ]);
                cube(usb);
            }
        } else {
            translate([0, 0, -unit_t]) {
                translate(usb_pos) cube(usb);
                translate(button1_pos) cylinder(r=button_d/2, h=unit_t);
                translate(button2_pos) cylinder(r=button_d/2, h=unit_t);
            }
        }
    }

    module components(positive=true) {
        center_x    = __unit_inside_size.x/2;
        led         = [center_x, led_y];
        rotary      = [center_x, rotary_y];
        display     = [center_x, display_y];
        gotek       = [center_x, gotek_y];
        piezo       = [center_x, piezo_y];

        // translate(slots)    slots(positive);
        if (display_enabled)    translate(display)  oled_128x64_13(positive, tfront=unit_t);
        if (led_enabled)        translate(led)      led(positive);
        if (rotary_enabled)     translate(rotary)   rotaryencoder_boxed(positive, tfront=unit_t);
        if (gotek_enabled)      translate(gotek)    gotek(positive);
        if (piezo_enabled)      translate(piezo)    piezo(positive, tfront=unit_t, d=piezo_d);
    }

    side_cutout = [
        unit_size.x-(2*unit_brim),
        45,
        unit_t
    ];

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

                    // Holes for tray
                    for (x=[5, 55])
                    for (y=[5, 45])
                    translate([unit_size.x, 0, 0])
                        rotate([270, 0, 270])
                        translate([
                            -(unit_t + x),
                            -(unit_t + y),
                            0
                        ])
                        rotate([180,0,0])
                        sunken_screw_hole(d=screw_hole_d, h=unit_t);

                    for (side = [0:1]) {

                        // Position before sides
                        translate([0, (side * unit_size.y) + ((1-side) * unit_t), 0])

                        // Rotate 90 deg on x axis
                        rotate([90,0,0])
                        union() {

                            for (x=[22, 32])
                            for (y=[51])
                            translate([x,y,0])
                            // rotate([(1-side)*180])
                            cylinder(r=screw_thread_d/2, h=unit_t);

                            translate([
                                (unit_size.x/2),
                                unit_brim
                            ])
                            union() {

                                translate([-side_cutout.x/2,0])
                                cube([
                                    side_cutout.x,
                                    side_cutout.y - (side_cutout.y/2),
                                    side_cutout.z
                                ]);

                                translate([0, side_cutout.y - (side_cutout.y/2)])
                                // rotate([(1-side)*180])
                                cylinder(r = side_cutout.x/2, h = side_cutout.z);

                            }
                        }
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
