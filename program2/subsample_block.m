function output_block = subsample_block(input_block, scheme)

    % Split the block into its components
    y = input_block(:,:,1);
    cb = input_block(:,:,2);
    cr = input_block(:,:,3);

    switch scheme
        case "4:2:2"
            % Copy values from first column to second
            cb(:,2) = cb(:,1);
            cb(:,4) = cb(:,3);

            % Copy values from third column to fourth
            cr(:,2) = cr(:,1);
            cr(:,4) = cr(:,3);

        case "4:1:1"
            % Copy values from first column to other columns
            cb(:,:) = repmat(cb(:,1), [1, 4]);
            cr(:,:) = repmat(cr(:,1), [1, 4]);

        otherwise
            fprintf("%s is not a supported subsampling scheme.\n", scheme)
            output_block = input_block;
    end

    % Construct an output block with the resulting values
    output_block(:,:,1) = y;
    output_block(:,:,2) = cb;
    output_block(:,:,3) = cr;
end

