close all; 
clear all;

% assumption 
world_cooridnate = [
    1 0 0; 
    0 1 0;
    0 0 1;
];

%scene_point = [ x; y; z;]

% camera 1 
R1 = [
    0.96428667991264605 -0.26484969138677328 -0.0024165916859785336;
    -0.089795446022112396 -0.3183282771611223 -0.94371961862719200;
    0.24917459103354755  0.91023325674273947 -0.33073772313234923;
    ];
  
T1 = [
    0.13305621037591506;
    -0.25319578738559911;
    2.2444637695699150;
    ];

cam_pos_1 = R1* world_cooridnate + T1;

caliberation_1 = [
    870.14531487461625 0 949.42001822880479 0;
    0 870.14531487461625 487.20049852775117 0;
    0 0 1 0
    ];

% camera 2
R2 = [
    0.94962278945631540 0.31338395965783683 -0.0026554800661627576;
    0.11546856489995427 -0.35774736713426591 -0.92665194751235791;
    -0.29134784753821596 0.87966318277945221 -0.37591104878304971;
    ];

T2 = [
    -0.042633372670025989;
    -0.35441906393933242;
    2.2750378317324982;
    ];

cam_pos_2 = R2* world_cooridnate + T2;

caliberation_2 = [
    893.34367240024267 0 949.96816131377727 0;
    0 893.34367240024267 546.79562177577259 0;
    0 0 1 0;
    ];

% camera 3
R3 = [
    -0.99541881789113029 0.038473906154401757 -0.087527912881817604;
    0.091201836523849486 0.65687400820094410 -0.74846426926387233;
    0.02869846690856149 -0.75301812454631367 -0.65737363964632056;
    ];

T3 = [
    -0.060451734755080713;
    -0.39533167111966377;
    2.2979640654841407; 
    ];

cam_pos_3 = R3* world_cooridnate + T3;

caliberation_3 = [
    872.90852997159800 0 944.45161471037636 0;
    0 872.90852997159800 564.47334036925656 0; 
    0 0 1 0;   
    ];

% correct data
% cam_pos:
T_1 = -inv(R1)*T1;
T_2 = -inv(R2)*T2;
T_3 = -inv(R3)*T3;
% cam_ori:
R_1 = R1;
R_2 = R2;
R_3 = R3;

% test point from frame 3
% 1920 1080, convert picture point to camera image point
c_1 = [544.195114-1920/2; 297.948346-1080/2; 1];
c_2 = [567.523424-1920/2; 287.74321-1080/2; 1];


% For camera 1
U_1  = computePerspectiveU(caliberation_1, R_1, c_1, T_1);
V_1  = computePerspectiveV(caliberation_1, R_1, c_1, T_1);

% For camera 2
U_2  = computePerspectiveU(caliberation_2, R_2, c_2, T_2);
V_2  = computePerspectiveV(caliberation_2, R_2, c_2, T_2);

% svd 
M = zeros(4,4);
M(1, :) = U_1;
M(2, :) = V_1;
M(3, :) = U_2;
M(4, :) = V_2;

[U, S, V] = svd(M)


function U = computePerspectiveU(caliberation, orientation, twoDpoint, position)
    a = [caliberation(1,1) caliberation(1,3) -1*twoDpoint(1,1)];
    b_1 = [orientation(1,1); orientation(3,1); orientation(3,1);];
    b_2 = [orientation(1,2); orientation(3,2); orientation(3,2);];
    b_3 = [orientation(1,3); orientation(3,3); orientation(3,3);];
    b = zeros(3,3)
    b(:,1) = b_1;
    b(:,2) = b_2;
    b(:,3) = b_3;
    c = position;
    
    U = [a*b_1 a*b_2 a*b_3 -1*a*b*c]

end

function V = computePerspectiveV(caliberation, orientation, twoDpoint, position)
    a = [caliberation(2,2) caliberation(2,3) -1*twoDpoint(2,1)];
    b_1 = [orientation(2,1); orientation(3,1); orientation(3,1);];
    b_2 = [orientation(2,2); orientation(3,2); orientation(3,2);];
    b_3 = [orientation(2,3); orientation(3,3); orientation(3,3);];
    b = zeros(3,3)
    b(:,1) = b_1;
    b(:,2) = b_2;
    b(:,3) = b_3;
    c = position;
    
    V = [a*b_1 a*b_2 a*b_3 -1*a*b*c]

end



