close all; 
clear all;

% assumption 
world_cooridnate = [
    1 0 0; 
    0 1 0;
    0 0 1;
];

%scene_point = [ x; y; z; 1]

% T,R to be corrected line 73
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


caliberation_3 = [
    872.90852997159800 0 944.45161471037636 0;
    0 872.90852997159800 564.47334036925656 0; 
    0 0 1 0;   
    ];

% correct data
% cam_pos:
T_1 = -inv(R1)*T1
T_2 = -inv(R2)*T2;
T_3 = -inv(R3)*T3;
% cam_ori:
R_1 = R1;
R_2 = R2;
R_3 = R3;

% test point from frame 10
% 1920 1080, convert picture point to camera image point
% camera 1 data
c_1 = [749.430935-1920/2; 248.147808-1080/2; 1];
c_11 = [732.621677-1920/2; 255.100929-1080/2; 1];
c_12 = [713.485208-1920/2; 259.792953-1080/2; 1];
c_13 = [709.707415/2-1920/2; 274.646952-1080/2; 1];
c_14 = [669.426554/2-1920/2; 273.152385-1080/2; 1];

% camera 2 data
c_2 = [698.955519-1920/2; 254.998536-1080/2; 1];
c_21 = [687.08528-1920/2; 258.854223-1080/2; 1];
c_22 = [672.884517-1920/2; 261.464359-1080/2; 1];
c_23 = [647.68956-1920/2; 269.011233-1080/2; 1];
c_24 = [636.423067-1920/2; 268.393115-1080/2; 1];

% camera 3 data
c_3 = [1235.686836-1920/2; 246.513591-1080/2];
c_31 = [1206.700476-1920/2; 251.386177-1080/2];
c_32 = [1194.403231-1920/2; 234.134829-1080/2];
c_33 = [1172.533138-1920/2; 236.305715-1080/2];
c_34 = [1157.526919-1920/2; 233.625535-1080/2];

% For camera 1
U_1  = computePerspectiveWithU(caliberation_1, R_1, c_1, T_1);
V_1  = computePerspectiveWithV(caliberation_1, R_1, c_1, T_1);
U_1one  = computePerspectiveWithU(caliberation_1, R_1, c_11, T_1);
V_1one  = computePerspectiveWithV(caliberation_1, R_1, c_11, T_1);
U_1two  = computePerspectiveWithU(caliberation_1, R_1, c_12, T_1);
V_1two  = computePerspectiveWithV(caliberation_1, R_1, c_12, T_1);
U_1three  = computePerspectiveWithU(caliberation_1, R_1, c_13, T_1);
V_1three  = computePerspectiveWithV(caliberation_1, R_1, c_13, T_1);
U_1four  = computePerspectiveWithU(caliberation_1, R_1, c_14, T_1);
V_1four  = computePerspectiveWithV(caliberation_1, R_1, c_14, T_1);


% For camera 2
U_2  = computePerspectiveWithU(caliberation_2, R_2, c_2, T_2);
V_2  = computePerspectiveWithV(caliberation_2, R_2, c_2, T_2);
U_2one  = computePerspectiveWithU(caliberation_2, R_2, c_21, T_2);
V_2one  = computePerspectiveWithV(caliberation_2, R_2, c_21, T_2);
U_2two  = computePerspectiveWithU(caliberation_2, R_2, c_22, T_2);
V_2two  = computePerspectiveWithV(caliberation_2, R_2, c_22, T_2);
U_2three  = computePerspectiveWithU(caliberation_2, R_2, c_23, T_2);
V_2three  = computePerspectiveWithV(caliberation_2, R_2, c_23, T_2);
U_2four  = computePerspectiveWithU(caliberation_2, R_2, c_24, T_2);
V_2four  = computePerspectiveWithV(caliberation_2, R_2, c_24, T_2);

% For camera 3
U_3  = computePerspectiveWithU(caliberation_3, R_3, c_3, T_3);
V_3  = computePerspectiveWithV(caliberation_3, R_3, c_3, T_3);
U_3one  = computePerspectiveWithU(caliberation_3, R_3, c_31, T_3);
V_3one  = computePerspectiveWithV(caliberation_3, R_3, c_31, T_3);
U_3two  = computePerspectiveWithU(caliberation_3, R_3, c_32, T_3);
V_3two  = computePerspectiveWithV(caliberation_3, R_3, c_32, T_3);
U_3three  = computePerspectiveWithU(caliberation_3, R_3, c_33, T_3);
V_3three  = computePerspectiveWithV(caliberation_3, R_3, c_33, T_3);
U_3four  = computePerspectiveWithU(caliberation_3, R_3, c_34, T_3);
V_3four  = computePerspectiveWithV(caliberation_3, R_3, c_34, T_3);

% svd 
M = zeros(30,4);
M(1, :) = U_1;
M(2, :) = V_1;
M(3, :) = U_1one;
M(4, :) = V_1one;
M(5, :) = U_1two;
M(6, :) = V_1two;
M(7, :) = U_1three;
M(8, :) = V_1three;
M(9, :) = U_1four;
M(10, :) = V_1four;

M(11, :) = U_2;
M(12, :) = V_2;
M(13, :) = U_2one;
M(14, :) = V_2one;
M(15, :) = U_2two;
M(16, :) = V_2two;
M(17, :) = U_2three;
M(18, :) = V_2three;
M(19, :) = U_2four;
M(20, :) = V_2four;

M(21, :) = U_3;
M(22, :) = V_3;
M(23, :) = U_3one;
M(24, :) = V_3one;
M(25, :) = U_3two;
M(26, :) = V_3two;
M(27, :) = U_3three;
M(28, :) = V_3three;
M(29, :) = U_3four;
M(30, :) = V_3four;

[U, S, V] = svd(M)

%plot3(R_1(:,1)+T_1(1,1), R_1(:,2)+T_1(2,1), R_1(:,3)+T_1(3,1))
% get [X, Y, Z] from V 
check = [ V(1,4)/V(4,4);  V(2,4)/V(4,4);  V(3,4)/V(4,4);] 
%check = [0.3464;  1.0185;  -0.2457;] 
checking_result = checkpoint(caliberation_2, R_2, T_2, check)


% derived from perspectve equation directly
function Row = computePerspectiveWithU(caliberation, orientation, twoDpoint, position)
    a = [caliberation(1,1) caliberation(1,3) -1*twoDpoint(1,1)]
    b_1 = [orientation(1,1); orientation(3,1); orientation(3,1);];
    b_2 = [orientation(1,2); orientation(3,2); orientation(3,2);];
    b_3 = [orientation(1,3); orientation(3,3); orientation(3,3);];
    b = zeros(1,3);
    b(1,1) = a*b_1;
    b(1,2) = a*b_2;
    b(1,3) = a*b_3;
    c = -1*b*position;
    
    Row = [b(1,1) b(1,2) b(1,3) c];

end

% derived from perspectve equation directly
function Row = computePerspectiveWithV(caliberation, orientation, twoDpoint, position)
    a = [caliberation(2,2) caliberation(2,3) -1*twoDpoint(2,1)];
    b_1 = [orientation(2,1); orientation(3,1); orientation(3,1);];
    b_2 = [orientation(2,2); orientation(3,2); orientation(3,2);];
    b_3 = [orientation(2,3); orientation(3,3); orientation(3,3);];
    b = zeros(1,3)
    b(1,1) = a*b_1;
    b(1,2) = a*b_2;
    b(1,3) = a*b_3;
    c = -1*b*position;
    
    Row = [b(1,1) b(1,2) b(1,3) c];

end

function c = checkpoint(caliberation, orientation, position, check)
    % diff 3*1 matrix
    diff = check-position;
    
    u_upper = orientation(1,:)*diff;
    u_lower = orientation(3,:)*diff;
    u = caliberation(1,1)*(u_upper/u_lower)+caliberation(1,3);
    
    v_upper = orientation(2,:)*diff;
    v_lower = orientation(3,:)*diff;
    v = caliberation(2,2)*(v_upper/v_lower)+caliberation(2,3);
    
    c = zeros(2,1);
    c(1, :) = u;
    c(2, :) = v;    
end



