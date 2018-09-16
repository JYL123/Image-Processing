close all;
clear all;

% Task 1: contrast stretch
FNames = {'meteora_gray.jpg'; 'penang_hill_gray.jpg'; 'foggy_carpark_gray.jpg'};

%for the entire picture 
%picture meteora_gray.jpg: upper cut off 235, lower cut off 15
%scale: (255-0)/(235-20) = 1.186

%picture penang_hill_gray.jpg: upper cut off 200, lower cut off 0
%scale: (255-0)/(200-0) = 1.275

%picture foggy_carpark_gray.jpg: upper cut off 210, lower cut off 45
%scale: (255-0)/(240-30) = 1.214
for p = 1 : size(FNames)
     figH = figure;
     baseName = FNames{p}(1:find(FNames{p}=='.')-1); 
     old_figName = strcat(baseName, '.jpg');
     
     A = imread(old_figName, 'jpg');
     if (strcmp(old_figName,'meteora_gray.jpg'))
      contrastStretch(A, 1.186);
     elseif(strcmp(old_figName,'penang_hill_gray.jpg'))
      contrastStretch(A, 1.275);
     elseif(strcmp(old_figName,'foggy_carpark_gray.jpg'))
      contrastStretch(A, 1.275); 
     end
     
     figName = strcat(baseName, '_contrast_result.jpg');
     print(figH, '-djpeg', figName); 
end

%for halved picture 
%picture meteora_gray.jpg: upper cut off 235, lower cut off 15
%scale: (255-0)/(210-5) = 1.244

%picture penang_hill_gray.jpg: upper cut off 200, lower cut off 0
%scale: (255-0)/(200-10) = 1.417

%picture foggy_carpark_gray.jpg: upper cut off 210, lower cut off 45
%scale: (255-0)/(160-30) = 1.962
for p = 1 : size(FNames)
     figH = figure;
     baseName = FNames{p}(1:find(FNames{p}=='.')-1); 
     old_figName = strcat(baseName, '.jpg');
     
     A = imread(old_figName, 'jpg');
     croppedPicture = A(floor(size(A,1)/2):size(A,1), 1:size(A,2));
     if (strcmp(old_figName,'meteora_gray.jpg'))
      contrastStretch(croppedPicture, 1.244);
     elseif(strcmp(old_figName,'penang_hill_gray.jpg'))
      contrastStretch(croppedPicture, 1.417);
     elseif(strcmp(old_figName,'foggy_carpark_gray.jpg'))
      contrastStretch(croppedPicture, 1.759); 
     end
     
     figName = strcat(baseName, '_half_pic_contrast_result.jpg');
     print(figH, '-djpeg', figName); 
end

% Task 2: 1D convolution
h = [-1 0 1 0 0 0 0 0 0 0];
x = [5 5 5 5 5 0 0 0 0 0];
%OneDConvolution(h,x);

%Task 3: Edge detection
FNames = {'checker.jpg'; 'letterBox.jpg'; 'pipe.jpg'; 'carmanBox.jpg';};
for p = 1 : size(FNames)
    figH = figure;
    baseName = FNames{p}(1:find(FNames{p}=='.')-1); 
    old_figName = strcat(baseName, '.jpg');
        
    RGB = imread(old_figName, 'jpg');
    I = rgb2gray(RGB);
    EdgeDetection(I);
    
    figName = strcat(baseName, '_sobel_edge_detection.jpg');
    print(figH, '-djpeg', figName); 
end

function contrastStretch(A, x)
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
    subplot(3,2,3), plot(histArray)
    title('original histogram');

    % construct cdf
    cdfArray=zeros(1,256);
    cdfArray(1, 1) = histArray(1, 1);
    for i = 2 : length(histArray)
        frequency = histArray(1,i);
        cdfArray(1,i) = cdfArray(1,i-1)+frequency;
    end
    subplot(3,2,5), plot(cdfArray);
    title('original cumu hist');
    
    % scale old pixel intensity to new intensity
    for r = 1 : row
        for c = 1:col 
            intensity = A(r,c);
            A(r,c) = intensity * x;
        end
    end
    subplot(3,2,2), imshow(A, [0 255]);
    title('stretched image');
    
    % construct histogram  
    for r = 1 : row
        for c = 1:col 
            intensity = A(r,c);
            histArray(1,intensity+1)=histArray(1,intensity+1)+1; 
        end
    end
    subplot(3,2,4), plot(histArray)
    title('stretched histogram');

    % construct cdf
    cdfArray=zeros(1,256);
    cdfArray(1, 1) = histArray(1, 1);
    for i = 2 : length(histArray)
        frequency = histArray(1,i);
        cdfArray(1,i) = cdfArray(1,i-1)+frequency;
    end
    subplot(3,2,6), plot(cdfArray);
    title('stretched cumu hist');
    
    
end

function OneDConvolution(h, x)

    %h = [3 2 1 0 0 0 0 0 0 0];
    %x = [5 5 5 5 5 0 0 0 0 0];

    figure

    paddedH  = [zeros(1,9) h];
    paddedX  = [zeros(1,9) x];
    flippedH = [fliplr(h) zeros(1,9)];

    subplot(4,1,1), stem([-9:9], paddedH, 'k'), title('h');
    subplot(4,1,2), stem([-9:9], paddedX, 'r'), title('x');
    subplot(4,1,3), stem([-9:9], flippedH, 'b'), title('h flipped');

    % to implement the convolution equation  g[m] = sum_t ( x[m-t]*h[t] )

    conv_result = zeros(1,19);

    temp = flippedH;

    for m = 0 : 9

        csum = sum(paddedX .* temp);
        conv_result(m+10) = csum;

        subplot(4,1,4), stem([-9:9], conv_result, 'k'), ylim([-7 7]), title('convolution result');

        pause(5)

        temp = [0 temp(1:length(temp)-1)];
        subplot(4,1,3), stem([-9:9], temp, 'b'), title('h flipped');

    end

end

function EdgeDetection(I)
    %Padding
    paddedImg=zeros(size(I, 1)+4, size(I, 2)+4);
    for r = 4 : size(paddedImg, 1)-4
        for c = 4 : size(paddedImg, 2)-4
            intensity = I(r-1,c-1);
            paddedImg(r,c)=intensity; 
        end
    end 
    paddedImg
    edgeDetect = detect(paddedImg);
    imshow(edgeDetect);
   
    
end

function edgeDetect = detect(img)
    %kernels will be used:
    %Kx = [-1 0 1; -2 0 2; -1 0 1];
    %Ky = [-1 -2 -1; 0 0 0; 1 2 1];
    
    % use double in case of overflow
    I = double(img);
    
     for r = 2 : size(img, 1)-1
         for c = 2 : size(img, 2)-1
             
             %multiplication & addition
             sumX = I(r-1, c-1)*(-1) + I(r-1, c+1) + I(r, c-1)*(-2) + I(r, c+1)*(2) + I(r+1, c-1)*(-1) + I(r+1, c+1)*(1);
             sumY = I(r-1, c-1)*(-1) + I(r-1, c)*(-2) + I(r-1, c+1)*(-1) + I(r+1, c-1)*(1) +  I(r+1, c)*(2) + I(r+1, c+1)*(1);
            
             %reset value
             img(r, c) = sqrt(sumX^2 + sumY^2);
         end
     end
    edgeDetect = img;
end 
