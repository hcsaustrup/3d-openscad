// Stackable brick inspired by original LEGO
// By Hans Christian Saustrup <hc@saustrup.net>
model_version = "v0.0.1";

// Duplication factor
fx = 2;

// Duplication factor
fy = 2;

// "LEGO unit" size in mm
lu = 1.6; 

x = 20 * lu; // Width
y = 10 * lu; // Depth
z = 6 * lu; // Height
t = 1 * lu; // Thickness
th = 1 * lu; // Tip height

module oldbrick() {
    difference() {
        union() {
            // Brick itself
            cube([x,y,z]);

            // Top 1
            translate([t,t,z])
                cube([(x/2)-(t*2),y-(2*t),th]);

            // Top 2
            translate([t+(x/2),t,z])
                cube([(x/2)-(2*t),y-(2*t),th]);
        }
        union() {
            // Hollow out brick
            translate([t,t,0])
                cube([x-(2*t),y-(2*t),z-t]);

            // Hollow under top1
            translate([t*3,t*3,z-t])
                cube([(x/2)-(t*6),y-(t*6),th]);

            // Hollow under top2
            translate([(x/2)+(t*3),t*3,z-t])
                cube([(x/2)-(t*6),y-(t*6),th]);
        }
    }
}

for (xl = [0:1:fx-1]) {
    translate([xl*(x+t),0,0]) {
        for (yl = [0:1:fy-1]) {
            translate([0,yl*(y+t),0]) {
                oldbrick();
            }
        }
    }
}
