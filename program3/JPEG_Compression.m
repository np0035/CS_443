function output = JPEG_Compression(imageFile, N, qf)
% The function JPEG_Compression takes an image matrix and applies JPEG
% compression by performing the following steps:
%   Convert in image from RGB to YCbCr
%   Perform 4:2:2 Chroma Subsampling
%   Apply 2D DCT with NxN blocks
%   Apply Quantization using Quantization tables with Quality Scaling Factor qf
% The function then decompresses the image matrix by applying the above
% steps in reverse
%
% imageFile is the input image matrix that is in the RGB model
% N is an int value that corresponds to the NxN blocks used for DCT
% qf is the Quality Scaling Factor that is used in Quantization

%% Resize the imageFile
xresize = size(imageFile,1);
yresize = size(imageFile,2);

% Need to pad image so its size is divisible by N
if(mod(size(imageFile, 1), N) ~= 0)
    xresize = size(imageFile, 1);
    imageFile(size(imageFile, 1) + 1:(N-mod(size(imageFile,1),N)) + size(imageFile,1), :, :) = 1;
end
if(mod(size(imageFile, 2), N) ~= 0)
    yresize = size(imageFile, 2);
    imageFile(:, size(imageFile, 2) + 1:(N-mod(size(imageFile,2),N)) + size(imageFile,2), :) = 1;
end
%% Convert RGB to YCbCr
imageFile = double(rgb2ycbcr(imageFile));

%% Perform 2D Chroma Subsampling 4:2:2
Yimage = chromaSubsampling(imageFile(:,:,1), 4, 2, 2);
Cbimage = chromaSubsampling(imageFile(:,:,2), 4, 2, 2);
Crimage = chromaSubsampling(imageFile(:,:,3), 4, 2, 2);
imageFile(:,:,1) = double(Yimage);
imageFile(:,:,2) = double(Cbimage);
imageFile(:,:,3) = double(Crimage);
%% Apply 2D DCT transform
for i = 1:N:size(imageFile,1)
    for j = 1:N:size(imageFile,2)
        imageFile(i:i+N-1, j:j+N-1, 1:3) = dctTransform(imageFile(i:i+N-1, j:j+N-1, 1:3));
    end
end
imageFile = round(imageFile);

%% Apply quantization using tables for Luminance and Chrominance Components
% Calculate quantization table
lumiQuant = [
    16, 11, 10, 16, 24, 40, 51, 61;
    12, 12, 14, 19, 26, 58, 60, 55;
    14, 13, 16, 24, 40, 57, 69, 56;
    14, 17, 22, 29, 51, 87, 80, 62;
    18, 22, 37, 56, 68, 109, 103, 77;
    24, 35, 55, 64, 81, 104, 113, 92;
    49, 64, 78, 87, 103, 121, 120, 101;
    72, 92, 95, 98, 112, 100, 103, 99];
chromQuant = [
    17, 18, 24, 47, 99, 99, 99, 99;
    18, 21, 26, 66, 99, 99, 99, 99;
    24, 26, 56, 99, 99, 99, 99, 99;
    47, 66, 99, 99, 99, 99, 99, 99;
    99, 99, 99, 99, 99, 99, 99, 99;
    99, 99, 99, 99, 99, 99, 99, 99;
    99, 99, 99, 99, 99, 99, 99, 99;
    99, 99, 99, 99, 99, 99, 99, 99];

% Determine the scaling_factor based on qf
if qf >= 50
    scaling_factor = (100-qf)/50;
else
    scaling_factor = (50/qf);
end
% Calculate new quantization tables
if scaling_factor ~= 0
    lumiQuant = uint8(round(scaling_factor * lumiQuant));
    chromQuant = uint8(round(scaling_factor * chromQuant));
else
    lumiQuant = uint8(ones(8,8));
    chromQuant = uint8(ones(8,8));
end
% Quantize the Luminance and Chrominance of the Image
for k = 1:3
    for i = 1:N:size(imageFile,1)
        for j = 1:N:size(imageFile,2)
            if k == 1
                imageFile(i:i+N-1, j:j+N-1, k) = round(imageFile(i:i+N-1, j:j+N-1, k)./double(lumiQuant));
            else
                imageFile(i:i+N-1, j:j+N-1, k) = round(imageFile(i:i+N-1, j:j+N-1, k)./double(chromQuant));
            end
        end
    end
end

%% Dequantize the DCT coefficients
for k = 1:3
    for i = 1:N:size(imageFile,1)
        for j = 1:N:size(imageFile,2)
            if k == 1
                imageFile(i:i+N-1, j:j+N-1, k) = round(imageFile(i:i+N-1, j:j+N-1, k).*double(lumiQuant));
            else
                imageFile(i:i+N-1, j:j+N-1, k) = round(imageFile(i:i+N-1, j:j+N-1, k).*double(chromQuant));

            end
        end
    end
end

%% Apply 2D IDCT to dequantized DCT coefficients
for i = 1:N:size(imageFile,1)
    for j = 1:N:size(imageFile,2)
        imageFile(i:i+N-1, j:j+N-1, 1:3) = idctTransform(imageFile(i:i+N-1, j:j+N-1, 1:3));
    end
end
imageFile = uint8(round(imageFile));
%% Convert YCbCr components to RGB model
imageFile = ycbcr2rgb(imageFile);
imageFile = imageFile(1:xresize,:,:);
output = imageFile(:,1:yresize,:);