FNames = {'meteora_gray.jpg'; 'penang_hill_gray.jpg'; 'foggy_carpark_gray.jpg'};

% upperLeft = A_equalised(1:floor(size(A,2)/2), 1:size(A,2));
% subplot(3,2,2), imshow(upperLeft, [0,255]);
% title('hist equalized image');
for p = 1 : size(FNames)
     s = string(FNames(3:1));
     %cropImage(s)
     %histogramEqualization(string(FNames(p:1)));
end
% histogramEqualization('meteora_gray.jpg');
% histogramEqualization('penang_hill_gray.jpg');
% histogramEqualization('foggy_carpark_gray.jpg');
C = cropImage('meteora_gray.jpg');
imshow(C)
histogramEqualization(string(C));

function m = histogramEqualization(pic)
A = imread(pic, 'jpg');
%A = imread('meteora_gray.jpg', 'jpg');
%imshow(A, [0 255]);
subplot(3,2,1), imshow(A, [0 255]);
title('original image');

% round to integer
round(A);
% array of size 256
histArray=zeros(1,256);
% get the size of img 
row = size(A, 1);
col = size(A, 2);

% construct histogram  
for r = 1 : row
    for c = 1:col 
        intensity = A(r,c);
        histArray(1,intensity+1)=histArray(1,intensity+1)+1; 
    end
end
subplot(3,2,3), bar(histArray)
title('original histogram');
% checking: subplot(2,2,3), histogram(A)

% construct cdf
cdfArray=zeros(1,256);
cdfArray(1, 1) = histArray(1, 1);
for i = 2 : length(histArray)
    frequency = histArray(1,i);
    cdfArray(1,i) = cdfArray(1,i-1)+frequency;
end
subplot(3,2,5), bar(cdfArray);
title('original cumu hist');
% to be checked; subplot(2,2,4),cdfplot(A);

%equalization on cdf
eqArray=zeros(1,256);
total_size = size(A, 1)*size(A, 2);
pixels = floor(total_size/256);
for i = 1 : length(cdfArray)
    frequency = cdfArray(1,i);
    eqArray(1,i) = floor(frequency/pixels);
end
subplot(3,2,6), bar(eqArray);
title('equalized cumu hist');

%equalized histogram 
eqedArray=zeros(1,256);
eqedArray(1,1) = cdfArray(1,1);
for i = 2 : length(eqedArray)
    frequency = cdfArray(1,i);
    eqedArray(1,i) = frequency - cdfArray(1,i-1);
end
subplot(3,2,4), bar(eqedArray);
title('equalized hist');


A_equalised = zeros(size(A, 1), size(A, 2));
 for r = 1 : row
     for c = 1: col 
         intensity = A(r,c)+ 1; 
         A_equalised(r,c)= eqArray(1,intensity); 
     end
 end
subplot(3,2,2), imshow(A_equalised, [0,255]);
title('hist equalized image');
end

function croppedPicture = cropImage(pic)
    A = imread(pic, 'jpg');
    croppedPicture = A(1:floor(size(A,2)/2), 1:size(A,2));
    %imshow(croppedPicture, [0 255]);
end