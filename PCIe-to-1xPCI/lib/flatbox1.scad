module flatbox1(size, r1=2, r2=1,
    top=true, h_ridge=1, holes=[], r_mount=2.5, r_screw_thread=1.4, r_screw_hole=1.6, h_mount=-1,
    r_screwhead = 3.0, h_screwhead = 2.0, sticky_mount_threshold = 10, rounded=""
) {
    default_hole_spacing = 2;
    _holes = len(holes) > 0 ? holes : [
        [default_hole_spacing, default_hole_spacing],
        [default_hole_spacing, size.y - default_hole_spacing],
        [size.x - default_hole_spacing, default_hole_spacing],
        [size.x - default_hole_spacing, size.y - default_hole_spacing]
    ];

    r_ridge = r1-r2;

    module inside(s) {
        // Hollow out
        translate([r2, r2])
        minkowski() {
            cube([
                s.x - (2*r2),
                s.y - (2*r2),
                s.z
            ]);
            cylinder(r=r2, h=0.01);
        }
    }

    module outside(s) {
        difference() {
            union() {
                minkowski()  {
                    cube(s);
                    if (rounded=="all") {
                        sphere(r=r1);
                    }
                    else if (rounded=="corners") {
                        cylinder(r=r1, h=r1*2, center=true);
                    }
                    else {
                        cube([r1*2,r1*2,r1*2], center=true);
                    }
                }
            }
            union() {
                // Slice off the top:
                translate([-r1, -r1, s.z])
                cube([
                    s.x + (2*r1),
                    s.y + (2*r1),
                    r1,
                ]);
            }
        }
    }

    module box(s) {
        ridge_size = [s.x, s.y, h_ridge];
        difference() {
            difference() {
                outside(s);
                union() {

                    if (!top) {
                        difference() {
                            translate([-r1, -r1, s.z - h_ridge])
                            minkowski() {
                                cube([
                                    s.x + (2*r1),
                                    s.y + (2*r1),
                                    h_ridge
                                ]);
                                cylinder(r=r1, h=1);
                            }
                            translate([0,0 , s.z - h_ridge ])
                            minkowski() {
                                cube(ridge_size);
                                cylinder(r=r2, h=0.001);
                            }
                        }
                    }

                }
            }
            union() {
                inside(s);

                // Top part ridge
                if (top) {
                    translate([0, 0, s.z - h_ridge])
                    minkowski() {
                        cube(ridge_size);
                        cylinder(r=r_ridge, h=0.001);
                    }
                }
            }
        }
    }

    module inside_decoration(s) {
        h_mount = h_mount != -1 ? h_mount : s.z;
        r_screw = top ? r_screw_thread : r_screw_hole;

        xs = [0, actual_size.x];
        ys = [0, actual_size.y];

        translate([0, 0, 0])
        difference() {
            union() {
                // Hole mounts
                for (hole=_holes) {
                    translate(hole) {

                        color([0,0.75,0])
                        cylinder(r=r_mount, h=h_mount);

                        h_mount_support = min(actual_inside_size.z, h_mount);

                        distances = [
                            actual_inside_size.y - hole.y,
                            hole.x,
                            hole.y,
                            actual_inside_size.x - hole.x
                        ];

                        for (i=[0:len(distances)-1]) {
                            distance = distances[i];
                            if (distance <= sticky_mount_threshold) {
                                color([0,1,0])
                                rotate([0,0,i*90])
                                translate([-r_mount, 0])
                                cube([2*r_mount, distance, h_mount_support]);
                            }
                        }
                    }
                }
            }
            union() {
                // Screw holes
                for (hole=_holes) {
                    translate(hole)
                    cylinder(r=r_screw, h=h_mount);
                }
            }
        }
    }

    actual_size=[
        size.x,
        size.y,
        size.z + (top ? 0 : h_ridge)
    ];
    actual_inside_size = [
        size.x,
        size.y,
        actual_size.z - (top ? h_ridge : 0)
    ];

    difference() {
        union() {
            box(actual_size);
            difference() {
                union() {
                    inside_decoration(actual_inside_size);
                }
                difference() {
                    inside_decoration(actual_inside_size);
                    inside([
                        actual_inside_size.x,
                        actual_inside_size.y,
                        h_mount != -1 ? h_mount : actual_inside_size.z
                    ]);
                }
            }
        }
        union() {
            if (!top) {
                // Screw holes "outside the inside"
                for (hole=_holes) {
                    translate(hole)
                    translate([0, 0, -r1]) {

                        // Screw hole
                        cylinder(r=r_screw_hole, h=(r1));

                        // Screw head hold
                        cylinder(r=r_screwhead, h=h_screwhead);
                    }
                }
            }
        }
    }
}
