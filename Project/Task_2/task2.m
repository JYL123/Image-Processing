close all; 
clear all;

% assumption 
world_cooridnate = [
    1 0 0; 
    0 1 0;
    0 0 1;
];

%scene_point = [ x; y; z; 1]

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
T_1 = -inv(R1)*T1
T_2 = -inv(R2)*T2;
T_3 = -inv(R3)*T3;
% cam_ori:
R_1 = R1;
R_2 = R2;
R_3 = R3;

% test point from frame 3
% 1920 1080, convert picture point to camera image point
% c1: 749.430935, 248.147808
% c2: 698.955519, 254.998536
% c_1 = [544.195114-1080/2; 297.948346-1920/2; 1];
% c_2 = [567.523424-1080/2; 287.74321-1920/2; 1];
c_1 = [749.430935-1920/2; 248.147808-1080/2; 1];
c_2 = [698.955519-1920/2; 254.998536-1080/2; 1];


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

% caliberation =  intrinsic parameter
% orientation matrix = rotatio matrix
% position matrix = translation matrix

% For camera 1
U_11  = computePerspectiveUTest1(caliberation_1, R_1, c_1, T_1);
V_11  = computePerspectiveVTest1(caliberation_1, R_1, c_1, T_1);

% For camera 2
U_21  = computePerspectiveUTest1(caliberation_2, R_2, c_2, T_2);
V_21  = computePerspectiveVTest1(caliberation_2, R_2, c_2, T_2);

% svd 
 N = zeros(4,4);
 N(1, :) = U_11;
 N(2, :) = V_11;
 N(3, :) = U_21;
 N(4, :) = V_21;
% 
 [U1, S1, V1] = svd(N)
% 
% 
% figure
% plot3(R_1(1, :), R_1(2, :), R_1(3, :))
check = [0.2838;
         -1.1227;
         -0.1112;]
     
%checkpoint(caliberation_3, R_3, T_3, check)


function U = computePerspectiveUTest1(caliberation, orientation, twoDpoint, position)
    a = [caliberation(1,1) caliberation(1,3) -1*twoDpoint(1,1)];
    b_1 = [orientation(1,1); orientation(3,1); orientation(3,1);];
    b_2 = [orientation(1,2); orientation(3,2); orientation(3,2);];
    b_3 = [orientation(1,3); orientation(3,3); orientation(3,3);];
    b = zeros(3,3);
    b(:,1) = b_1;
    b(:,2) = b_2;
    b(:,3) = b_3;
    c_11 = [position(1,1); position(3,1); position(3,1);];
    U = [a*b_1 a*b_2 a*b_3 a*c_11];
    
    %method 2:
%     Extrinsic = [  
%             orientation(1,1) orientation(1,2) orientation(1,3) position(1,1);
%             orientation(2,1) orientation(2,2) orientation(2,3) position(2,1);
%             orientation(3,1) orientation(3,2) orientation(3,3) position(3,1);
%             0 0 0 1;
%         ];
%     X = caliberation*Extrinsic; % resulting 3 by 4 matrix 
%     U = [twoDpoint(1,1)*X(3,1)-X(1,1) twoDpoint(1,1)*X(3,2)-X(1,2) twoDpoint(1,1)*X(3,3)-X(1,3) twoDpoint(1,1)*X(3,4)-X(1,4)]
    
    

end

function V = computePerspectiveVTest1(caliberation, orientation, twoDpoint, position)
    a = [caliberation(2,2) caliberation(2,3) -1*twoDpoint(2,1)];
    b_1 = [orientation(2,1); orientation(3,1); orientation(3,1);];
    b_2 = [orientation(2,2); orientation(3,2); orientation(3,2);];
    b_3 = [orientation(2,3); orientation(3,3); orientation(3,3);];
    b = zeros(3,3);
    b(:,1) = b_1;
    b(:,2) = b_2;
    b(:,3) = b_3;
    c_22 = [position(2,1); position(3,1); position(3,1);];
    V = [a*b_1 a*b_2 a*b_3 a*c_22];
    
    %method 2:
     Extrinsic = [  
             orientation(1,1) orientation(1,2) orientation(1,3) position(1,1);
             orientation(2,1) orientation(2,2) orientation(2,3) position(2,1);
             orientation(3,1) orientation(3,2) orientation(3,3) position(3,1);
             0 0 0 1;  
         ];

%     X = caliberation*Extrinsic; % resulting 3 by 4 matrix 
%     V = [twoDpoint(2,1)*X(2,1)-X(1,1) twoDpoint(2,1)*X(3,2)-X(2,2) twoDpoint(2,1)*X(3,3)-X(2,3) twoDpoint(2,1)*X(3,4)-X(2,4)]

end

function U = computePerspectiveU(caliberation, orientation, twoDpoint, position)
    a = [caliberation(1,1) caliberation(1,3) -1*twoDpoint(1,1)];
    b_1 = [orientation(1,1); orientation(3,1); orientation(3,1);];
    b_2 = [orientation(1,2); orientation(3,2); orientation(3,2);];
    b_3 = [orientation(1,3); orientation(3,3); orientation(3,3);];
    b = zeros(1,3);
    b(1,1) = a*b_1;
    b(1,2) = a*b_2;
    b(1,3) = a*b_3;
    c = position;
    
    U = [b(:,1) b(:,2) b(:,3) -1*b*c];

end

function V = computePerspectiveV(caliberation, orientation, twoDpoint, position)
    a = [caliberation(2,2) caliberation(2,3) -1*twoDpoint(2,1)];
    b_1 = [orientation(2,1); orientation(3,1); orientation(3,1);];
    b_2 = [orientation(2,2); orientation(3,2); orientation(3,2);];
    b_3 = [orientation(2,3); orientation(3,3); orientation(3,3);];
    b = zeros(1,3)
    b(1,1) = a*b_1;
    b(1,2) = a*b_2;
    b(1,3) = a*b_3;
    c = position;
    
    V = [b(:,1) b(:,2) b(:,3) -1*b*c];

end

function checkpoint(caliberation, orientation, twoDpoint, position, check)
    % diff 3*1 matrix
    diff = check-position;
   
    u_upper = caliberation(1,3)*diff*orientation(1,:);
    u_lower = diff*orientation(3,:);
    
   
    

u = caliberation(1, 3)*orientation(1,:)

end



