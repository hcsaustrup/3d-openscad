use <lib/flatbox1.scad>
include <inc/common.scad>

// Enclosure for "PCI-E 1X TO PCI" adapter
// By Hans Christian Saustrup <hc@saustrup.net>
model_version = "v0.1.0";

// $fn = $preview ? 0 : 25;
$fn = $preview ? 0 : 50;

{
    difference() {
        flatbox1([size.x, size.y, h_bottom], top=false, 
            holes=holes, 
            h_mount = h_mount_bottom, 
            r_mount = 5,
            r1=r1, rounded="corners", h_ridge=h_ridge);
        color([1,0,0])
        union() {
            rotate([90,0,90]) {

                // USB hole
                usb_cutout = [13.5, 7.5, r1];
                translate([5.5, h_mount_bottom + h_pcb + 1.5, -r1])
                cube(usb_cutout);

                // Power plug
                translate([38.0, h_mount_bottom + h_pcb + 3.5, -r1])
                cylinder(r=3.5, h=r1);

            }
        }
    }
}
