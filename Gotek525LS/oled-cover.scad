// MT32-Pi controls for 3.5" bay
// By Hans Christian Saustrup <hc@saustrup.net>
model_version = "v0.0.1";

use <lib/rotaryencoder.scad>
use <lib/oled128x64-13.scad>
use <lib/pushbutton.scad>
use <lib/shapes.scad>
use <lib/traymount.scad>

include <inc/common.scad>

oled_128x64_13_support();
