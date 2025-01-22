// Alternative 5.25" half height mount for DECromancer's MFM Emulator
// By Hans Christian Saustrup <hc@saustrup.net>
model_version = "v0.1.0";

// $fn = $preview ? 0 : 25;
$fn = $preview ? 0 : 50;

front = [149, 43, 5];

mount_x = 126; // spacing
mount_y = 3; // distance from edge of front
mount_z = 16; // height of bar

screw_r = 3/2;

t = 2;
cutout = [
    front.x-(2*t),
    front.y-(2*t),
    front.z-t
];

screwmount = [10, 15, 6];

ethernet_cutout = [16.5, 13.5, front.z];
ethernet_pos = [65, 15, 0];

led_distance = 10;
led_offset = 22;

difference() {
    union() {
        hull() {
            h = 0.1;
            c = 0.5; 
            translate([c, c])
            cube([front.x-(c*2), front.y-(c*2), h]);
            translate([0,0,front.z-h])
            cube([front.x, front.y, h]);
        }
    }
    union() {
        difference() {
            // Cut this away
            union() {

                // Hollow out front
                translate([
                    (front.x-cutout.x)/2,
                    (front.y-cutout.y)/2,
                    t,
                ]) cube(cutout);

                // Ethernet cutout
                translate(ethernet_pos)
                cube(ethernet_cutout);
            }

            // Except this:
            union() {
                translate([front.x/2,0,0])
                for (s=[0,1]) mirror([s,0,0]) {
                    // Mount supports
                    translate([(mount_x - screwmount.x)/2, 0, 0])
                    cube([screwmount.x,front.y,front.z]);

                    // Ethernet support plate
                    w = 24;
                    h = ethernet_pos.y;
                    translate([(0 - w)/2, 0, 0])
                    cube([w,h,front.z]);
                }

                // LED mounts
                for (l=[0:1]) {
                    translate([front.x - (led_offset + (led_distance*l)), front.y/2])
                    cylinder(r=4, h=front.z);
                }
            }
        }

        // LEDs
        for (l=[0:1]) {
            translate([front.x - (led_offset + (led_distance*l)), front.y/2])
            cylinder(r=2.5, h=front.z);
        }
    }
}

// Screw mounts
mount_t = 3;
mount_wall_t = 1;
translate([front.x/2, mount_z, front.z])
for (s=[0,1]) mirror([s, 0, 0])
translate([mount_x/2,0])
difference() {
    union() {
        translate([-screwmount.x/2, 0, 0]) {
            hull() {
                cube([screwmount.x, mount_t, screwmount.z]);
                cube([screwmount.x, screwmount.y, 0.001]);
            }
        }
        
    }
    union() {
        translate([0, 0, mount_y])
            rotate([-90,0,0])
                cylinder(r=screw_r, h=screwmount.y);
        translate([(-screwmount.x/2)+mount_wall_t, mount_t, 0])
            cube([
                screwmount.x - (2 * mount_wall_t),
                screwmount.y- (mount_t),
                screwmount.z
            ]);
    }
}
