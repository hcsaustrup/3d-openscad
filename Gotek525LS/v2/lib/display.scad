use <shapes.scad>

module generic(thickness, positive, vars, ds=2.3) {

    module __lcd_cutout(x, y, width, height, thickness) {
        translate([x, y])
            flat_pyramid(width,height,thickness);
    }

    module __lcd_mount(width, height, spacer) {
        for (x=[0, width]) {
            for (y=[0, height]) {
                translate([x,y])
                    screw_mount(h=spacer, ds=ds);
            }
        }
    }

    if (positive == true) {
        __lcd_mount(
            vars[0], // hole_width,
            vars[1], // hole_height,
            vars[2] // spacer
        );
    } else {

        // Extra screw depth in front plate
        sd = thickness-1;
        for (x=[0, vars[0]]) {
            for (y=[0, vars[1]]) {
                translate([x, y, thickness-sd]) screw_hole(h=sd, d=ds);
            }
        }

        __lcd_cutout(
            vars[3], // view_x,
            vars[4], // view_y,
            vars[5], // view_width,
            vars[6], // view_height,
            thickness // thickness
        );
    }
}

// module oled_128x64_13(thickness, positive, ds=2.3) {
//     generic(thickness, positive, [
//         30.5,   // hole_width
//         28.6,   // hole_height
//         2,      // spacer
//         -1,     // view_x
//         8.0,    // view_y
//         32,     // view_width
//         16      // view_height
//     ], ds=ds);
// }

module lcd_1602(thickness, positive, ds=2.3) {
    generic(thickness, positive, [
        80,     // hole_width
        31,     // hole_height
        7,      // spacer
        7.5,    // view_x
        5.5,    // view_y
        65,     // view_width
        20      // view_height
    ], ds=ds);
}
