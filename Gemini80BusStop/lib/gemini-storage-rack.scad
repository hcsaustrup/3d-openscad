// Gemini Storage Rack
// By Hans Christian Saustrup <hc@saustrup.net>

module gemini_storage_rack(cards) {

  pcb = [205, 1.80, 205];

  slot = [pcb.x, pcb.y, 30];

  socket_thickness = [3, 3, 1];
  socket = [
    (socket_thickness.x * 2) + (slot.x),
    (socket_thickness.y * 2) + (slot.y),
    (socket_thickness.z) + slot.z,
  ];

  support_thickness = 2;

  screwplate_height = 3;
  screwplate_width = 15;

  slot_offset = [(socket.x - slot.x) / 2, (socket.y - slot.y) / 2, socket_thickness.z];

  connector_cutout = [slot.x - 8, socket.y, socket.z];
  connector_cutout_offset = [(socket.x - connector_cutout.x) / 2, 0, socket_thickness.z + 10];

  card_spacing = 25;

  for (card = [0:cards - 1])
    translate([0, card * card_spacing, 0]) {
      difference() {
        cube(socket);
        union() {
          translate(slot_offset) cube(slot);
          translate(connector_cutout_offset) cube(connector_cutout);
        }
      }
      if (card < cards - 1) {
        translate([socket.x / 2, 0, 0]) {

          for (m = [0, 1])
            mirror([m, 0, 0]) {
              translate([(socket.x / 2) - support_thickness, socket.y, 0])
                cube([support_thickness, card_spacing - socket.y, socket.z]);

              translate([(socket.x / 2) - screwplate_width - support_thickness, socket.y, 0])
              difference() {
                cube([screwplate_width, card_spacing - socket.y, screwplate_height]);
                translate([screwplate_width/2,(card_spacing - socket.y)/2,0])
                  cylinder(r=2, h=screwplate_height, center=false);
              }
            }           
        }
      }
    }
}
