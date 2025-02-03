use <shapes.scad>

inside = [
    36, 
    34,
    5
];
screw_mount_d = 5;

module __oled_128x64_13_mounts(size, t=1, d=3) {
    // Screw mounts
    for (x=[0,1])
    for (y=[0,1])           
    translate([
        (x * size.x) - (((x-0.5)*2) * 4),
        (y * size.y) + (((y-0.5)*2) * (screw_mount_d/2)),
    ])
    rotate( y*180 )
    screw_mount_flatside(h=size.z, dm = 5, ds=d);

    cube(size);
}

module __oled_128x64_13_pads(t) {
    pad = [6, 4, t];
    for (x=[0,1])
    for (y=[0,1])           
    translate([
        (x * inside.x) - (x * pad.x),
        (y * inside.y) - (y * pad.y),
    ])
    cube(pad);
}

module oled_128x64_13(positive, t=1, tfront=2, dh=3, ds=2.8, center=true) {

    outside = [
        inside.x + (2*t),
        inside.y + (2*t),
        inside.z
    ];

    view = [
        32,
        16,
        tfront
    ];
    view_offset_y = 10.0;

    // Relative to inside
    view_pos = [(inside.x-view.x)/2, view_offset_y];
    
    translate(center==true ? [-outside.x/2, -outside.y/2] : [0,0]) {

        // This is the "drop-in-hole" for the OLED display,
       
        if (positive==true) {

            difference() {
                __oled_128x64_13_mounts(outside, t=t, d=ds);
                translate([t,t])
                    cube(inside);
            }

            translate([t,t])
                __oled_128x64_13_pads(2.1);
        } else {
            translate([t,t,-tfront]) {
                translate(view_pos)
                flat_pyramid(view);
            }
        }
    }
}

module oled_128x64_13_support(positive, t=1, tlid=2, dh=3, dh=3.1) {

    lid = [
        inside.x + (2*t),
        inside.y + (2*t),
        tlid
    ];

    difference() {
        union() {
            cube(lid);

            // Screw mounts
            __oled_128x64_13_mounts(lid, t=t, d=dh);

            translate([t,t,lid.z])
                __oled_128x64_13_pads(1.8);
        }
        union() {
            pins = [12,6, lid.z];
            translate([(lid.x-pins.x)/2,0])
                cube(pins);

            hole = [26,20,lid.z];
            translate([(lid.x-hole.x)/2, (lid.x-hole.y)/2])
                cube(hole);

        }
    }
}

