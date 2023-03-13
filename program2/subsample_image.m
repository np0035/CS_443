function output_img = subsample_image(input_img, scheme)

    % Preallocate image space
    rows = size(input_img, 1);
    cols = size(input_img, 2);
    output_img = zeros([rows, cols, 3]);

    % Iterate over each 2x4 block
    for r = 2:2:rows
        for c = 4:4:cols
            % Slice out the current block and subsample it
            input_block = input_img(r-1:r, c-3:c, :);
            output_block = subsample_block(input_block, scheme);

            % Copy the subsampled block into the output image
            output_img(r-1:r, c-3:c, :) = output_block;
        end
    end
end

