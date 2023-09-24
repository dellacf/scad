// include instead of use to get the constants
include <modules.scad>

// baseplate_lr_con(3,3);
// rotate([0,0,270])
//edge_copy(3,3)
neg_connector([1,1,1]);

hight = 2;
inner_w = 2;
outer_w = 3;
inner_l = 1;
outer_l = 2;
total_l = inner_l + outer_l;

chamfer = 0.5;

module raw_connector_section(hight, inner_w, inner_l, outer_w, total_l) {
	linear_extrude(hight)
		polygon([
			[0, 0],
			[inner_w, 0],
			[inner_w, inner_l],
			[outer_w, total_l],
			[0, total_l]
		]);
}
 
module showPoints(v) {
    for (i = [0: len(v)-1]) {
        translate(v[i]) color("red") 
        text(str(i), font = "Courier New", size=0.2);
    }
}

module neg_connector_section(scale=[1,1,1]) {
	real_h = hight * scale[2];
	real_iw = inner_w * scale[0];
	real_ow = outer_w * scale[0];
	real_il = inner_l * scale[1];
	real_ol = outer_l * scale[1];
	real_tl = total_l * scale[1];

	diff_wh = (real_ow - real_iw)/2;
	side_chamfer_al = chamfer * diff_wh / real_ol;
	side_chamfer_aw = chamfer * diff_wh / real_ol / (cos(atan(real_ol/diff_wh)));
	
	p = [
		[real_iw-chamfer, 0, real_h],
		[real_iw-chamfer, real_il+side_chamfer_al, real_h],
		[real_ow-(chamfer+side_chamfer_aw), real_tl-chamfer, real_h],
		[0, real_tl-chamfer, real_h],
		[0, real_tl, real_h],
		[real_ow, real_tl, real_h],
		[real_iw, real_il, real_h],
		[real_iw, 0, real_h],
		[0, real_tl, real_h-chamfer],
		[real_ow, real_tl, real_h-chamfer],
		[real_iw, real_il, real_h-chamfer],
		[real_iw, 0, real_h-chamfer],
	];
	// showPoints(p);
	f = [
		[0,1,2,3,4,5,6,7],
		[8,9,5,4],
		[9,10,6,5],
		[10,11,7,6],
		[0,7,11],
		[8,4,3],
		[3,2,9,8],
		[2,1,10,9],
		[11,10,1,0],
	];

	difference(){
		raw_connector_section(real_h, real_iw, real_il, real_ow, real_tl);
		polyhedron(points = p, faces = f);
	};
}

module neg_connector(scale=[1,1,1]) {
	neg_connector_section(scale);
	mirror([1,0,0])
		neg_connector_section(scale);
	mirror([0,1,0]) {
		neg_connector_section(scale);
		mirror([1,0,0])
			neg_connector_section(scale);
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
