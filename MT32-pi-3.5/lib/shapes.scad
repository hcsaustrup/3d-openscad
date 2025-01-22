module flat_pyramid(x, y, z, angle=45) {  
    p = z * sin(angle);
    hull() {
        cube([x, y, z]);
        translate([-p, -p, -z])
            cube([x+(2*p), y+(2*p), z]);
    }   
}

module screw_mount(h=0, d=5, ds=2.3) {
    difference() {
        cylinder(h=h, r=d/2);
        cylinder(h=h, r=ds/2);       
    }
}