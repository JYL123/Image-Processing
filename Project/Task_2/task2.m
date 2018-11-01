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
    870.14531487461625 0 949.42001822880479;
    0 870.14531487461625 487.20049852775117;
    0 0 1
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
    893.34367240024267 0 949.96816131377727;
    0 893.34367240024267 546.79562177577259;
    0 0 1;
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
    872.90852997159800 0 944.45161471037636;
    0 872.90852997159800 564.47334036925656; 
    0 0 1;   
    ];


% test point from frame 3
c_1 = [544.195114; 297.948346; 1];
c_2 = [567.523424; 287.74321; 1];

H1 = threeDToTwoD(caliberation_1, cam_pos_1);
H2 = threeDToTwoD(caliberation_2, cam_pos_2);

M = constructMatrix(H1, c_1, H2, c_2);

% svd
[U, S, V] = svd(M)
% x, y, z of the scene point
scene_point_1 = [V(1,3); V(2,3); V(3,3)]

% verfication 
H3 = threeDToTwoD(caliberation_3, cam_pos_3);
ans = H3*scene_point_1;
ans = ans/ans(3,1); % is it because of the scaling factor?

% method 2: use perspective projection directly
M = zeros(2, 6);
% compute camera 1 position 
P_1 = computeCameraPosition(R1, T1, world_cooridnate);
M(1, : ) = computePerspective(c_1(1,1), P_1.', R1(1,:), R1(3,:));

% compute camera 2 position 
P_2 = computeCameraPosition(R2, T2, world_cooridnate);
M(2, : ) = computePerspective(c_2(1,1), P_2.', R2(1,:), R2(3,:));

% svd
[U, S, V] = svd(M);


TestM = [
    
    caliberation_1(1,1)-c_1(1,1)*caliberation_1(3,1) caliberation_1(1,2)-c_1(1,1)*caliberation_1(3,2) caliberation_1(1,3)-c_1(1,1)*caliberation_1(3,3);
    caliberation_1(2,1)-c_1(2,1)*caliberation_1(3,1) caliberation_1(2,2)-c_1(2,1)*caliberation_1(3,2) caliberation_1(2,3)-c_1(2,1)*caliberation_1(3,3);
    caliberation_2(1,1)-c_2(1,1)*caliberation_2(3,1) caliberation_2(1,2)-c_2(1,1)*caliberation_2(3,2) caliberation_2(1,3)-c_2(1,1)*caliberation_2(3,3);
    caliberation_2(2,1)-c_2(2,1)*caliberation_2(3,1) caliberation_2(2,2)-c_2(2,1)*caliberation_2(3,2) caliberation_2(2,3)-c_2(2,1)*caliberation_2(3,3);

    ]

% svd
[U, S, V] = svd(TestM)
scene_point_test = [V(1,3); V(2,3); V(3,3)]

frame_point = caliberation_3*scene_point_test;
frame_point = frame_point/frame_point(3,1)

% x and z are 1*3  :1*3
function M = computePerspective(U, P, x, z) 
    M = [ U*z(1,1)-x(1,1) U*z(1,2)-x(1,2) U*z(1,3)-x(1,3) -(U*z(1,1)+x(1,1))*P(1,1) -(U*z(1,2)+x(1,2))*P(1,2) -(U*z(1,3)+x(1,3))*P(1,3)];
end 

% P: 3 by 1
function P = computeCameraPosition(R, T, origin)
    P = [R(1,1) R(1,2) R(1,3) T(1,1);
         R(2,1) R(2,2) R(2,3) T(2,1);
         R(3,1) R(3,2) R(3,3) T(3,1);
    ]*[origin(1,1); origin(2,1); origin(3,1); 1];
end


% a scaling matrix that may make use of rsolution is needed!
% i equate camera_caliberation as the intrinsic parameter matrix (which may be wrong)
function H = threeDToTwoD (camera_caliberation, rotation_transformation)
    H = camera_caliberation*rotation_transformation;
end

% H is a 3 by 3 matrix , camera_point is 2 by 1
function M = constructMatrix(H1, camera_point1, H2, camera_point2)
    M = [
        H1(1,1) H1(1,2) H1(1,3) - camera_point1(1,1);
        H1(2,1) H1(2,2) H1(2,3) - camera_point1(2,1);
        H1(3,1) H1(3,2) H1(3,3) - 1;
        H2(1,1) H2(1,2) H2(1,3) - camera_point2(1,1);
        H2(2,1) H2(2,2) H2(2,3) - camera_point2(2,1);
        H2(3,1) H2(3,2) H2(3,3) - 1;
    ];
end 





