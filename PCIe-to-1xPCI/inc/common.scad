size = [135, 50];
hole_distance = [110, 38];
hole_offset = [7.5, 0];

r1 = 2;

calculated_offset = [
    ((size.x - hole_distance.x) / 2) + hole_offset.x,
    ((size.y - hole_distance.y) / 2) + hole_offset.y
];
holes = [
    [calculated_offset.x, calculated_offset.y],
    [calculated_offset.x + hole_distance.x, calculated_offset.y],
    [calculated_offset.x, calculated_offset.y + hole_distance.y],
    [calculated_offset.x + hole_distance.x, calculated_offset.y + hole_distance.y]
];

h_top = 4;
h_bottom = 11.5;
h_ridge = 1;
h_pcb = 1.6;
h_mount_bottom = 3;
h_mount_top = (h_top + h_bottom) - h_mount_bottom - h_pcb;

