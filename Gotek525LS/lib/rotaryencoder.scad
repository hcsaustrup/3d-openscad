module rotaryencoder_boxed(positive, tfront=2) {

    // Diameter of rotary stem
    stem_d = 7.0;

    // Length of stem (which should be inside model)
    stem_z = 4;

    box_t = 1;
    box_h = box_t;

    // Tiny box that surrounds the rotary encoder
    box_inner = [12.2, 12.2, box_h];

    // The whole block the rotary encoder sits in
    box_outer = [
        box_inner.x+(2*box_t),
        box_inner.y+(2*box_t),
        box_inner.z + stem_z,
    ];

    box_inner_pos = [
        -box_inner.x/2,
        -box_inner.y/2,
        box_outer.z - box_inner.z
    ];

    box_outer_pos = [
        -box_outer.x/2,
        -box_outer.y/2,
        0,
    ];

    // Part of the front we'll remove and replace
    front = [box_outer.x, box_outer.y, tfront];

    module __build() {
            translate([0,0,-tfront])
            difference() {
                union() {
                    translate(box_outer_pos)
                    cube(box_outer);
                }
                union() {
                    cylinder(r=stem_d/2, h=stem_z);
                    translate(box_inner_pos) cube(box_inner);
                }
            }
    }

    if (positive) {
        __build();
    } else {
        difference() {
            translate([0,0,-tfront])
            translate(box_outer_pos)
            cube(box_outer);
            __build();
        }
    }
}

