function output_image = rgb_to_ycbcr(input_filename)
    input_img = imread(input_filename, "png");

    for r = 1:size(input_img, 1)
        for c = 1:size(input_img, 2)
            px = reshape(input_img(r,c,:), [1,3]);
            
        end
    end
end

