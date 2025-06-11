// Birdfeeder-thing
// By Hans Christian Saustrup <hc@saustrup.net>
model_version = "v0.0.1";

use <lib/common.scad>

$fn = $preview ? 0 : 50;

// connector thickness

__build();

module __build() {

    r1 = 3.1 / 2;
    r2 = 3.3 / 2;

    cylinder(r=7.25/2, h=0.7);

    hull() {
    cylinder(r=r1, h=0.5 + 3.3);
    cylinder(r=r2, h=0.5 + 0.1);

    }


}