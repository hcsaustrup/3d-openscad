// Alternative 5.25" half height mount for DECromancer's MFM Emulator
// By Hans Christian Saustrup <hc@saustrup.net>
model_version = "v0.1.0";

// $fn = $preview ? 0 : 25;
$fn = $preview ? 0 : 50;

// Model is mirred - this is the true width:
bar_true_x = 146;

rail = [6, 133, 16];
bar = [bar_true_x/2, 6, 16];
holes_y = [47, 126];

// Screws and spacers
screw_r = 3/2;
thread_r = 2.7/2;
front_screw_h = 8; // 3M10 - mount thickness

// pcb_hole_x = (bar_true_x - 139) / 2;
pcb_holes_y = [12.5, 12.5+79];
pcb_screw_h = 6;
pcb_spacer_h = 8;

front_mount_x = 126;
front_mount_z = 3;

for (r=[0,1])
translate([r * (bar_true_x),0,0])
mirror([r,0,0])
difference() {
    union() {
        cube(bar);
        cube(rail);

        o = 20;
        h = 2;

        // Rectangular stabilizer
        color([0.5, 0.5, 0.5])
        hull() {
            translate([rail.x,   bar.y])   cylinder(r=1, h=h);
            translate([rail.x,   bar.y+o]) cylinder(r=1, h=h);
            translate([rail.x+o, bar.y])   cylinder(r=1, h=h);
        }
    }
    union() {
        // Side holes
        for (y=holes_y) {
            translate([0, y, 10])
            rotate([0,90,0])
            cylinder(r=thread_r, h=rail.x);
        }

        // Front panel screws (account for thickness of front plate mount)
        translate([bar.x-(front_mount_x/2), front_mount_z, 0])
        translate([0,0,bar.z-front_screw_h])
        cylinder(r=thread_r, h=front_screw_h);

        cutout_side = r==0;

        // PCB holes
        for (y=pcb_holes_y) {
            this_pcb_screw_h = pcb_screw_h + (!cutout_side || y < 10 ? 0 : pcb_spacer_h); 

            translate([rail.x/2, y, 0])
            translate([0, 0, bar.z - this_pcb_screw_h])
            cylinder(r=thread_r, h=this_pcb_screw_h);
        }

        // Hot area cutout
        if (cutout_side) {
            cutout = [rail.x, 45, pcb_spacer_h];
            translate([0, 55, rail.z-cutout.z])
            cube(cutout);
        }

        // Ethernet cutout
        cutout = [13, bar.y, 1.6];
        translate([60, 0, bar.z-cutout.z])
        cube(cutout);
    }
}

