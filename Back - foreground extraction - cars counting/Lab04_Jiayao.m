close all;
clear all;

% read the .mp4 video
video = VideoReader('traffic.mp4');

%Total length of video file in seconds
duration = video.Duration
numberOfFrames = video.NumberOfFrames
vidHeight = video.Height
vidWidth = video.Width
bitsPerPixel = video.BitsPerPixel
videoFormat = video.VideoFormat
frameRate = video.FrameRate

% extract background
sumFrame = read(video, 1);
sumFrame = double(sumFrame);

for frame =2 : numberOfFrames
    % Extract the frame from the movie structure.
	thisFrame = read(video, frame);
    thisFrame = double(thisFrame);
    
    sumFrame = (1/frame)*thisFrame + sumFrame*((frame-1)/frame); 
end
%sumFrame = double(sumFrame);
%imshow(uint8(sumFrame))
subplot(3,1,1), imshow(uint8(sumFrame));
title('Background Image');

extraction = sumFrame;
backgroundsubtract = double(rgb2gray(uint8(extraction)));


% prepare image for foreground extraction and car counting
grayBackground = rgb2gray(sumFrame);
%imshow(grayBackground, [0, 255])
sumFrame = double(grayBackground);


% extract the foreground for the first and last frame
firstFrame = read(video, 1);
%imshow(firstFrame, [0, 255]);
firstFrameForeground = extractForeground(firstFrame, backgroundsubtract);
subplot(3,1,2), imshow(firstFrameForeground, [0, 255]);
title('First Frame Foreground Image');


LastFrame = read(video, numberOfFrames);
lastFrameForeground = extractForeground(LastFrame, backgroundsubtract);
subplot(3,1,3), imshow(lastFrameForeground, [0, 255]);
title('Last Frame Foreground Image');


% car counting algorithm with foreground extraction. The algorithm takes
% care of all 5 lanes in the picture.
% Delta: the therashold of the change of white pixels in the specific
% vector to help detect a new car coming or the old car remains
prevNum255s = 0;
cars_4 = 0;
cars_1 = 0;
cars_5 = 0;
cars_2 = 0;
cars_3 = 0;

% looking at the 1st lane: pixel range: 128-332
for frame = 1 : numberOfFrames
     % Extract the frame from the movie structure.
    
     thisFrame = read(video, frame);
     result = extractForeground(thisFrame, sumFrame);
     %imshow(result, [0, 255]);
     %prepare frame for car counting
     adjusted = imAdjust(result);
     BW=im2bw(result, 200);
     
     firstCol = BW(:,1);
     targetSection = firstCol(160 : 375);
     numOfwhite = countNumOfWhiteCol(targetSection);
     delta = numOfwhite - prevNum255s;
     prevNum255s = numOfwhite;
     if delta > 7
         cars_1 = cars_1 + 1;
     end
 end

% looking at the 2nd lane: pixel range: 1-128
for frame = 1 : numberOfFrames
    % Extract the frame from the movie structure.
    
    thisFrame = read(video, frame);
    result = extractForeground(thisFrame, sumFrame);
   
    %prepare frame for car counting
    adjusted = imAdjust(result);
    BW=im2bw(result, 150);
    
    lastRow = BW(size(BW, 1), :);
    targetSection = lastRow(1 : 128);
    
    %counting
    numOfwhite = countNumOfWhite(targetSection);
    delta = numOfwhite - prevNum255s;
    prevNum255s = numOfwhite;
    if delta > 32
        cars_2 = cars_2 + 1;
    end
end

% looking at the 3rd lane: pixel range: 128-332
for frame = 1 : numberOfFrames
    % Extract the frame from the movie structure.
    
    thisFrame = read(video, frame);
    result = extractForeground(thisFrame, sumFrame);
   
    %prepare frame for car counting
    adjusted = imAdjust(result);
    BW=im2bw(result, 150);
    
    lastRow = BW(size(BW, 1), :);
    targetSection = lastRow(128 : 332);
    
    numOfwhite = countNumOfWhite(targetSection);
    delta = numOfwhite - prevNum255s;
    prevNum255s = numOfwhite;
    if delta > 60
        cars_3 = cars_3 + 1;
    end
end

% looking at the 4th lane, pixel range: 320-640
for frame = 1 : numberOfFrames
    % Extract the frame from the movie structure.
   
    thisFrame = read(video, frame);
    result = extractForeground(thisFrame, sumFrame);
   
    %prepare frame for car counting
    adjusted = imAdjust(result);
    BW=im2bw(result, 150);
    
    lastRow = BW(size(BW, 1), :);
    middlePoint = round(size(lastRow, 2)/2, 0);
    halfOfLastRow = lastRow(middlePoint: size(lastRow, 2));
    
    
    numOfwhite = countNumOfWhite(halfOfLastRow);
    delta = numOfwhite - prevNum255s;
    prevNum255s = numOfwhite;
    if delta > 50
        cars_4 = cars_4 + 1;
    end
    
end

%  looking at the 5th lane: pixel range: 328-480
for frame = 1 : numberOfFrames
    % Extract the frame from the movie structure.
    
    thisFrame = read(video, frame);
    result = extractForeground(thisFrame, sumFrame);
   
    %prepare frame for car counting
    adjusted = imAdjust(result);
    BW=im2bw(result, 55);
    
    lastCol = BW(:,size(BW, 2));
    targetSection = lastCol(328 : 480);
    
    numOfwhite = countNumOfWhiteCol(targetSection);
    delta = numOfwhite - prevNum255s;
    prevNum255s = numOfwhite;
    if delta > 20
        cars_5 = cars_5 + 1;
    end
end

totalNumCars = cars_1 + cars_2 + cars_3 + cars_4 + cars_5;
totalNumCarsFrom3Lanes = cars_2 + cars_3 + cars_4


% extract foreground
function result = extractForeground(frame, background)
    grayImage = rgb2gray(frame);
    grayImage = double(grayImage);
    %the whole frame - background = foreground, then apply contrast stretch
    result = grayImage - background;
end

% count number of white pixels (255) for row
function num = countNumOfWhite(A)
    count = 0;
    for pixel = 1:size(A,2)
        if A(1, pixel) == 255
            count = count + 1;
        end
    end 
    num = count;
end

% count number of white pixels (255) for col
function num = countNumOfWhiteCol(A)
    count = 0;
    for pixel = 1:size(A,1)
        if A(pixel, 1) == 255
            count = count + 1;
        end
    end 
    num = count;
end

% convert image to binary image for easy counting
function BW = im2bw(A, threshold)
    for row = 1 : size(A, 1)
       for col = 1 : size(A, 2)
            if A(row, col) > threshold
                A(row, col) = 255; %white
            else
                A(row, col) = 0; %black
            end
       end     
    end
    BW = A;
end 

% adjust pixel intensity to be within 0-255
function img = imAdjust(A)
    % look for the lowest value
    lowest = 0;
    highest = 255;
    debug = 0;
    for row = 1 : size(A, 1)
       for col = 1 : size(A, 2)
            if A(row, col) < lowest
                A(row, col) = lowest;
            end
            
            if A(row, col) > highest
                A(row, col) = highest;
            end 
            
            if A(row, col) < debug
                debug = A(row, col);
            end 
            
       end     
    end

    img = A;
end
