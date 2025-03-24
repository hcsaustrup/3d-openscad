use <lib/flatbox1.scad>
include <inc/common.scad>

// Enclosure for "PCI-E 1X TO PCI" adapter
// By Hans Christian Saustrup <hc@saustrup.net>
model_version = "v0.1.0";

// $fn = $preview ? 0 : 25;
$fn = $preview ? 0 : 50;

{
    r_foot = 6;
    h_foot = 5;
    r_screw_hole = 1.6;
    r_screw_head = 3.0;
    h_screw_head = h_foot - 2;

    for (i=[0:3]) {
        translate([i*r_foot*2.5, 0, 0])

        difference() {
            hull() {
                cylinder(r=r_foot, h=1.0);
                translate([0,0,h_foot])
                rotate([0, 180, 0])
                cylinder(r=r_foot * 0.75, h=0.01);
            }
            union() {
                cylinder(r=r_screw_hole, h=h_foot);
                translate([0,0,h_foot - h_screw_head])
                cylinder(r=r_screw_head, h=h_screw_head);
            }
        }
    }
}
