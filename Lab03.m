close all;
clear all;

% experiment on one picture first
FNames = {'meteora_gray.jpg';};
%'penang_hill_gray.jpg'; 'foggy_carpark_gray.jpg'

%picture meteora_gray.jpg: upper cutoff 235, lower cut off 15, scale:
%(255-0)/(235-15) = 1.159 (51/44)



% Task 1: contrast stretch
% for p = 1 : size(FNames)
%     figH = figure;
%     baseName = FNames{p}(1:find(FNames{p}=='.')-1); 
%     old_figName = strcat(baseName, '.jpg');
%     
%     % histogram equalization
%     A = imread(old_figName, 'jpg');
%     contrastStretch(A, 1.159);
%     
%     figName = strcat(baseName, '_histogram_eq_results.jpg');
%     print(figH, '-djpeg', figName); 
% end

% Task 2: 1D convolution
% h = [-1 0 1 0 0 0 0 0 0 0];
% x = [5 5 5 5 5 0 0 0 0 0];
% OneDConvolution(h,x);

%Task 3: Edge detection
RGB = imread('carmanBox.jpg');
I = rgb2gray(RGB);
% figure
% imshow(I)
EdgeDetection(I);

function contrastStretch(A, x)
    x
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

        subplot(4,1,4), stem([-9:9], conv_result, 'k'), ylim([0 50]), title('convolution result');

        pause(5)

        temp = [0 temp(1:length(temp)-1)];
        subplot(4,1,3), stem([-9:9], temp, 'b'), title('h flipped');

    end

end

function EdgeDetection(I)
    
end
