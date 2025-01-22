// MT32-Pi controls for 3.5" bay
// By Hans Christian Saustrup <hc@saustrup.net>
model_version = "v0.0.1";

use <lib/rotaryencoder.scad>
use <lib/oled.scad>
use <lib/pushbutton.scad>
use <lib/lcd.scad>

$fn = $preview ? 0 : 25; 

front_width = 200;
front_height = 75;
front_thickness = 4;

oled_x = 10;
oled_y = front_height/2;

difference() {
    union() {
        // Front
        cube([front_width, front_height, front_thickness]);

        // Attach to front:
        translate([0,0,front_thickness]) {
            translate([oled_x, oled_y])
                lcd_1602_mount();
            translate([oled_x+100, oled_y])
                lcd_1602_mount();
        }
    }
    union() {
        // Cut out of front:
        translate([oled_x, oled_y])
            lcd_1602_cutout(front_thickness);
        translate([oled_x+100, oled_y])
            lcd_1602_cutout(front_thickness);

    }
}

// oled_cutout();
// pushbutton_cutout();


// // Hole size for screws
// screw_insert_diameter = 2.8;

// // Enable this for a cropped version of the front only
// front_preview_only = false;

// front_width = front_preview_only ? 102 : 102;
// front_height = 25;
// front_thickness = 3;

// tray_rim_depth = 5;
// tray_rim_thickness = 2;

// tray_width = front_width;
// tray_depth = 53;
// tray_height = front_height;
// tray_thickness = 2;
// tray_bottom_bracket_width = tray_rim_depth * 3;

// side_height = front_height;
// side_thickness = 2;
// side_screws_distance_front = 52; // 47;
// side_screws_distance_bottom1 = 10;
// side_screws_distance_bottom2 = 22;

// // PCB module width
// m = 2.54;


// // PCB spacer height
// pcb_space = 6;

// pcb_horizontal_screw_distance = 23 * m;
// pcb_vertical_screw_distance = 9 * m;
// pcb_horizontal_offset = 0.5 * m;
// pcb_vertical_offset = 0.5 * m;

// display_padding = 3;
// display_width = display_padding + 22.384;
// display_height = display_padding + 5.584;
// display_hull = front_thickness;

// button_diameter = 6;
// button_rim_diameter = 8;
// button_rim_height = 2;

// rotary_diameter = 7.1;
// rotary_screw_diameter = 12;
// rotary_height = 2.0;
// rotary_tip_diameter = 2.5;
// rotary_tip_distance = 6.0;
// rotary_tip_depth = 1.45;

// rotary_ridge_depth = 0.5;
// rotary_ridge_diameter = 10;

// module screwmount(h) {
//     d = screw_insert_diameter;

//     difference() {
//         hull() {
//             cylinder(h=0.1, r=(d/2)*3.0);
//             cylinder(h=h, r=(d/2)*2.0);
//         }
//         cylinder(h=h, r=(d/2)*1);
//     }
// }

// module buttonhole() {
//     cylinder(h=front_thickness, r=(button_diameter/2));

//     translate([0,0,(front_thickness)-button_rim_height])
//     cylinder(h=front_thickness, r=(button_rim_diameter/2));
// }

// module lcdhole() {  
//     hull() {
//         cube([display_width, display_height,front_thickness]);
//         translate([-(display_hull), -(display_hull), -front_thickness]) cube([display_width+display_hull*2, display_height+display_hull*2,0.1]);
//     }
// }

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

// module pcb(w, h, cutout=false) {
//     rotate([90,0,0]) translate([-w/2 + pcb_horizontal_offset, -h/2 + pcb_vertical_offset]) {
//         if (cutout) {
//             pcb_holes(w, h);
//         } else {
//             translate([0,0,front_thickness]) pcb_mounts(w, h);
//         }
//     }
// }

// module pcb_mounts(w, h) {
//     translate([0,0,0]) screwmount(pcb_space);
//     translate([0,h-1,0]) screwmount(pcb_space);
//     translate([w-1,0,0]) screwmount(pcb_space);
//     translate([w-1,h-1,0]) screwmount(pcb_space);
// }

// module pcb_holes(w, h) {
//     // Offset from corner of component to hole
//     display_offset_x = 2.0 * m;
//     display_offset_y = 0.5 * m;
//     button_offset_x = 1.5 * m;
//     button_offset_y = 1 * m;

//     translate([
//         (11 * m) ,
//         (1 * m) 
//     ]) rotaryhole();

//     translate([
//         (4 * m) + display_offset_x,
//         (5 * m) + display_offset_y
//     ]) lcdhole();
//     translate([
//         (4 * m) + button_offset_x,
//         (0 * m) + button_offset_y
//     ]) buttonhole();
//     translate([
//         (15 * m) + button_offset_x,
//         (0 * m) + button_offset_y
//     ]) buttonhole();
// }

// module front() {
//     difference() {
//         union() {
//             translate([0,-front_thickness/2,0]) {
//                 color([1, 0.9, 0.9]) cube([front_width, front_thickness, tray_height], center = true);
//             }
//         }
//         union() {
//             pcb(23*m,9*m,true);
//         }
//     }
//     pcb(23*m,9*m);
// }

// module tray() {
//     // Move behind front
//     translate([0,-front_thickness,0]) {
       
//         // Rim
//         translate([0,-tray_rim_depth/2,0])
//         difference() {
//             cube([tray_width, tray_rim_depth, tray_height], center=true);
//             cube([tray_width - tray_rim_thickness*2, tray_rim_depth, tray_height - tray_rim_thickness*2], center=true);
//         }

//         // Tray
//         translate([0,-tray_depth/2, -(tray_height - side_height)/2])
//         difference() {
//             cube([tray_width, tray_depth, side_height], center=true);
//             union() {
//                 // Inside of tray cube
//                 union() {
//                 translate([0,0,side_thickness/2])
//                     cube([tray_width - side_thickness*2, tray_depth, side_height - side_thickness], center=true);
//                 }
//                 // Bottom cutout
//                 translate([0,-tray_bottom_bracket_width,0- (side_height/2) + side_thickness])
//                     color([1,0,0])
//                     cube([tray_width - (2*tray_bottom_bracket_width) - side_thickness/2, tray_depth - tray_bottom_bracket_width, side_thickness*2], center=true);

//                 // Screw holes
//                 translate([0, (tray_depth/2) - side_screws_distance_front + front_thickness, -side_height/2])
//                 rotate([0,90,0]) {
//                     translate([ -side_screws_distance_bottom1,0,0])
//                         cylinder(r=screw_insert_diameter/2, h=tray_width, center=true);
//                     translate([ -side_screws_distance_bottom2,0,0])
//                         cylinder(r=screw_insert_diameter/2, h=tray_width, center=true);
//                 }
//             }
//         }
//     }
// }

// front();
// if (front_preview_only == false) {
//     tray();
// }

// echo("OpenSCAD Version:", version());