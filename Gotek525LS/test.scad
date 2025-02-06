// MT32-Pi controls for 3.5" bay
// By Hans Christian Saustrup <hc@saustrup.net>
model_version = "v0.0.1";

use <lib/rotaryencoder.scad>
use <lib/oled128x64-13.scad>
use <lib/pushbutton.scad>
use <lib/shapes.scad>
use <lib/misc.scad>
use <lib/traymount.scad>

include <inc/common.scad>

t=2;

// Unit size
plate = [
    45, 55, t
];

// Piezo diameter
piezo_d = 27.5;
piezo = [plate.x/2, plate.y/2, 0];

module components(positive) {
    translate(piezo)
    piezo(positive, tfront=t, d=piezo_d);
}

difference() {
    union() {
        cube(plate);
        translate([0, 0, t]) {
            components(true);
        }
    }
    union() {
        translate([0, 0, t]) {
            components(false);
        }
    }
}
