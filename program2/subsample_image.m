function output_img = subsample_image(input_img, scheme)
    switch scheme
        case [4 2 2]

        case [4 1 1]

        otherwise
            fprintf("%s is not a supported subsampling scheme.\n", scheme)
            output_img = input_img;
    end
end

