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

rim = 8;
side_rim = 8;

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
    [5, 55], 
    [5, 55]
];

// General plate thickness
t = 8;

pcb_mount_h = 13;
pcb_screw_h = 7;

bay_mount_h = side_rim;
mount_d = 6;

// pcb_screw hole diameter
// screw_thread_d = 3;

// pcb_screw threaded hole diameter
screw_thread_d = 2.6;

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
            if (x != bay_screws.x[1] || y != bay_screws.y[1])
            translate([x,y])
            cylinder(r=mount_d/2, h=bay_mount_h);

            for (x = pcb_screws.x)
            for (y = pcb_screws.y)
            if (x != pcb_screws.x[0] || y != pcb_screws.y[1])
            translate([x, y])
            cylinder(r=mount_d/2, h=pcb_mount_h);

        }
        union() {

            for (x = bay_screws.x)
            for (y = bay_screws.y)
            if (x != bay_screws.x[1] || y != bay_screws.y[1])
            translate([x,y])
            cylinder(r=screw_thread_d/2, h=t + bay_mount_h);

            for (x = pcb_screws.x)
            for (y = pcb_screws.y)
            if (x != pcb_screws.x[0] || y != pcb_screws.y[1])
            translate([x, y, pcb_mount_h - pcb_screw_h])
            cylinder(r=screw_thread_d/2, h=pcb_screw_h+1);
        }


    }

        translate([35, tray.y-6, t])
        linear_extrude(1)
        text( "Saustrup 2025 ", halign = "center", size=5);


}
