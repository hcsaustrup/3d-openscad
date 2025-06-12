use <../lib/rounded_plate.scad>
use <../lib/misc.scad>
use <oled.scad>

module components(pos=true, t, screw_r) {

    translate([0, 2])
    oled(pos, t=t, flip = true);

    translate([0, 37]) // 37
    r2b(pos, t=t, screw_r=screw_r);

    translate([0, 85]) // 80
    switch(pos, t=t);

    // //---

    translate([0, 145])
    1b(pos, t=t, screw_r=screw_r);

    translate([0, 167])
    sd(pos, t=t, screw_r=screw_r);

}

module everything(
    screw_r = 1.4
) {

    front_size = [
        37.25,
        177,
        5.5
    ];
    back_size = [
        26,
        145.5,
        2.5,
    ];
    back_pos = [
        4.0,
        27.5,
        front_size.z
    ];

    back_holes_spacing = 5;
    back_holes_r = screw_r;
    back_holes_h = (back_size.z + front_size.z) - 1;

    components_pos = [front_size.x/2, 0];
    plate_t = back_size.z + front_size.z;

    {
        difference() {
            union() {
                // Front plate
                rounded_plate(front_size, r=1);

                // Insert
                insert_overlap = 3; // Fix weird PrusaSlicer issue
                color([0.5,1,1])
                translate(back_pos)
                translate([0, 0, -insert_overlap])
                rounded_plate([
                    back_size.x,
                    back_size.y,
                    back_size.z + insert_overlap
                ], r=2.5);
            }
            union() {
                // Insert holes
                translate(back_pos)
                translate([0,0, back_size.z - back_holes_h])
                hole_grid(
                    back_size,
                    xpadding = 2,
                    ypadding = 12,
                    xholes = 2,
                    yholes = 3,
                    r = screw_r,
                    inside = false,
                    h = back_holes_h
                );

                top_cutout_t = 2;
                top_cutout_size = [
                    front_size.x - (2 * top_cutout_t),
                    back_pos.y - (2 * top_cutout_t),
                    front_size.z - top_cutout_t
                ];
                translate([top_cutout_t, top_cutout_t, top_cutout_t])
                cube(top_cutout_size);

                translate(components_pos)
                components(false, t=plate_t, screw_r=screw_r);
            }
        }
        translate(components_pos)
        components(true, t=plate_t, screw_r=screw_r);
    }
}
