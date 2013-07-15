%% Display a vector of pixel values to image
% This function only handles square images

function Image = vector_to_image(vector)
    % Arrange the pixels into the square matrix Data
    dimension = sqrt(length(vector));
    Data = reshape(vector, dimension, dimension)';
    
    Image = mat2gray(Data);
end
