function output_img = rgb_to_ycbcr(input_filename)
    
    % Matrix for converting to YCbCr
    convert_matrix =    [ 0.299,    0.587,    0.114;
                         -0.16874, -0.33126,  0.5;
                          0.5,     -0.41869, -0.08131 ];

    % Matrix for converting back to RGB
    revert_matrix =     [ 1,        0,        1.402;
                          1,       -0.34414, -0.71414;
                          1,        1.77200,  0       ];

    % Read in image
    input_img = imread(input_filename, "png");
    output_img = zeros(size(input_img));

    % Iterate over each row and column
    for r = 1:size(input_img, 1)
        for c = 1:size(input_img, 2)

            % Get the current pixel into a form we can work with and
            % normalize it
            px_rgb = double(reshape(input_img(r,c,:), [3, 1])) ./ 256;

            % Perform the conversion
            px_yCbCr = reshape(((convert_matrix * px_rgb) + [0; 0.5; 0.5]) .* 256, [1, 1, 3]);

            % Store the resulting pixel into the output image
            output_img(r,c,:) = px_yCbCr;
        end
    end
    output_img = uint8(output_img);
    imshow(output_img);
end

