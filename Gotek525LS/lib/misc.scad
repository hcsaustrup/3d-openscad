module piezo(positive, d=27.5, tfront=2, h=0.5, t=2) {
    d2 = d + (t*2);

    flap_w = t + 1;
    flap_h = 4;

    hole_d = 2;
    hole_sets = [
        [1, 0],
        [6, 4],
        [12, 8]
    ];

    mid_hole_w = d/2;

    if (positive) {
        cylinder(r=d2/2, h=h);

        // Move on top of enclosure
        translate([0, 0, h])
        difference() {
            cylinder(r=d2/2, h=h);
            union() {
                translate([(-d2/2)+flap_w, -(flap_h/2)])
                            cube([d2-(2*flap_w), flap_h, t]);

                difference() {
                    translate([-d2/2, -d2/2])
                        cube([d2, d2, t]);
                    
                    translate([-d2/2, -(flap_h/2)])
                        cube([d2, flap_h, t]);
                }

            }
        }
    } else {
        cylinder(r=d/2, h=h);

        translate([
            -(mid_hole_w/2),
            -d2/2
        ])
        cube([mid_hole_w, d2, h]);


        translate([0, 0, -tfront])
        for (p = hole_sets)
        for (i = [1:p[0]])
        rotate([0,0,(360/p[0])*i])
        translate([p[1], 0])
            cylinder(r=hole_d/2, h=tfront);
    }
}

module piezo_v1(positive, d=27.5, tfront=2, h=1, t=1) {
    d2 = d + (t*2);
    flap_h = 6;
    hole_d = 2;
    hole_sets = [
        [1, 0],
        [6, 4],
        [12, 8]
    ];

    if (positive) {
        cylinder(r=d2/2, h=h);
        translate([0, 0, h])
        difference() {
            cylinder(r=d2/2, h=h);
            translate([-d2/2, -(d2/2) + flap_h])
                    cube([d2, d2 - flap_h, t]);
        }
    } else {
        cylinder(r=d/2, h=h);

        translate([0, 0, -tfront])
        for (p = hole_sets)
        for (i = [1:p[0]])
        rotate([0,0,(360/p[0])*i])
        translate([p[1], 0])
        cylinder(r=hole_d/2, h=tfront);
    }
}
