module __rotaryencoder(thickness, type, positive) {

    rotary_bottom_width = 20;
    rotary_bottom_height = 15;
    rotary_box_width = 12;
    rotary_box_height = 12;
    rotary_box_depth = 4;

    rotary_thread_diameter = 7.1;
    rotary_thread_height = 6;

    rotary_nut_diameter = 12;
    rotary_nut_height = 2.5;

    rotary_nudge_diameter = 2.5;
    rotary_nudge_distance = 6.0;
    rotary_nudge_depth = 1.45;

    // Tiny ridge on top of the rotary encoder housing, before the thread starts
    rotary_ridge_diameter = rotary_nut_diameter;
    rotary_ridge_height = 0.5;

    mount_diameter = rotary_thread_diameter * 2;

    // module rotaryhole() {
    //     // Primary hole
    //     cylinder(h=front_thickness, r=(rotary_diameter/2));

    //     // Screw/washer hole
    //     cylinder(h=(front_thickness-rotary_height), r=(rotary_screw_diameter/2));

    //     // Ridge thing
    //     translate([0, 0, front_thickness - rotary_ridge_depth])
    //         cylinder(h=rotary_ridge_depth, r=rotary_ridge_diameter/2);

    //     // The nudge/tip:
    //     translate([-rotary_tip_distance, 0, front_thickness - rotary_tip_depth])
    //         cylinder(h=rotary_tip_depth, r=rotary_tip_diameter/2);
    // }

    if (positive == true) {

        // mount_height = rotary_thread_height - thickness;
        // if (mount_height > 0) {
        //     difference() {
        //         cylinder(h=mount_height, r=(mount_diameter/2));
        //         union() {
        //             cylinder(h=mount_height, r=(rotary_thread_diameter/2));
        //             cylinder(h=mount_height-ridge, r=(rotary_ridge_diameter/2));
        //         }
        //     }   
        // }

        if (type == "nudge") {
            // cylinder(h=thickness, r=(rotary_thread_diameter/2));
        } else if (type == "boxed") {
            translate([-rotary_bottom_width/2, -rotary_bottom_height/2,-5])
                cube([rotary_bottom_width, rotary_bottom_height, thickness]);
        }

    } else {

        if (type == "nudge") {
            cylinder(h=thickness, r=(rotary_mount_diameter/2));
        } else if (type == "boxed") {

             cylinder(h=max(rotary_thread_diameter, thickness), r=(rotary_thread_diameter/2));
             cylinder(h=max(rotary_nut_height, thickness), r=(rotary_nut_diameter/2));

            delta = thickness - rotary_thread_height;
            if (delta > 0) {

            }

            // translate([-rotary_bottom_width/2, -rotary_bottom_height/2])
            //     cube([rotary_bottom_width, rotary_bottom_height, thickness]);
        }


        // translate([0,0,thickness - rotary_nut_height])
        //     cylinder(h=rotary_nut_height, r=(rotary_thread_diameter/2));

    }

}

module rotaryencoder_boxed(thickness, positive) {
    __rotaryencoder(thickness, "boxed", positive);
}

module rotaryencoder_nudge(thickness, positive) {
    __rotaryencoder(thickness, "nudge", positive);
}
