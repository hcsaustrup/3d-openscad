use <lib/flatbox1.scad>
include <inc/common.scad>

// Enclosure for "PCI-E 1X TO PCI" adapter
// By Hans Christian Saustrup <hc@saustrup.net>
model_version = "v0.1.0";

// $fn = $preview ? 0 : 25;
$fn = $preview ? 0 : 50;

{
    pci_support_t = 1;

    pci_hole = [85, 9, r1 + 4];
    pci_support = [
        pci_hole.x + (2*pci_support_t),
        pci_hole.y + (2*pci_support_t),
        pci_hole.z,
    ];

    pci_hole_pos = [46.5, 18.5, -r1];
    pci_support_pos = [
        pci_hole_pos.x - ((pci_support.x - pci_hole.x) / 2),
        pci_hole_pos.y - ((pci_support.y - pci_hole.y) / 2),
        pci_hole_pos.z
    ];

    difference() {
        union() {
            flatbox1([size.x, size.y, h_top], top=true, holes=holes, r1=r1, h_mount = h_mount_top, rounded="corners", h_ridge=h_ridge);

            translate(pci_support_pos)
            cube(pci_support);
        }
        union() {
            translate(pci_hole_pos)
            cube(pci_hole);
        }
    }
}
