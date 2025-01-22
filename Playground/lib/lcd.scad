use <shapes.scad>

module __lcd_cutout(x, y, width, height, thickness) {
    translate([x, y])
        flat_pyramid(width,height,thickness);
}

module __lcd_mount(width, height, spacer) {
    screw_mount(h=spacer);
    translate([width, 0]) screw_mount(h=spacer);
    translate([width, height]) screw_mount(h=spacer);
    translate([0, height]) screw_mount(h=spacer);
}

//----------------------------------------------------------------------
//  16x2 LCD
//----------------------------------------------------------------------

lcd_1602_hole_width = 80;
lcd_1602_hole_height = 31;
lcd_1602_spacer = 7;
lcd_1602_view_width = 65;
lcd_1602_view_height = 20;
lcd_1602_view_x = 7.5;
lcd_1602_view_y = 5.5;

module lcd_1602_mount() {
    __lcd_mount(lcd_1602_hole_width, lcd_1602_hole_height, lcd_1602_spacer);
}

module lcd_1602_cutout(thickness) {
    __lcd_cutout(
        lcd_1602_view_x, lcd_1602_view_y,
        lcd_1602_view_width,lcd_1602_view_height,
        thickness
    );
}
