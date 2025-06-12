module hole_grid(size, xpadding=0, ypadding=0, xholes=2, yholes=2, r=1.4, inside=true, h=4) {

    s = [
        size.x - (2*xpadding),
        size.y - (2*ypadding),
        size.z
    ];

    pos = [
        (size.x - s.x) / 2,
        (size.y - s.y) / 2
    ];

    factor = [
        s.x / (xholes-1),
        s.y / (yholes-1)
    ];

    translate(pos)
    for (x=[0:xholes-1])
    for (y=[0:yholes-1]) {
        edgehole = (x==0 || x==(xholes-1) || y==0 || y==(yholes-1));
        if (inside || edgehole)
        translate([
            x * factor.x,
            y * factor.y,
        ])
        cylinder(r=r, h=h);
    }
}
