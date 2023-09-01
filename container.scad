$fn=200;

top_length=150;
top_width=100;

bottom_length=140;
bottom_width=90;

height=50;
side_radius=20;
bottom_radius=10;

thickness=2;

container();

module container(top_length=top_length,
                   top_width=top_width,
                   bottom_length=bottom_length,
                   bottom_width=bottom_width,
                   height=height,
                   side_radius=side_radius,
                   bottom_radius=bottom_radius,
                   thickness=thickness) {
    difference() {
        filled_form(top_length,top_width,bottom_length,bottom_width,height,side_radius,bottom_radius);
        translate([0,0,thickness]) {
            filled_form(top_length-2*thickness,top_width-2*thickness,bottom_length-2*thickness,bottom_width-2*thickness,height,side_radius-thickness/2,bottom_radius-thickness/2);
        }
    }
}

module filled_form(top_length,
                   top_width,
                   bottom_length,
                   bottom_width,
                   height,
                   side_radius,
                   bottom_radius) {
    hull() {

        height_offset=0.001;
        correct_height=height-height_offset;

        // top layer
        top_x_translate=top_length/2-side_radius;
        top_y_translate=top_width/2-side_radius;

        translate([top_x_translate,top_y_translate,correct_height]){
            cylinder(h=height_offset, r=side_radius, center=true);
        }

        translate([top_x_translate,-top_y_translate,correct_height]){
            cylinder(h=height_offset, r=side_radius, center=true);
        }

        translate([-top_x_translate,top_y_translate,correct_height]){
            cylinder(h=height_offset, r=side_radius, center=true);
        }

        translate([-top_x_translate,-top_y_translate,correct_height]){
            cylinder(h=height_offset, r=side_radius, center=true);
        }

        //bottom layer
        bottom_x_translate=bottom_length/2-side_radius;
        bottom_y_translate=bottom_width/2-side_radius;

        translate([bottom_x_translate,bottom_y_translate,bottom_radius]){
            corner(side_radius, bottom_radius);
        }

        translate([bottom_x_translate,-bottom_y_translate,bottom_radius]){
            corner(side_radius, bottom_radius);
        }

        translate([-bottom_x_translate,bottom_y_translate,bottom_radius]){
            corner(side_radius, bottom_radius);
        }

        translate([-bottom_x_translate,-bottom_y_translate,bottom_radius]){
            corner(side_radius, bottom_radius);
        }
    }
}

module corner(side_radius, bottom_radius) {
    hull() {
        rotate_extrude(angle=360) {
            translate([side_radius-bottom_radius,0,0]) {
                half_circle(bottom_radius);
            }
        }
    }
}

module half_circle(r) {
    angles = [-90, 90];
    steps = (angles[1]-angles[0])/$fn;
    points = [
        for(a = [angles[0]:steps:angles[1]]) [r * cos(a), r * sin(a)]
    ];
    polygon(concat([[0, 0]], points));
}