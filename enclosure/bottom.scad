// Global config variables
enclosure_height = 16;
enclosure_length = 105; // Note: 105mm was a bit too small. Recommend going to 110mm at some point.
enclosure_width = 60.5;
enclosure_radius = 40;
wall_thickness = 1.6;
$fn = 64; // curved resolution (used for cylinders and spheres)

//enclosureBase();

//#displayInternalParts();

//internalSupport();

translate([9,-50,0]) {
    //lensRound(0.4);
    //lensRound(6);
}

translate([-enclosure_width - 10,0,0]) {
    difference() {
        enclosureLid();
        translate([19.3,30.3,-2]) {
            cube([17.4, 14.4, 5]);
        }
        translate([29.4,37.5,-0.1]) {
            rotate([0,0,45])cylinder(8,12,4,$fn=4);
        }
        translate([26.4,37.5,-0.1]) {
            rotate([0,0,45])cylinder(8,12,4,$fn=4);
        }

    }
}

module internalSupport() {
    support_padding = wall_thickness + 0.1;
    support_offset = 50;
    support_length = enclosure_length - support_offset - support_padding;
    support_width = enclosure_width - support_padding * 2;
    
    translate([enclosure_width / 2 - 12.4,support_offset + 30,9]) {
        cylinder(r=3, h=2.2);
        cylinder(r=1.47, h=4);
    }
    translate([enclosure_width / 2 + 9,support_offset + 30,9]) {
        cylinder(r=3, h=2.2);
        cylinder(r=1.47, h=4);
    }
    translate([enclosure_width / 2 - 11.8,support_offset + 3,9]) {
        cylinder(r=3, h=2);
    }
    translate([enclosure_width / 2 + 9,support_offset + 18,9]) {
        cylinder(r=3, h=2);
    }
    
    difference() {
        translate([support_padding,support_offset,9]) {
            difference() {
                rcube([support_width, support_length,1.2], 5);
                translate([6,21,-2]) {
                    cube([7, support_length - 26, 5]);
                }
                translate([support_width - 16,21,-2]) {
                    cube([10, support_length - 26, 5]);
                }
                translate([support_width / 2 - support_width / 8 - 1.7,support_length - 38,-2]) {
                    cube([support_width / 4, 20, 5]);
                }
                translate([support_width / 2 - support_width / 8 - 1.7,support_length - 12,-2]) {
                    cube([support_width / 4, 6, 5]);
                }
                translate([support_width / 2 - support_width / 8 - 1.7,-1,-2]) {
                    cube([support_width, 14, 5]);
                }
                translate([support_width / 2 - support_width / 8 - 5,-1,-2]) {
                    cube([support_width, 4, 5]);
                }
            }
        }
        translate([3.5 + support_padding,enclosure_length - 3.5 - support_padding,6]) {
            cylinder(r=1.4, h=(10 - support_padding));
        }
        translate([enclosure_width - 3.5 - support_padding,enclosure_length - 3.5 - support_padding,6]) {
            cylinder(r=1.4, h=(10 - support_padding));
        }
        translate([enclosure_width - 2.5 - support_padding,support_offset + 17.5 + support_padding,6]) {
            cylinder(r=1.4, h=(10 - support_padding));
        }
        translate([3.5 + support_padding,support_offset + 17.5 + support_padding,6]) {
            cylinder(r=1.4, h=(10 - support_padding));
        }
        translate([0,60.8,6]) {
            cube([12.4, 2, 12]);
        }
    }
}

module displayInternalParts() {
    // Power switch
    translate([10,-1.2,4])cube([14.2,12,8.8]);
    translate([12,-3.4,5])rotate([0,0,20])cube([10,3,7]);
    translate([13,10,6])cube([1.2,6,4]);
    translate([20,10,6])cube([1.2,6,4]);
    
    // Battery
    translate([2,24,2]) {
        // 500 mAh
        cube([29,36,6]);
        // 400 mAh
        //#cube([26,37,5]);
    }

    // Feather board
    translate([enclosure_width - 27,wall_thickness,5]) {
        thingPlusBoard();
    }
    
    // OLED
    
}

module enclosureLid() {
    lid_offset = wall_thickness + 0.1;
    rcube([enclosure_width,enclosure_length,wall_thickness], 6);
    translate([wall_thickness,58,lid_offset - 0.1])cube([enclosure_width - wall_thickness * 2, 2, 1.8]);
    translate([enclosure_width/2 - 3,58,lid_offset - 0.1])cube([2, 44, 1.8]);
    translate([enclosure_width - 12,lid_offset,lid_offset - 0.1])cube([2, 58, 1.8]);
    difference() {
        
        // Make the cylinder hollow
        translate([wall_thickness,lid_offset,lid_offset - 0.1]) {
            rcube([enclosure_width - wall_thickness * 2, enclosure_length - lid_offset * 2,2.6], 5.2);
          inner_height = enclosure_height;
          inner_radius = enclosure_radius - (lid_offset * 2);
        }
        translate([wall_thickness*2,wall_thickness*2,1]) {
            rcube([enclosure_width - wall_thickness * 4, enclosure_length - wall_thickness * 4,6], 4);
          inner_height = enclosure_height;
          inner_radius = enclosure_radius - (wall_thickness * 2);
        }
    }
}

module enclosureBase() {
    difference() {
        enclosureWalls();
        // Micro usb slot
        translate([enclosure_width - 19.4,-1,5.7])cube([8.8,4,3.8]);
        // Power switch
        translate([10,-1,4])cube([14.2,8,8.8]);
        // Camera lense
        translate([9,enclosure_length - 43.5,-2]) {
            translate([21,21,0]) cylinder(r=40.2/2,h=8);
        }
        // Lens notch
        translate([16,enclosure_length - 9,-1]) {
            rotate([0,0,45]) {
                cube([3,4,3]);
            }
        }
        // Camera strap
        translate([5.4,enclosure_length - 9,8]) {
            rotate([10,45,15]) {
                cube([1.6,20,1.6]);
            }
        }
        translate([4.8,enclosure_length - 9.6,6.6]) {
            rotate([0,45,-10]) {
                cube([1.6,20,1.6]);
            }
        }
    }
    
    difference() {
        translate([enclosure_width - 24,4.1,0]) {
            difference() {
                featherScrew();
                translate([-3.1,-2.5,5]) {
                    thingPlusBoard();
                }

            }
        }
        // Battery
        translate([3,24,1]) {
            cube([29,36,6]);
        }
        // Front face
        translate([20,-1.1,-1]) {
            cube([41,wall_thickness+1,enclosure_height + 2]);
        }
    }
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

// Draw exterior walls for the enclosure
module enclosureWalls() {
    translate([7,enclosure_length - 30,1]) {
        rotate([0,0,14]) {
            cube([4,3,3.6]);
        }
    }
    translate([1.6,22,0])cube([7,1.6,10]);
    translate([0,61,0])cube([12,1.6,10]);
    translate([enclosure_width - 28.7,24,0])cube([1.6,36,10]);
    // Cylinder with a smaller cylinder cut out of it
    difference() {
        rcube([enclosure_width,enclosure_length,enclosure_height], 6);

        // Make the cylinder hollow
        translate([wall_thickness,wall_thickness,wall_thickness]) {
            rcube([enclosure_width - wall_thickness * 2, enclosure_length - wall_thickness * 2,enclosure_height], 5);
          inner_height = enclosure_height;
          inner_radius = enclosure_radius - (wall_thickness * 2);
        }
        // Radial vents
        translate([enclosure_width / 2,enclosure_length / 1.5,enclosure_height - 14]) {
          radialVents(2, 7, 2, 3, enclosure_length + 20);
        }
        // Through hole for screw
        translate([enclosure_width - 24,4.1,-2]) {
            cylinder(r=1.2, h=16);
        }
        // Through hole for screw
        translate([enclosure_width - 6.22,4.1,-2]) {
            cylinder(r=1.2, h=16);
        }
    }
}

// Radial vents
// ventSpacing in mm
// horizontalSpacing in degrees (divisible by 360)
module radialVents(verticalSpacing, horizontalSpacing, size, numRows, ventRadius) {
    for ( m = [0 : numRows] ){
        //for ( k = [102 : 130] ){
        for ( k = [94 : 101] ){
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

// Thing Plus with usb
module thingPlusBoard() {
    difference() {
        rcube([23.8,59,1.19], 2.5);
        translate([2.54,2.54,-2])cylinder(r=1.35, h=14);
        translate([21.26,2.54,-2])cylinder(r=1.35, h=14);
    }
    translate([7.9,-1.6,1]) {
        cube([8, 5, 2.7]);
    }
    translate([1.4,30,1]) {
        cube([20.5, 20, 4]);
    }
    translate([1.4,48,1]) {
        cube([20.5, 11, 2]);
    }
    translate([15.33,17.42,-2])cylinder(r=1.5, h=2);
    translate([6.7,17.42,-2])cylinder(r=1.5, h=2);
}

// Screw mount spaced for a feather board
module featherScrew() {
    translate([0,0,0])screwmountM25();
    translate([-2.7,53.4,0])frictionmount(1.1, 6.1);
    translate([19,55.5,0])frictionmount(1.1, 6.1);
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
    difference() {
        cylinder(r=5, h=2);
        translate([0,0,-2]) {
            cylinder(r=1.2, h=8);
        }
    }
 
    difference() {
        cylinder(r=2.5, h=5);
        translate([0,0,-2]) {
            cylinder(r=1.35, h=8);
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

module lensRound(lensHeight = 0) {
    difference() {
        translate([21,21,0]) cylinder(r=44/2,h=2 + lensHeight);
        translate([21,21,1]) cylinder(r=38/2,h=14);
        translate([21, 21, 0])roundCamera();
    }
    difference() {
        translate([21,21,0]) cylinder(r=40/2,h=6 + lensHeight);
        translate([21,21,1]) cylinder(r=38/2,h=15);
        #translate([21, 21, 0])roundCamera();
        translate([10,36,3.5 + lensHeight])rotate([0,0,0])cube([20,5,3]);
    }
    translate([22.5,-1,4.2 + lensHeight])rotate([0,0,6])cube([2.7,3.5,1.8]);
    translate([22.5,-1,4.2 + lensHeight])rotate([0,0,16])cube([2.7,3,1.8]);
    translate([8.5,35.3,4 + lensHeight])rotate([0,0,133])cube([2,3,2]);
    translate([10.8,10.8,0])screwmountA(lensHeight);
    translate([10.8,31.2,0])screwmountC(lensHeight);
    translate([31.2,31.2,0])screwmountA(lensHeight);
    translate([31.2,10.8,0])screwmountC(lensHeight);
}


module roundCamera() {
    translate([0,0, -1])cylinder(r=9.4/2,h=12);
    translate([0,0, -2])cylinder(r1=16/2, r2=9.4/2,h=3);
}

module screwmountA(lift = 6) {        
    cylinder(r=4, h=lift + 2);
    difference() {
        cylinder(r=3, h= lift + 6);
        cylinder(r=1.35, h= lift + 8); 
    }
}

module screwmountC(lift = 6) {        
    cylinder(r=4, h=lift + 2);
    cylinder(r=3, h=lift + 6);
    cylinder(r=1.45, h=lift + 8); 
}