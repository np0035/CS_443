function output_image = rgb_to_ycbcr(input_filename)
    
    % Matrix for converting to YCbCr
    convert_matrix =    [ 0.299,    0.587,    0.114;
                         -0.16874, -0.33126,  0.5;
                          0.5,     -0.41869, -0.08131 ]

    % Matrix for converting back to RGB
    revert_matrix =     [ 1,        0,        1.402;
                          1,       -0.34414, -0.71414;
                          1,        1.77200,  0       ]

    % Read in image
    input_img = imread(input_filename, "png");

    % Iterate over each row and column
    for r = 1:size(input_img, 1)
        for c = 1:size(input_img, 2)

            % Get the current pixel into a form we can work with
            px_rgb = reshape(input_img(r,c,:), [1,3]);
        end
    end
end

