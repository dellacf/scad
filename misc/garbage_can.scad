width=50;
height=200;
length=150;
thickness=3;

garbage_container();

module showPoints(v) {
    for (i = [0: len(v)-1]) {
        translate(v[i]) color("red") 
        text(str(i), font = "Courier New", size=5);
         
    }
}

module garbage_hooks(w=width) {
    points=[
        [0,0],
        [0,5],
        [10,5],
        [10,10],
        [15,10],
        [15,0]
    ];
    showPoints(points);
    polygon(points);
}

module garbage_container(l=length, w=width, h=height, t=thickness) {
    difference() {
        garbage_filled(l,w,h,0);
        translate([0,t,t]) {
            garbage_filled(l,w,h,t);
        };
    };
}

module garbage_filled(l=length, w=width, h=height, t=0) {

    h1=h-2*t;
    h2=h*11/12-2*t;
    h3=h*10/12-2*t;

    r1=l/2-t;
    r2=l*11/12/2-t;
    r3=l*10/12/2-t;

    w1=w-2*t;
    w2=w*2/3-2*t;
    w3=w*1/3-2*t;

    top_back_right=[r1,0,h1];
    top_middle_right=[r1,w2,h2];
    top_front_right=[r3,w1,h3];
    top_back_center=[0,0,h1];
    top_middle_center=[0,w2,h2];
    top_front_center=[0,w1,h3];
    bot_back_right=[r2,0,0];
    bot_front_right=[r3,w2,0];
    bot_back_center=[0,0,0];
    bot_front_center=[0,w2,0];

    points=[
        top_back_right,     // 0
        top_middle_right,   // 1
        top_front_right,    // 2
        top_back_center,    // 3
        top_middle_center,  // 4
        top_front_center,   // 5
        bot_back_right,     // 6
        bot_front_right,    // 7
        bot_back_center,    // 8
        bot_front_center    // 9
    ];

    left_face=[8,9,5,4,3];
    right_face=[0,1,7,6];
    right_front_face=[1,2,7];
    top_face=[3,4,1,0];
    top_front_face=[4,5,2,1];
    bot_face=[6,7,9,8];
    front_face=[2,5,9,7];
    back_face=[6,8,3,0];

    faces=[
        right_face,
        right_front_face,
        front_face,
        bot_face,
        left_face,
        back_face,
        top_face,
        top_front_face
    ];

    trans=[0,0,h];

    add_points=[
        top_back_right,     // 0
        top_middle_right,   // 1
        top_front_right,    // 2
        top_back_center,    // 3
        top_middle_center,  // 4
        top_front_center,   // 5
        trans+top_back_right,     // 0
        trans+top_middle_right,   // 1
        trans+top_front_right,    // 2
        trans+top_back_center,    // 3
        trans+top_middle_center,  // 4
        trans+top_front_center    // 5
    ];
    //showPoints(add_points);
    add_faces=[
        [11,10,9,3,4,5],
        [2,8,11,5],
        [6,7,8,2,1,0],
        [0,1,2,5,4,3],
        [0,3,9,6],
        [9,10,7,6],
        [10,11,8,7]
    ];

    union() {
        polyhedron(points=points, faces=faces);
        mirror([1,0,0])polyhedron(points=points, faces=faces);
        if (t!=0) {
            polyhedron(points=add_points, faces=add_faces);
            mirror([1,0,0])polyhedron(points=add_points, faces=add_faces);
        };
    };

};