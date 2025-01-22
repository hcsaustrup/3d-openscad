module pushbutton_cutout(d0=5, d1=8, h0=2, h1=4) {
    cylinder(h=h0, r=(d0/2));

    translate([0,0,h0])
        cylinder(h=h1, r=(d1/2));
}
