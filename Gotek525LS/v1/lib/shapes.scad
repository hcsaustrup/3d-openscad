module flat_pyramid(x, y, z, angle=45) {  
    p = z * sin(angle);
    hull() {
        cube([x, y, z]);
        translate([-p, -p, -z])
            cube([x+(2*p), y+(2*p), z]);
    }   
}

module screw_mount(h=0, d=0, ds=2.3) {
    difference() {
        cylinder(h=h, r=(d != 0 ? d : ds*2 + (h*0.25))/2);
        screw_hole(h=h, d=ds);
    }
}

module screw_hole(h=0, d=2.3) {
    cylinder(h=h, r=d/2);       
}

module quad_mount(x, y, h=0, d=5, ds=2.3) {
    translate([0,0])
        screw_mount(h,d,ds);
    translate([x,0])
        screw_mount(h,d,ds);
    translate([0,y])
        screw_mount(h,d,ds);
    translate([x,y])
        screw_mount(h,d,ds);
}

module sunken_screw_hole(h, d=3, dh=6, hh=2) {
    // Hole straight through
    cylinder(r=d/2,h=h);
    // Edged hole:
    hull() {
        cylinder(r=dh/2,h=0.1);
        translate([0,0,hh]) cylinder(r=d/2,h=0.1);
    }
}
