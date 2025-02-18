// Chassis Connector Housing
// By Hans Christian Saustrup <hc@saustrup.net>
model_version = "v0.0.1";

ds = 3.0;
t = 1.5;

module flat_rounded_cube(size, d=4) {
    _size = [
        size.x - d,
        size.y - d,
        size.z
    ];

    translate([d/2, d/2])
    hull()
    for (x=[0, 1])
    for (y=[0, 1])
    translate([
        x * _size.x,
        y * _size.y,
        0
    ])
    cylinder(d=d, h=_size.z);
}

module _cube(size, d=4) {
    flat_rounded_cube(size, d);
    // cube(size);
}

module __generic_chassis_connector_housing(cutout, screw_distance, wires) {

    echo(["Cutout:", cutout]);
    echo(["Screw distance:", screw_distance]);

    // Flat cable - leave room for one extra wire
    cable_pitch = 1.269;
    cable_hole = [wires * cable_pitch, 1, 5];

    house1 = [
        screw_distance + 6.32,
        cutout.y + 1 + t,
        18
    ];

    house1_cutout = [
        cutout.x,
        cutout.y,
        house1.z
    ];

    house2 = [
        cable_hole.x + (2*t),
        cable_hole.y + (2*t),
        cable_hole.z
    ];
    house2_cutout = cable_hole;

    screw_cutout = [
        house1.x,
        5.5, // Nut width
        2.5 // Nut height
    ];

    difference() {
        union() {
            hull() {
                translate([-house1.x/2, -house1.y/2])
                _cube(house1, d=4);
                translate([-house2.x/2, -house2.y/2, house1.z])
                _cube(house2);
            }
            translate([-house2.x/2, -house2.y/2, house1.z + house2.z])
            _cube(house2);
        }
        union() {
            hull() {
                translate([-house1_cutout.x/2, -house1_cutout.y/2])
                _cube(house1_cutout);
                translate([-house2_cutout.x/2, -house2_cutout.y/2, house1.z])
                cube(house2_cutout);
            }
            translate([-house2_cutout.x/2, -house2_cutout.y/2, house1.z + house2.z])
            cube(house2_cutout);

            translate([-screw_cutout.x/2, -screw_cutout.y/2, screw_cutout.z * 2])
            cube(screw_cutout);

            for (x=[-0.5,0.5])
            translate([screw_distance*x, 0])
            cylinder(r=ds/2, h=house1.z);
        }
    }

}

module chassis_connector_housing_db(pins, wires=0) {
    // Row with most pins:
    maxpins = pins - floor(pins/2);

    pin_pitch = 2.775;
    pin_width = 1.7;
    pin_to_pin = (maxpins-1) * pin_pitch + pin_width;

    inside = [
        pin_to_pin + 7,
        11.5,
        5
    ];

    screw_distance = inside.x + 4.68;
    __generic_chassis_connector_housing(inside, screw_distance, wires != 0 ? wires : pins + 1);
}

module chassis_connector_housing_centronics(pins, wires=0) {
    pin_columns = pins / 2;

    pin_pitch = 2.11;
    pin_width = 1.20;
    pin_to_pin = (pin_columns - 1) * pin_pitch + pin_width;

    __generic_chassis_connector_housing(
        [
            pin_to_pin + 10.5,
            15,
            3.5
        ],
        pin_to_pin + 22.5,
        wires
    );
}