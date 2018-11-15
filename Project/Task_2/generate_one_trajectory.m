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

%camera data
% camera 1 data
%c_1 = [526.492588/2-1920/2; 301.481624-1080/2; 1];
% camera 2 data
%c_2 = [558.150011-1920/2; 288.28514-1080/2; 1];
% camera 3 data
%c_3 = [1375.548521-1920/2; 252.074613-1080/2; 1];

% read data from csv file
% undistort_x: a n by 1 matrix
cam1_undistort_xy = csvread("CAM1-GOPR0334-36441.csv",20,3);
cam2_undistort_xy = csvread("CAM2-GOPR0289-36404.csv",20,3);
cam3_undistort_xy = csvread("CAM3-GOPR0343-36320.csv",20,3);

% matrix to store 3D point ball location
threeD_points = zeros(256, 3);

for row = 1 : 50
    % camera 1 point
    c1_u = cam1_undistort_xy(row, 1)-1920/2;
    c1_v = cam1_undistort_xy(row, 2)-1080/2;
    % camera 2 point
    c2_u = cam2_undistort_xy(row, 1)-1920/2;
    c2_v = cam2_undistort_xy(row, 2)-1080/2;
    % camera 3 point
    c3_u = cam3_undistort_xy(row, 1)-1920/2;
    c3_v = cam3_undistort_xy(row, 2)-1080/2;

        
    % check point == 0 
    if c1_u(1,1) == 0 || c2_u(1,1) == 0 
         display(row)
         break;
     end
    
    % generate matrix to be solved with svd
    % For camera 1
    X_1  = mappingX(caliberation_1, R_1, c1_u, T_1);
    Y_1  = mappingY(caliberation_1, R_1, c1_v, T_1);

    % For camera 2
    X_2  = mappingX(caliberation_2, R_2, c2_u, T_2);
    Y_2  = mappingY(caliberation_2, R_2, c2_v, T_2);
    
    % For camera 3
    X_3  = mappingX(caliberation_3, R_3, c3_u, T_3);
    Y_3  = mappingY(caliberation_3, R_3, c3_v, T_3);
    
    % svd 
    N = zeros(6,4);
    N(1, :) = X_1;
    N(2, :) = Y_1;
    N(3, :) = X_2;
    N(4, :) = Y_2;
    N(5, :) = X_3;
    N(6, :) = Y_3;

    [U, S, V] = svd(N);
    
    threeD_point = [V(1,4)/V(4,4), V(2,4)/V(4,4), V(3,4)/V(4,4)];
    threeD_points(row, :) = threeD_point;
    
end
csvwrite('myData.txt', threeD_points)

function row = mappingX(caliberation, orientation, twoDpoint_u, position)
    uc = twoDpoint_u;
    f=caliberation(1,1);
    u0=caliberation(1,3)-1920/2;
    ix=orientation(1,1);
    iy=orientation(1,2);
    iz=orientation(1,3);
    kx=orientation(3,1);
    ky=orientation(3,2);
    kz=orientation(3,3);
    tx=position(1,1);
    ty=position(2,1);
    tz=position(3,1);
    
    row = [f*ix+kx*u0-uc*kx f*iy+ky*u0-uc*ky f*iz+kz*u0-uc*kz -tx*(f*ix+kx*u0-uc*kx)-ty*(f*iy+ky*u0-uc*ky)-tz*(f*iz+kz*u0-uc*kz) ]
    
end 

function row = mappingY(caliberation, orientation, twoDpoint_v, position)
    vc = twoDpoint_v;
    f=caliberation(2,2);
    v0=caliberation(2,3)-1080/2;
    jx=orientation(2,1);
    jy=orientation(2,2);
    jz=orientation(2,3);
    kx=orientation(3,1);
    ky=orientation(3,2);
    kz=orientation(3,3);
    tx=position(1,1);
    ty=position(2,1);
    tz=position(3,1);
    
    row = [f*jx+kx*v0-vc*kx f*jy+ky*v0-vc*ky f*jz+kz*v0-vc*kz -tx*(f*jx+kx*v0-vc*kx)-ty*(f*jy+ky*v0-vc*ky)-tz*(f*jz+kz*v0-vc*kz) ]
    
end 

% helper function to check generated 3d point
function c = checkpoint(caliberation, orientation, position, check)
    % diff 3*1 matrix
    diff = check-position;
    
    u_upper = diff.'*orientation(1,:).';
    u_lower = diff.'*orientation(3,:).';
    u = caliberation(1,1)*(u_upper/u_lower)+caliberation(1,3);
    
    v_upper = diff.'*orientation(2,:).';
    v_lower = diff.'*orientation(3,:).';
    v = caliberation(2,2)*(v_upper/v_lower)+caliberation(2,3);
    
    c = zeros(2,1);
    c(1, :) = u;
    c(2, :) = v;    
end

