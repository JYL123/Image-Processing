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

% represent camera position in a world coordination
initialPosition = [0 0 -5]; % add Sp = 0
theta = pi/6; % rotation angle
n = [0; 1; 0]; % rotation axis
r = [0 initialPosition(1,1) initialPosition(1,2) initialPosition(1,3)];
cam_pos = zeros( 4, 3);
cam_pos(1, : ) = [ 0 0 -5];

%first rotation 
%R1= rotate(r, n, theta);
%cam_pos(2, : ) = [R1(2,1) R1(3,1) R1(4,1)];
R1 = rotateByEquation(r, n, theta);
cam_pos(2, : ) = R1.';

%second rotation
%R1 = R1.';
%R2= rotate(R1, n, theta);
%cam_pos(3, : ) = [R2(2,1) R2(3,1) R2(4,1)];
R1 = [0 R1(1,1) R1(2,1) R1(3,1)];
R2 = rotateByEquation(R1, n, theta);
cam_pos(3, : ) = R2.';

%third rotation
%R2 = R2.';
%R3= rotate(R2, n, theta);
%cam_pos(4, : ) = [R3(2,1) R3(3,1) R3(4,1)];
R2 = [0 R2(1,1) R2(2,1) R2(3,1)];
R3 = rotateByEquation(R2, n, theta);
cam_pos(4, : ) = R3.';
cam_pos

% use roll, pitch and yaw to represent rotation
% represent world coordination in a camera perspective?
% w = 0; phi = 30 degree (pi/6) (for the first rotation); k = 0;
w = 0;
phi = pi/6;
k = 0;
rpymat_1 = [1 0 0; 0 1 0; 0 0 1];
rpymat_2 = rpyRotation(rpymat_1, w, pi/6, k) % 30 degree
rpymat_3 = rpyRotation(rpymat_2, w, pi/3, k) % 60 degree
rpymat_4 = rpyRotation(rpymat_3, w, pi/2, k) % 90 degree

% rotation represented by quanternion
% rotational axis = [ 0; 1; 0] (3x1 row matrix)
% rotation degree = 30
% define q as colnum matrix
w = [0; 1; 0]; % rotational axis
quatmat_1 = [1 0 0; 0 1 0; 0 0 1];
quatmat_2 = quanRotation(pi/6, w)
quatmat_3 = quanRotation(pi/3, w)
quatmat_4 = quanRotation(pi/2, w)

%Projecting the 3D points
nframes = 4;
npts = size(pts,1);
U = zeros(nframes, npts); % 4*3
V = zeros(nframes, npts); % 4*3

%Compute u,v for each 3D point
for m = 1 : 8
    Sp = pts(m, : );
    for i = 1 : nframes
        Tf = cam_pos(i, : );
        U(i, : ) = computeU(Sp.', Tf.',quatmat_1(3,:).', quatmat_1(2,:).');
        V(i, : ) = computeV(Sp.', Tf.',quatmat_1(1,:).', quatmat_1(2,:).');
    end
  

    for fr = 1 : nframes  % for each frame
        subplot(2,2,fr), plot(U(fr,:), V(fr,:), '*'); 
            for p = 1 : npts % for each point
                text(U(fr,p)+0.02, V(fr,p)+0.02, num2str(p)); % what is +0.02?
            end
    end
end

% Compute U (horizontal)
% x, y, z are intrinsic parameters of the camera with y being kf (depth)
% matrix orientation is formatted as in the lecture notes
function U = computeU(Sp, Tf, x, y) 
    U = ((Sp-Tf).' * x)/((Sp-Tf).' * y) + 1;
end 

% Compute V (vertical)
% x, y, z are intrinsic parameters of the camera with y being kf (depth)
% matrix orientation is formatted as in the lecture notes
function V = computeV(Sp, Tf, z, y) 
    V = ((Sp-Tf).' * z)/((Sp-Tf).' * y) + 1;
end 



% quanternion rotation 
% 1x4 column matrix as quanternion, rotational degree as theta, rotational
% axis w
function Rt = quanRotation(theta, w)
q = [cos(theta/2) sin(theta/2)*w(1,1) sin(theta/2)*w(2,1) sin(theta/2)*w(3,1)];
    Rt = [
        q(1,1)^2+q(1,2)^2-q(1,3)^2-q(1,4)^2 2*(q(1,2)*q(1,3)-q(1,1)*q(1,4)) 2*(q(1,2)*q(1,4)+q(1,1)*q(1,3));
        2*(q(1,2)*q(1,3) + q(1,1)*q(1,4)) q(1,1)^2+q(1,3)^2-q(1,2)^2-q(1,4)^2 2*(q(1,3)*q(1,4)-q(1,1)*q(1,2));
        2*(q(1,2)*q(1,4)-q(1,1)*q(1,3)) 2*(q(1,3)*q(1,4)+q(1,1)*q(1,2)) q(1,1)^2+q(1,4)^2-q(1,2)^2-q(1,3)^2;
    ];
end

%rpy rotation with phi = pi/6
function Rt = rpyRotation(R0, w, phi, k)
    Rt = [
    cos(k)*cos(phi) cos(k)*sin(phi)-sin(k)*cos(w) cos(k)*sin(phi)*cos(w)+sin(k)*sin(w);     
    sin(k)*cos(phi) sin(k)*sin(phi)*sin(w)+cos(k)*cos(w) sin(k)*sin(phi)*cos(w)-cos(k)*sin(w);
    -sin(phi) cos(phi)*sin(w) cos(phi)*cos(w);
    ];
end 

% checking
% r (4x1): initial position; n: rotation axis; theta: rotation angle
function R = rotateByEquation(r, n, theta)
    v_p = [r(1,2) r(1,3) r(1,4)]; % 0,0,-5
    c = (v_p*cos(theta)).' + dot(v_p, n)*n*(1-cos(theta)) + (cross(n, v_p.'))*sin(theta);
    R = c;
 end 
 
function R = rotateByMatrix (r, n, theta)
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