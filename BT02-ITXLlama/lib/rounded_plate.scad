module rounded_plate(size, r=0) {

    s = [
        size.x - (r*2),
        size.y - (r*2),
        size.z - 0.1
    ];

    translate([r, r])
    minkowski() {
        cube(s);
        cylinder(r=r, h=0.1);
    }

}
