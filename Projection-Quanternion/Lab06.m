close all; 
clear all;

pts = zeros(8, 3);
pts(1, : ) = [-1 -1 -1]; 
pts(2,: ) = [1 -1 -1];
pts(3,: ) = [1 -1 -1];
pts(4,: ) = [1 -1 -1];
pts(5,: ) = [1 -1 -1];
pts(6,: ) = [1 -1 -1];
pts(7,: ) = [1 -1 -1];
pts(8,: ) = [1 -1 -1];

initialPosition = [0 0 -5]; % add Sp = 0
theta = pi/6; % rotation angle
n = [0; 1; 0]; % rotation axis
r = [0 initialPosition(1,1) initialPosition(1,2) initialPosition(1,3)];
cam_pos = zeros( 4, 3);
cam_pos(1, : ) = [ 0 0 -5];

%first rotation 
%R1= rotate(r, n, theta);
%cam_pos(2, : ) = [R1(2,1) R1(3,1) R1(4,1)];

%second rotation
%R1 = R1.';
%R2= rotate(R1, n, theta);
%cam_pos(3, : ) = [R2(2,1) R2(3,1) R2(4,1)];

%third rotation
%R2 = R2.';
%R3= rotate(R2, n, theta);
%cam_pos(4, : ) = [R3(2,1) R3(3,1) R3(4,1)];

%cam_pos;


 % checking
 v_p = [r(1,2) r(1,3) r(1,4)] % 0,0,-5
 n
 cross(n, v_p.')
 c = (v_p*cos(theta)).' + dot(v_p, n)*n*(1-cos(theta)) + (cross(n, v_p.'))*sin(theta)    

function R = rotate (r, n, theta)
    q = [cos(theta/2) sin(theta/2)*r(1,2) sin(theta/2)*r(1,3) sin(theta/2)*r(1,4)];
    Q = [cos(theta/2) -sin(theta/2)*r(1,2) -sin(theta/2)*r(1,3) -sin(theta/2)*r(1,4)];
    p = [0 r(1,2) r(1,3) r(1, 4)];
    
    qp = [
        q(1,1)*p(1,1)-q(1,2)*p(1,2)-q(1,3)*p(1,3)-q(1,4)*p(1,4)
        
        q(1,1)*p(1,2)+q(1,2)*p(1,1)+q(1,3)*p(1,4)-q(1,4)*p(1,3)
        
        q(1,1)*p(1,3)-q(1,2)*p(1,4)+q(1,3)*p(1,1)+q(1,4)*p(1,2)
        
        q(1,1)*p(1,4)+q(1,2)*p(1,3)-q(1,3)*p(1,2)+q(1,4)*p(1,1)
    ];
    
    qp = qp.'; %transpose to row vector
    
    R = [
        qp(1,1)*Q(1,1)-qp(1,2)*Q(1,2)-qp(1,3)*Q(1,3)-qp(1,4)*Q(1,4)
        
        qp(1,1)*Q(1,2)+qp(1,2)*Q(1,1)+qp(1,3)*Q(1,4)-qp(1,4)*Q(1,3)
        
        qp(1,1)*Q(1,3)-qp(1,2)*Q(1,4)+qp(1,3)*Q(1,1)+qp(1,4)*Q(1,2)
        
        qp(1,1)*Q(1,4)+qp(1,2)*Q(1,3)-qp(1,3)*Q(1,2)+qp(1,4)*Q(1,1)
    ];
    
end