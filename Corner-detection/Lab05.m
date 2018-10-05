close all;
clear all;

FNames = {'checker.jpg'; 'letterBox.jpg'; 'pipe.jpg'; 'carmanBox.jpg';};

for p = 1 : size(FNames)
    figH = figure;
    baseName = FNames{p}(1:find(FNames{p}=='.')-1); 
    old_figName = strcat(baseName, '.jpg');
        
    RGB = imread(old_figName, 'jpg');
    cornerDetect(RGB);
    
    figName = strcat(baseName, '_corner_detection.jpg');
    print(figH, '-djpeg', figName); 
end


function cornerDetect(RGB)

RGB = double(rgb2gray(RGB));

% compute Iy
IyValues=zeros(size(RGB, 1),size(RGB, 2));
for r = 1 : size(RGB, 1)
    for c = 1:size(RGB, 2)-1
        IyValues(r, c)= RGB(r, c+1) - RGB(r, c);
    end
end
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

for c = 1 : 7 : 520 - 12 % incremental size = 7
    c_13 = c + 12;
    
     for r = 1 : 7 : 520 - 12 
         r_13 = r + 12;
         
        IxSquare = 0;
        IySquare = 0;
        IxIy = 0;
        
        for k = c : c_13         
            for i = r : r_13
             IxSquare = IxSquare + Ix(i, k)^2;
             IySquare = IySquare + Iy(i, k)^2;
             IxIy = IxIy + Ix(i, k)*Iy(i, k);
            end
        end
        
        % form 2 by 2 matrix
        test(1, 1) = IxSquare;
        test(1, 2) = IxIy;
        test(2, 1) = IxIy;
        test(2, 2) = IySquare;
      
        % compute egien-value and store the smallest eigen value
        s = min(eig(test));
        egis(1, egiIndex) = s;  
        egi_min(r_13, c_13) = s; % (r, c) is the LAST pixel of every block 
        egiIndex = egiIndex + 1;
     end
 end

egisDes = sort(egis, 'descend'); %descending order
cutoff = egisDes(1, 200) %last value

% plot the 200 rectangles
imshow(uint8(RGB))
cat(3,RGB, RGB, RGB);
num = 0;
for r = 14 : size(egi_min, 1)-8 %-8 because the resized image is 8 pixels/dimension greater than the original image  
    for c = 14 : size(egi_min, 2)-8
        if egi_min(r, c) >= cutoff
           rectangle('Position',[c-13 r-13 13 13], 'EdgeColor', 'r')
           num = num +1 ;
        end  
    end
end

end
