// Gotek 5.25" Vertical Mount (tray)
// By Hans Christian Saustrup <hc@saustrup.net>
model_version = "v0.1.0";

use <lib/rotaryencoder.scad>
use <lib/display.scad>
use <lib/pushbutton.scad>
use <lib/shapes.scad>

include <inc/common.scad>

rim = 8;
side_rim = 6;

tray = [95, 60];
pcb_screws = [
    [
        17.5,
        17.5 + 50,
        17.5 + 50 + 21
    ], 
    [5, 55]
];
bay_screws = [
    [5, 45], 
    [5, 55]
];

// General plate thickness
t = 8;

pcb_mount_h = 13.50;
pcb_screw_h = 7;

bay_mount_h = side_rim;
mount_d = 6;

// pcb_screw hole diameter
// screw_thread_d = 3;

// pcb_screw threaded hole diameter
screw_thread_d = 2.8;

__build();

module __build() {

    difference() {

        union() {
            difference() {
                cube([tray.x, tray.y, side_rim]);
                union() {
                    translate([t,t,t])
                        cube([tray.x - (2*t), tray.y-(2*t), rim]);
                    translate([rim, rim])
                        cube([tray.x - (2*rim), tray.y - (2*rim), t]);
                }
            }

            for (x = bay_screws.x)
            for (y = bay_screws.y)
            if (x <= bay_screws.x[0] || y == bay_screws.y[0])
            translate([x,y])
            cylinder(r=mount_d/2, h=bay_mount_h);

            for (x = pcb_screws.x)
            for (y = pcb_screws.y)
            if (x != pcb_screws.x[0] || y != pcb_screws.y[1])
            translate([x, y])
            cylinder(r=mount_d/2, h=pcb_mount_h);

            // USB support
            translate([0, 25])
            cube([2, 10, pcb_mount_h]);

        }
        union() {

            for (x = bay_screws.x)
            for (y = bay_screws.y)
            if (x <= bay_screws.x[0] || y == bay_screws.y[0])
            translate([x,y])
            cylinder(r=screw_thread_d/2, h=t + bay_mount_h);

            for (x = pcb_screws.x)
            for (y = pcb_screws.y)
            if (x != pcb_screws.x[0] || y != pcb_screws.y[1])
            translate([x, y, pcb_mount_h - pcb_screw_h])
            cylinder(r=screw_thread_d/2, h=pcb_screw_h+1);
        }

    }
}

 