%% Reshape a grayscale image into an Nx2 matrix.
% 

function [Data] = grayscale_image_to_data_matrix(Image)

% NOT CORRECT
I = round(Image * 255);

% Pre-allocate memory for Data matrix.
% total_rows = round(sum(sum(Image)) * 255);
mRows = sum(sum(I));
Data = zeros(mRows,2);

% Add data points to the Data matrix
r = 1;   % rows count
for m = 1:size(I,1)
    for n = 1:size(I,2)
        if I(m,n) > 0
            nInstances = I(m,n);
            % Create new data points.
            NewDataPoints = repmat([n -m], nInstances, 1);
            % Insert new data points into Data matrix.
            Data(r : (r + nInstances - 1), :) = NewDataPoints;
            
            r = r + nInstances;
        end
    end
end
