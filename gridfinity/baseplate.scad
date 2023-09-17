// include instead of use to get the constants
include <modules.scad>

baseplate_lr_con(3,3);
// rotate([0,0,270])
// connector_shape();

module connector_shape() {
	inner_w = 4;
	outer_w = 6;
	length = 3;
	hight = 4;
	linear_extrude(2)
		polygon([[-inner_w/2,0], [inner_w/2,0], [outer_w/2,length], [-outer_w/2,length]]);
}

// left = -y
module connector_left(x_count=1, y_count=1, male=true) {
	rot = male ? 180 : 0;
	yy = -grid_size/2;
	for (xx=[0:x_count-1]) {
		translate([xx*grid_size, yy, 0])
			rotate([0,0,rot])
				connector_shape();
	}
}

// front = +x
module connector_front(x_count=1, y_count=1, male=true) {
	rot = male ? 270 : 90;
	xx = grid_size * (x_count - 1/2);
	for (yy=[0:y_count-1]) {
		translate([xx, yy*grid_size, 0])
			rotate([0,0,rot])
				connector_shape();
	}
}

// right = +y
module connector_right(x_count=1, y_count=1, male=true) {
	rot = male ? 0 : 180;
	yy = grid_size * (y_count - 1/2);
	for (xx=[0:x_count-1]) {
		translate([xx*grid_size, yy, 0])
			rotate([0,0,rot])
				connector_shape();
	}
}

// back = -x
module connector_back(x_count=1, y_count=1, male=true) {
	rot = male ? 90 : 270;
	xx = -grid_size/2;
	for (yy=[0:y_count-1]) {
		translate([xx, yy*grid_size, 0])
			rotate([0,0,rot])
				connector_shape();
	}
}

module baseplate_lr_con(x_count=1, y_count=1) {
	difference() {
		union() {
			baseplate(x_count, y_count);
			connector_right(x_count, y_count, true);
		}
		connector_left(x_count, y_count, false);
	}
	
}

// baseplate that can be resized in x and y diection
module baseplate(x_count=1, y_count=1) {
	difference() {
		translate([-grid_size/2,-grid_size/2,0])
			cube(size = [x_count*grid_size, y_count*grid_size, base_h+mag_pad_h]);
		grid_copy(x_count, y_count)
			baseplate_pad();
	}
}

// complete pad with magnet and screw holes as a negative to remove from a solid block
module baseplate_pad() {
	union() {
		translate([0,0,mag_pad_h])
			baseplate_basic_pad();
		baseplate_mag_pad();
	}
}

// basic baseplate pad as a negative to remove from a solid block
module baseplate_basic_pad() {
	corner_position = grid_size/2 - base_top_r;
	// segment top
	hull()
		corner_copy(r=corner_position)
			translate([0,0,base_mid_h+base_bot_h])
				cylinder(r2=base_top_r, r1=base_mid_r, h=base_top_h);
	// segment mid
	hull()
		corner_copy(r=corner_position)
			translate([0,0,base_bot_h])
				cylinder(r=base_mid_r, h=base_mid_h);
	// segment bot
	hull()
		corner_copy(r=corner_position)
			cylinder(r2=base_mid_r, r1=base_bot_r, h=base_bot_h);
}

// pad with pockets for magnets
module baseplate_mag_pad() {
	corner_position = grid_size/2 - base_top_r - mag_pad_rim;
	hole_position = grid_size/2 - mag_hole_edge_distance_base;

	difference() {
		hull()
			corner_copy(r=corner_position)
				cylinder(r=base_bot_r, h=mag_pad_h);
		translate([hole_position, hole_position,0])
			baseplate_mag_pocket();
		translate([-hole_position, hole_position,0])
			rotate([0, 0, 90])			
				baseplate_mag_pocket();
		translate([-hole_position, -hole_position,0])
			rotate([0, 0, 180])			
				baseplate_mag_pocket();
		translate([hole_position, -hole_position,0])
			rotate([0, 0, 270])			
				baseplate_mag_pocket();
	}
}

// single corner pocket for a magnet with a screw hole
module baseplate_mag_pocket() {
	difference() {
		union() {
			cylinder(d=mag_pad_outer_d, h=mag_pad_h);
			translate([-mag_pad_outer_d/2,0,0])
				cube([mag_hole_edge_distance_base+mag_pad_outer_d/2, mag_hole_edge_distance_base, mag_pad_h]);
			translate([0,-mag_pad_outer_d/2,0])
				cube([mag_hole_edge_distance_base, mag_hole_edge_distance_base+mag_pad_outer_d/2, mag_pad_h]);
		}
		union() {
			translate([0,0,mag_hole_inner_h])
				cylinder(d=mag_hole_outer_d, h=mag_hole_outer_h);
			cylinder(d=mag_hole_inner_d, h=mag_hole_inner_h);
		}
	}
}
