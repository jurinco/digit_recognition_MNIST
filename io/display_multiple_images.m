%% Display multiple grayscale images in one figure
% 
% INPUTS:
%   Images: 1xN Cell Array where each row is a grayscale image.
%   Labels: 1xN Cell Array where each cells contents are displayed as an
%           x-axis label for the corresponding cell in Images.
% 
% NOTES:
%   You can create grayscale images using mat2gray()
% 

function display_multiple_images(Images, Labels)

% Calculate the dimensions for the figure
num_of_images = length(Images);
num_of_columns = ceil(sqrt(num_of_images));
num_of_rows = ceil(num_of_images / num_of_columns);

% Display the images in a single figure
figure
for i = 1:num_of_images
    subplot(num_of_rows, num_of_columns, i)
    imshow(Images{i}, 'Border', 'tight')
    xlabel(Labels{i})
end
