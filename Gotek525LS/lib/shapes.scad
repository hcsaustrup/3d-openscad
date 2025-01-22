module flat_pyramid(size, angle=45) {  
    p = size.z * sin(angle);
    hull() {
        cube(size);
        translate([-p, -p, -size.z])
            cube([size.x+(2*p), size.y+(2*p), size.z]);
    }   
}

module screw_mount(h, dm, ds=2.3) {
    difference() {
        cylinder(h=h, r=dm/2);
        screw_hole(h=h, d=ds);
    }
}

module screw_mount_flatside(h, dm, ds=2.3) {
    difference() {
        hull() {
        cylinder(h=h, r=dm/2);
        translate([-(dm/2), ds/2, 0])
            cube([dm, (dm-ds)/2, h]);

        }
        screw_hole(h=h, d=ds);       
    }
}

module screw_hole(h=0, d=2.3) {
    cylinder(h=h, r=d/2);       
}

module quad_mount(x, y, h=0, dm=5, ds=2.3) {
    translate([0,0])
        screw_mount(h, dm, ds);
    translate([x,0])
        screw_mount(h, dm, ds);
    translate([0,y])
        screw_mount(h, dm, ds);
    translate([x,y])
        screw_mount(h, dm, ds);
}

module sunken_screw_hole(h, d=3, dh=6.2, hh=2) {
    // Hole straight through
    cylinder(r=d/2,h=h);
    // Edged hole:
    hull() {
        cylinder(r=dh/2,h=0.1);
        translate([0,0,hh]) cylinder(r=d/2,h=0.1);
    }
}
