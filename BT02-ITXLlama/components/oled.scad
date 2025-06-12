pcb_m = 2.57; // Spacing between PCB holes (1/10")
button_r1 = 6.0 / 2;     // Button top
button_r2 = 7.75 / 2;    // Button "rim"
button_t = 1.5;            // Thickness of "rim" in plate
button_h = 11;           // Height from PCB to overside of button rim

module oled(pos=true, t, flip=false) {
    view_size = [30,16,1];
    mount_size = [7, 4, 2];
    oled_size = [35.5, 34, t - view_size.z];
    
    // Flipping EVERYTHING really isn't necessary
    mirror([0, flip ? 1 : 0, 0])
    translate([0, flip ? -oled_size.y : 0, 0])
    if (pos) {
        translate([0, oled_size.y/2, view_size.z])
        color([0,0.6,0])
        for (x=[0:1])
        for (y=[0:1])
        mirror([x,0,0])
        mirror([0,y,0])
        translate([
            (oled_size.x/2) - mount_size.x,
            (oled_size.y/2) - mount_size.y
        ])
        cube(mount_size);
   } else {
        translate([-view_size.x/2, 7.5])
        cube(view_size);
        translate([-oled_size.x/2, 0, view_size.z])
        cube(oled_size);
    }
}

module r2b(pos=true, t, screw_r) {

    r_r1 = 7.0 / 2;     // Radius of stem
    r_r2 = 12.0 / 2;
    r_h = 6.5;          // Height from PCB to overside of rotary box
    r_h2 = 2;
    
    pcb_z = button_h + button_t;

    r_outside_size = [12, 12, 6.5];
    r_outside_pos = [
        -r_outside_size.x/2, 
        -r_outside_size.y/2,
        pcb_z - r_outside_size.z
    ];

    m_h = pcb_z - t;
    s_h = (t + m_h) - 2; // Screw depth
    mount_pos = [0 , 9 * pcb_m];

    translate([0, r_outside_size.y/2])
    if (pos) {
        
        // Mount
        translate([0,0,t])
        translate(mount_pos)
        difference() {
            cylinder(r=screw_r * 2.5, h=m_h);
            cylinder(r=screw_r, h=m_h);
        }

    } else {
        // Rotary
        cylinder(r=r_r1, h=t);
        cylinder(r=r_r2, h=r_h2);

        translate(r_outside_pos)
        cube(r_outside_size);

        // Buttons
        translate([0,6 * pcb_m])
        for (x=[0,1])
        mirror([x,0,0])
        translate([2.5 * pcb_m, 0]) {
            cylinder(r=button_r1, h=button_t);
            translate([0, 0, button_t])
            cylinder(r=button_r2, h=t - button_t);
        }

        // Mount
        translate(mount_pos)
        translate([0, 0, 1])
        cylinder(r=screw_r, h=t-1);
    }
}

module 1b(pos=true, t, screw_r) {
    pcb_z = button_h + button_t;

    m_h = pcb_z - t;
    s_h = (t + m_h) - 2; // Screw depth
    mount_pos = [0 , 3.5 * pcb_m];

    if (pos) {
       
        for (y=[0,1])
        mirror([0, y, 0])
        translate(mount_pos)
        translate([0, 0, t])
        difference() {
            cylinder(r=screw_r * 2.5, h=m_h);
            cylinder(r=screw_r, h=m_h);
        }

    } else {
        // Buttons
        cylinder(r=button_r1, h=button_t);
        translate([0, 0, button_t])
        cylinder(r=button_r2, h=t - button_t);

        translate([0, 0, 1])
        for (y=[0,1])
        mirror([0, y, 0])
        translate(mount_pos)
        cylinder(r=screw_r, h=t-1);
    }
}

module switch(pos=true, t) {
    size = [13, 13.25, t];
    r1 = 6 / 2;
    r2 = 11 / 2;
    t2 = 2.5 + 2;

    box_t = 1;
    box_size = [
        size.x+(2*box_t),
        size.y+(2*box_t),
        1,
    ];

    if (pos) {
        difference() {
            translate([-box_size.x/2,-box_size.y/2,t])
            cube(box_size);
            translate([-size.x/2,-size.y/2,t])
            cube(size);
        }
    } else {
        cylinder(r=r1, h=t);
        cylinder(r=r2, h=t2);
    }
}



module sd(pos=true, t, screw_r) {
    outside_t = 1.3;

    cutout_size = [12, 1.25, 1.0];
    inside_size = [19.75, 3, 22];
    outside_size = [
        inside_size.x + (2*outside_t),
        inside_size.y + (2*outside_t),
        inside_size.z
    ];

    box_pos = [-0.15, 0.8 , cutout_size.z];

    screwbox_size = [
        screw_r * 4,
        4,
        outside_size.z
    ];

    ribbon_size = [
        20.5,
        0.5,
        6
    ];

    if (pos) {
        difference() {
            union() {
                // Outer box
                translate(box_pos)
                translate([-outside_size.x/2, -outside_size.y/2])
                cube(outside_size);

                // Screw box
                translate(box_pos)
                translate([-screwbox_size.x/2, (-outside_size.y/2)-screwbox_size.y])
                cube(screwbox_size);
            }
            union() {
                // Inside
                translate(box_pos)
                translate([-inside_size.x/2, -inside_size.y/2])
                cube(inside_size);

                // Box-related stuff:
                translate([box_pos.x, box_pos.y, box_pos.z])
                union() {
                    // Ribbon cable cutout
                    translate([
                        ribbon_size.x/-2,
                        (inside_size.y-ribbon_size.y)/2,
                        inside_size.z - ribbon_size.z
                    ])
                    cube(ribbon_size);

                    // Screw hole
                    translate([0, (-outside_size.y/2)-screwbox_size.y, 15.1 + screw_r])
                    rotate([270,0,0])
                    cylinder(r=screw_r, h=screwbox_size.y + outside_t);
                }
           }
        }
    } else {
        // Cut outside away from plate
        translate(box_pos)
        translate([-outside_size.x/2, -outside_size.y/2])
        cube(outside_size);

        // Make viewport cutout in plate
        translate([-cutout_size.x/2, -cutout_size.y/2])
        cube(cutout_size);
    }
}

