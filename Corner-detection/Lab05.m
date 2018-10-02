close all;
clear all;

RGB = imread('carmanBox.jpg', 'jpg');
%imshow(RGB, [0, 255]);

% compute Iy
IyValues=zeros(size(RGB, 1),size(RGB, 2));
for r = 1 : size(RGB, 1)
    for c = 1:size(RGB, 2)-1
        IyValues(r, c)= RGB(r, c+1) - RGB(r, c);
    end
end
IyValues;
% pad zeros at the first row
for i = 1:size(RGB, 2)
    IyValues(1, i)= 0;
end

%Compute Ix
IxValues=zeros(size(RGB, 1),size(RGB, 2));
for r = 1 : size(RGB, 1)-1
    for c = 1:size(RGB, 2)
        IxValues(r, c)= RGB(r+1, c) - RGB(r, c);
    end
end
% pad zeros at the first colnum
for i = 1:size(RGB, 1)
    IxValues(i, 1)= 0;
end
IxValues;

% size(RGB, 1) = 512
% size(RGB, 2) = 512

% resize the matrix to 520 (13x40, 13x40)
Ix = zeros(520, 520);
Iy = zeros(520, 520);
for r = 1 : size(RGB, 1)
    for c = 1 : size(RGB, 2)
        Ix(r, c) = IxValues(r, c);
        Iy(r, c) = IyValues(r, c);
    end
end

% compute 2 by 2 matrix for each 13 by 13 sub-matrix
test=zeros(2, 2);
egi_min = zeros(520, 520); % min egien value for each block is located at egi_min(r, c), (r,c) is the first pixel location of the block
egis = zeros(1, 1600); % array to store all the egi values
egiIndex = 1; % index in array egis 
IxSquare = 0;
IySquare = 0;
IxIy = 0;
for c = 1 : 13 : 520 - 12 % incremental size = 13
    c_13 = c + 12;
    
     for r = 1 : 13 : 520 - 12 
         r_13 = r + 12;
         
         % summmation in x direction 
         for i = r : r_13
             IxSquare = IxSquare + Ix(i, c)^2;
             IySquare = IySquare + Iy(i, c)^2;
             IxIy = IxIy + Ix(i, c)*Iy(i, c);
         end
         
         % summmation in y direction 
        for k = c : c_13
            IxSquare = IxSquare + Ix(r, k)^2;
            IySquare = IySquare + Iy(r, k)^2;
            IxIy = IxIy + Ix(r, k)*Iy(r, k);
        end
        
        % form 2 by 2 matrix
        test(1, 1) = IxSquare;
        test(1, 2) = IxIy;
        test(2, 1) = IySquare;
        test(2, 2) = IxIy;
      
        % compute egien-value and find the smallest eigen value
        s = min(eig(test));
        egis(1, egiIndex) = s;  
        egi_min(r_13, c_13) = s; % (r, c) is the LAST pixel of every block 
        egiIndex = egiIndex + 1;
     end
 end

egi_min;
egisDes = sortrows(egis, -2);
cutoff = egisDes(1, 200)
%sum(egi_min(13,:)~=0)

% find the last value for the top 200 values 


