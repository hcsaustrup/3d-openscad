use <lib/rounded_plate.scad>
use <lib/misc.scad>
include <inc/common.scad>

// Chieftec BT02 Front Panel Insert
// By Hans Christian Saustrup <hc@saustrup.net>
model_version = "v0.1.0";

// $fn = $preview ? 0 : 25;
$fn = $preview ? 0 : 50;

oled_size = [35.5, 34, 1.1];

difference() {
    cube(oled_size);
    union() {

        translate([oled_size.x/2,0])
        for (x=[0,1])
        mirror([x,0,0])
        cube([6,3.5,oled_size.z]);

        cutout1 = [33,27,oled_size.z];
        translate([1.5, 4.80])
        cube(cutout1);


    }
}
