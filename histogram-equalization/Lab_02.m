close all;
clear all;

FNames = {'meteora_gray.jpg'; 'penang_hill_gray.jpg'; 'foggy_carpark_gray.jpg'};

% Task 1
for p = 1 : size(FNames)
    figH = figure;
    baseName = FNames{p}(1:find(FNames{p}=='.')-1); 
    old_figName = strcat(baseName, '.jpg');
    
    % histogram equalization
    A = imread(old_figName, 'jpg');
    histogramEqualization(A)
    
    figName = strcat(baseName, '_histogram_eq_results.jpg');
    print(figH, '-djpeg', figName); 
end

% Task 2
for p = 1 : size(FNames)
    figH = figure;
    baseName = FNames{p}(1:find(FNames{p}=='.')-1); 
    old_figName = strcat(baseName, '.jpg');
 
    % cropped picture
     cropImage(old_figName);
     
     croppedFigName = strcat(baseName, '_histogram_eq_results_cropped.jpg');
     print(figH, '-djpeg', croppedFigName);
end


function histogramEqualization(A)
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

    %equalization on cdf
    eqArray=zeros(1,256);
    total_size = size(A, 1)*size(A, 2);
    pixels = floor(total_size/255);
    for i = 1 : length(cdfArray)
        frequency = cdfArray(1,i);
        eqArray(1,i) = floor(frequency/pixels);
    end
    
    %assign new intensity to replace the original intensity
    A_equalised = zeros(size(A, 1), size(A, 2));
     for r = 1 : row
         for c = 1: col 
             intensity = A(r,c) + 1; 
             reassigned_intensity = eqArray(1,intensity);
             A_equalised(r,c) = reassigned_intensity;
         end
     end
    subplot(3,2,2), imshow(A_equalised, [0 255])
    title('hist equalized histogram');

    % histogram after equalization
    eqedhist=zeros(1,256);
    for r = 1 : row
        for c = 1:col 
            intensity = A_equalised(r,c); %intensity: 0-255
            eqedhist(1,intensity+1) = eqedhist(1,intensity+1) + 1;
        end
    end
    subplot(3,2,4), plot(eqedhist);
    title('hist equalization');

    % equalized cdf
    edCDF=zeros(1,256);
    edCDF(1, 1)= eqedhist(1, 1);
    for i = 2 : length(eqedhist)
        edCDF(1,i) = edCDF(1,i-1)+ eqedhist(1,i);
    end
    subplot(3,2,6), plot(edCDF);
    title('equalized cumu hist');
    
end

function croppedPicture = cropImage(pic)
    A = imread(pic, 'jpg');
    croppedPicture = A(floor(size(A,1)/2):size(A,1), 1:size(A,2));
    histogramEqualization(croppedPicture)
end
