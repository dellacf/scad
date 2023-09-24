$fn = 20;

grid_size = 42;

// base dimensions
base_top_h = 2.15;
base_mid_h = 1.8;
base_bot_h = 0.7;

base_top_r = 4;
base_mid_r = 1.85;
base_bot_r = 1.15;

base_h = base_top_h + base_mid_h + base_bot_h;

// bin base dimensions
bin_top_h = 2.15;
bin_mid_h = 1.8;
bin_bot_h = 0.8;

bin_top_r = 3.75;
bin_mid_r = 1.6;
bin_bot_r = 0.8;

bin_h = bin_top_h + bin_mid_h + bin_bot_h;

// bin lip dimensions
lip_top_h = 1.9;
lip_mid_h = 1.8;
lip_bot_h = 0.7;

lip_top_r = 3.75;
lip_mid_r = 1.85;
lip_bot_r = 1.15;

lip_r = 0.5;

lip_h = lip_bot_h + lip_mid_h + lip_bot_h;

// magnet pad hole dimensions
mag_hole_outer_d = 6.5;
mag_hole_outer_h = 2;

mag_hole_inner_d = 3;
mag_hole_inner_h = 2;

mag_pad_outer_d = mag_hole_outer_d + 2;

mag_pad_h = mag_hole_outer_h + mag_hole_inner_h;
mag_pad_rim = 2;

mag_hole_edge_distance_bin = bin_top_r - bin_bot_r + 4.8;
mag_hole_edge_distance_base = mag_hole_edge_distance_bin + 0.25;

// bin tolerance
bin_tolerance = 0.5;

// baseplate connector dimensions
con_insert_d = 3.9;
con_screw_d = 3;

con_l = 5;


/* copy an element to the edges of a grid
edge = [
	1 => copy element to the left edge (-y)
	1 => copy element to the front edge (+x)
	1 => copy element to the right edge (+y)
	1 => copy element to the back edge(-x)
]
*/
module edge_copy(x_count=1, y_count=1, edge=[1,1,1,1]) {
	// left edge
	if (edge[0]) {
		yy = -grid_size/2;
		for (xx=[0:x_count-1]) {
			translate([xx*grid_size, yy, 0])
				children();
		}
	}
	// front edge
	if (edge[1]) {
		xx = grid_size * (x_count - 1/2);
		for (yy=[0:y_count-1]) {
			translate([xx, yy*grid_size, 0])
				rotate([0,0,90])
					children();
		}
	}
	// right edge
	if (edge[2]) {
		yy = grid_size * (y_count - 1/2);
		for (xx=[0:x_count-1]) {
			translate([xx*grid_size, yy, 0])
				rotate([0,0,180])
					children();
		}
	}
	// back edge
	if (edge[3]) {
		xx = -grid_size/2;
		for (yy=[0:y_count-1]) {
			translate([xx, yy*grid_size, 0])
				rotate([0,0,270])
					children();
		}
	}
}

// copy an element to the corners of a grid
module corner_copy(r, x_count=1, y_count=1) {
	for (xx=[-r, grid_size*(x_count-1) + r]) {
		for (yy=[-r, grid_size*(y_count-1) + r]) {
			translate([xx, yy, 0])
				children();
		}
	}
}

// copy an element to fill a grid with grid_size distance
module grid_copy(x_count=1, y_count=1) {
	for (xx=[0:x_count]) {
		for (yy=[0:y_count]) {
			translate([grid_size*(xx-1), grid_size*(yy-1), 0])
				children();
		}
	}
}
