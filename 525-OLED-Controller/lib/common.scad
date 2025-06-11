front = [
    149,
    42,
    5
];

rim = [
    146,
    front.y,
    5
];

module components(i, double) {

    count = double ? 2 : 1;

    translate([front.x/2, front.y/2])
    union() {

        if (double) {
            for (x=[0,1])
            translate([(x-0.5)*72, 0])
            controller(i, t=front.z);
        } else {
            controller(i, t=front.z);
        }
        
        translate([0, 0, front.z])
        union() {
            rim(i, rim);
            wings(i, rim);
        }
    }
}

module __build(double=true) {
    difference() {
        cube(front);
        components(false, double=double);
    }
    components(true, double=double);
}

module rim(i, size, t=1, padding_x=3) {
    if (i) {
        cutout = [size.x - (2*t), size.y - (2*t), size.z];
        difference() {
            translate([size.x/-2, size.y/-2]) cube(size);
            translate([cutout.x/-2, cutout.y/-2]) cube(cutout);
        }
    }

    // Bracket
    bracket = [10, t, 0.1];

    for (x=[0,1])
    mirror([x,0])
    translate([(size.x / 2), (size.y/2)])
    union() {
        translate([-bracket.x-padding_x, -bracket.y , size.z])
        hull() {
             cube(bracket);
             translate([bracket.x,0,0]) rotate([0,270,0]) cube(bracket);
        }   


    }
}

module wings(i, rimsize) {

    screw_r = 2.8/2;
    t = 3;
    wing = [t, 30, 52];
    hole_r = 8;

    if (i) {

        for (x=[0,1])
        mirror([x,0])
        translate([(rimsize.x / 2) - wing.x, (rimsize.y/2) - wing.y ])
        union() {

            difference() {
                hull() {
                    // Ensure square bottom:
                    cube([wing.x, wing.y, wing_r]);

                    wing_r = 10;
                    translate([0, wing_r, wing.z - wing_r])
                    rotate([0,90,0]) 
                    minkowski() {
                        cube([wing.z - (2*wing_r), wing.y - (2*wing_r), t/2]);
                        cylinder(r=wing_r, h=t/2, center=false);
                    }

                }
                union() {
                    // Screw holes
                    rotate([0,270])
                    translate([0, wing.y,-t])
                    for (y=[9.5, 9.5+12])
                    translate([47, -y])
                    cylinder(r=screw_r, h=t);

                    // Filament savers
                    rotate([0,270])
                    hull() {
                        translate([rimsize.z, (wing.y/2) - hole_r, -t])
                        cube([1, hole_r*2, t]);

                        translate([33, wing.y/2,-t])
                        cylinder(r=hole_r, h=t);
                    }

                }
            }
        }
    }
}

module controller(i, t) {
    front_h = 0.5; // Minimum thickness of front plate

    // Component height over PCB:
    oled_h      = 2;
    rotary_h    = 4.7;
    button_h    = 2.75;

    mounts = [59, 29];
    cutout = [66, 36, t];

    insert = [cutout.x, cutout.y, front_h + (rotary_h - oled_h)];

    oled_cutout = [32, 16, insert.z];
    oled_cutout_extra = 3;
    oled_initial_inner_h = 0.5;

    rotary_cutout = [12.5, 12.5, insert.z - front_h];
    rotary_r = 3.75;

    button_r = 3;
    button_rim_r = 4;
    button_rim_h = 1.2;

    mount_r = 3;
    mount_padding_x = ((cutout.x - mounts.x) / 2);
    mount_padding_y = ((cutout.y - mounts.y) / 2);
    mount_h = insert.z + oled_h;

    screw_r = 2.8/2;
    screw_h = mount_h - front_h;

    // Designed upside down
    mirror([0, 1])
    if (!i) {

        translate([cutout.x/-2, cutout.y/-2])
        cube(cutout);

    } else {

        difference() {

            union() {
                color([0.5,0.5,0.5])
                translate([insert.x/-2, insert.y/-2])
                cube(insert);

                // Relative to lower
                color([1,0,0])
                for (x=[0,1]) mirror([x,0])
                for (y=[0,1]) mirror([0,y])
                translate([mounts.x/-2, mounts.y/-2])
                union() {
                    cylinder(r=mount_r, h=mount_h);

                    translate([-mount_padding_x, -mount_padding_y])
                    union() {
                        cube([mount_r + mount_padding_x, mount_padding_y, mount_h]);
                        cube([mount_padding_x, mount_r + mount_padding_y, mount_h]);
                    }
                }
            }

            union() {

                for (x=[0,1]) mirror([x,0])
                for (y=[0,1]) mirror([0,y])
                translate([mounts.x/-2, mounts.y/-2, mount_h - screw_h])
                cylinder(r=screw_r, h=screw_h);

                // Relative to lower 
                translate([mounts.x/-2, mounts.y/-2])
                union() {

                    // OLED window
                    translate([2.5, 9])
                    union() {
                        cube(oled_cutout);

                        hull() {
                            translate([0,0,-oled_initial_inner_h])
                            cube(oled_cutout);

                            translate([-oled_cutout_extra, -oled_cutout_extra])
                            cube([
                                oled_cutout.x + (2*oled_cutout_extra),
                                oled_cutout.y + (2*oled_cutout_extra),
                                0.01
                            ]);

                        }
                    }

                    // Rotary                   
                    translate([50.5, 14.5])
                    union() {
                        cylinder(r=rotary_r, h=insert.z);
                        translate([rotary_cutout.x/-2, rotary_cutout.y/-2, front_h])
                        cube(rotary_cutout);

                        // Buttons
                        for (y=[0,1])
                        mirror([0, y])
                        translate([0, 12])
                        union() {
                            cylinder(r=button_r, h=insert.z);

                            translate([0,0, insert.z])
                            rotate([0,180,0])
                            cylinder(r=button_rim_r, h=button_rim_h + (button_h - oled_h) );

                        }
                    }


                }
            }

        }
       
    }
}
