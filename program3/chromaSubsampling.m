function output = chromaSubsampling(input, y, a, b)
% Input is a single 2d matrix that contains a single channel of an image
% y, a, b stand for the subsampling ratio in the form of c:a:b that will be
% used for chroma subsampling the output
[row, col] = size(input);      % Get the row, column, and channel size of the Image Array
output = double(zeros(row,col));     % Create the Output Array
flag = 0;                           % When flag is 0: on row A, 1: row B
currSample = 0;                     % Holds the current sample being copied onto the pixels
nextPos = 1;                        % Holds the position of where the next sample is 
for x = 1:row                       % Loop through each column and row
    for z = 1:col
        if flag == 0                % Case for if on the top row
            if z == nextPos
                currSample = input(x,z);
                nextPos = nextPos + y/a;
            end
        elseif flag == 1            % Case for if on the bottom row
            if z == nextPos
                currSample = input(x,z);
                nextPos = nextPos + y/b;
            end
        end
        output(x,z) = currSample;
    end
    if flag == 0                    % Switch the flag to row B: use value b
        flag = 1;
        nextPos = 1;
    else                            % Switch the flag to row A: use value a
        flag = 0;
        nextPos = 1;
    end
end
end