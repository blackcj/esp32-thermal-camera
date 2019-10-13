// Global config variables
enclosure_height = 14;
enclosure_length = 94;
enclosure_width = 58;
enclosure_radius = 40;
wall_thickness = 1.6;
$fn = 64; // curved resolution (used for cylinders and spheres)


// Position all of the modules
translate([wall_thickness,enclosure_length - 43.5,-6]) {
    lensRound();
}
translate([25,0,0])cube([1.6,6,11]);
translate([25,22,0])cube([1.6,28,12]);
difference() {
    buildBase();
    // Micro usb slot
    translate([37.9,-1,6.9])cube([8.2,4.1,3.4]);
    // Power switch
    translate([-1,30,2.5])cube([4,13,8]);
    // Camera lense
    translate([wall_thickness,enclosure_length - 43.5,-2]) {
        translate([21,21,0]) cylinder(r=40.2/2,h=8);
    }
    translate([9,enclosure_length - 9,-1]) {
        rotate([0,0,45]) {
            cube([3,4,3]);
        }
    }
}

difference() {
    translate([33,4.1,0]) {
        difference() {
            featherScrew();
            translate([-2.5,-2.5,6]) {
                featherBoard();
            }
        }
    }
    translate([20,-1.1,-1]) {
        cube([41,wall_thickness+1,enclosure_height + 2]);
    }
}


translate([30.5,wall_thickness,6]) {
    #featherBoard();
}

module rcube(size, radius) {
    // rcube module found here: https://www.prusaprinters.org/parametric-design-in-openscad/
    hull() {
        translate([radius, radius]) cylinder(r = radius, h = size[2]);
        translate([size[0] - radius, radius]) cylinder(r = radius, h = size[2]);
        translate([size[0] - radius, size[1] - radius]) cylinder(r = radius, h = size[2]);
        translate([radius, size[1] - radius]) cylinder(r = radius, h = size[2]);
        //translate([1, size[1] - 1]) cylinder(r = 1, h = size[2]);
    }
}

// Base of enclosure
module buildBase() {
    // Cylinder with a smaller cylinder cut out of it
    difference() {
        rcube([enclosure_width,enclosure_length,enclosure_height], 6);

        //cylinder(h = enclosure_height, r = enclosure_radius);
        // Make the cylinder hollow
        translate([wall_thickness,wall_thickness,wall_thickness]) {
            rcube([enclosure_width - wall_thickness * 2, enclosure_length - wall_thickness * 2,enclosure_height], 6);
          inner_height = enclosure_height;
          inner_radius = enclosure_radius - (wall_thickness * 2);
          //cylinder(h = inner_height, r = inner_radius, center = false);
        }

        // Flat back for power hookup
        translate([enclosure_radius - 5,-10,5]) {
          //cube([8,20,7]);
        }
        translate([enclosure_width / 2,enclosure_length / 2,enclosure_height - 14]) {
          radialVents(2, 6, 2, 3, enclosure_radius + 20);
        }
    }
}

// Radial vents
// ventSpacing in mm
// horizontalSpacing in degrees (divisible by 360)
module radialVents(verticalSpacing, horizontalSpacing, size, numRows, ventRadius) {
    for ( m = [0 : numRows] ){
        for ( k = [102 : 130] ){
            // Rotate by 45 degrees to avoid needing support when printing
            translate([0,0,m * verticalSpacing + 4]) {
                offset = horizontalSpacing / 2;
                rotate( k * horizontalSpacing - m * offset, [0, 0, 1]){
                    rotate( 45, [0, 1, 0]) {
                        cube([size, ventRadius, size]);
                    }
                }
            }
        }
    }
}

// Featherboard with usb
module featherBoard() {
    difference() {
        rcube([22.86,50.8,1.19], 2.5);
        translate([2.54,2.54,-2])cylinder(r=1.35, h=14);
        translate([20.32,2.54,-2])cylinder(r=1.35, h=14);
    }
    translate([7.43,-1.2,1]) {
        cube([8, 5, 2.7]);
    }
    translate([1.4,40,-1]) {
        cube([20, 11, 2]);
    }
    translate([15.33,17.42,-2])cylinder(r=1.5, h=2);
    translate([6.7,17.42,-2])cylinder(r=1.5, h=2);
}

// Screw mount spaced for a feather board
module featherScrew() {
    translate([0,0,0])screwmountM25();
    translate([-2.7,43.5,0])frictionmount(1.1, 7.1);
    translate([19.3,47.5,0])frictionmount(1.1, 7.1);
    translate([17.78,0,0])screwmountM25();
}

// M2.5 screw mount for 6mm length M2.5 screws
module screwmountM25() {
    translate([0,0,1.9]) {
        rotate_extrude(convexivity = 10) {
            translate([2.5,0,0]) {
                intersection() {
                    square(8);
                    difference() {
                        square(5, center = true);
                        translate([4,4])circle(4);
                    }
                }
            }
        }
    }
    cylinder(r=5, h=2);
    difference() {
        cylinder(r=2.5, h=6);
        translate([0,0,1]) {
            #cylinder(r=1.2, h=6);
        }
    }
}

// Friction mount for screw holes
module frictionmount(pegRadius, pegHeight = 7, lift = 0) {
 translate([0,0,2.8]) {
        rotate_extrude(convexivity = 10) {
            translate([2.5,0,0]) {
                intersection() {
                    square(8);
                    difference() {
                        square(5, center = true);
                        translate([4,4])circle(4);
                    }
                }
            }
        }
    }
    cylinder(r=5, h=3);
    cylinder(r=2.5, h=pegHeight);
    cylinder(r=pegRadius, h= (pegHeight + lift));
}

module lensRound() {
    difference() {
        translate([21,21,0]) cylinder(r=42/2,h=6);
        translate([21,21,1]) cylinder(r=38/2,h=12);
        translate([21, 21, 0])roundCamera();
    }
    difference() {
        translate([21,21,0]) cylinder(r=40/2,h=10);
        translate([21,21,1]) cylinder(r=38/2,h=15);
        translate([21, 21, 0])roundCamera();
    }
    translate([19.5,-1,8])cube([3,3,2]);
    translate([10.8,10.8,0])screwmountC();
    translate([10.8,31.2,0])screwmountC();
    translate([31.2,31.2,0])screwmountC();
    translate([31.2,10.8,0])screwmountC();
}

module roundCamera() {
    translate([0,0, -1])cylinder(r=9/2,h=12);
    translate([0,0, -2])cylinder(r1=16/2, r2=9/2,h=3);
}

module screwmountC() {        
    cylinder(r=4, h=8);
    cylinder(r=3, h=12);
    cylinder(r=1.5, h=15); 
}