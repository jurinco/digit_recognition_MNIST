%% deskew_grayscale_image
% 
% INPUTS:
%   Image: matrix representing a grayscale image
%   angle_mod_function: function to modulate the angle by which Image is
%   deskewed.  The angle is modulated in relation to the variance explained
%   by the principal component.
%   angle_mod_function(angle,pc_variance)
% 
% return -1 if the original image is not skewed
% 

function [DeskewedImage, mod_angle] = deskew_grayscale_image(Image, angle_mod_function)

% Reshape a grayscale image into an Nx2 matrix.
Data = grayscale_image_to_data_matrix(Image);

% Compute the principal component
Covar = cov(Data);
[E_vectors E_vals] = eig(Covar);

e_vals = diag(E_vals);
[e_vals perm] = sort(e_vals,'descend');   % Sort eigenvalues and get the sorting permutation.
E_vectors = E_vectors(:,perm);    % Sort eigenvectors


% Calculate the skew of the image.
% The skew is the angle between the PC's eigenvector and the y-axis
angle = atand(E_vectors(1,1)/E_vectors(2,1));

% Calculate how much of the variance is explained by each variable
var =  e_vals ./ sum(e_vals);


% % Plot data with eigenvector
% Data0 = bsxfun(@minus, Data, mean(Data));
% 
% figure
% plot(Data0(:,1), Data0(:,2), 'b.');
% hold on;
% plot([0 E_vectors(1,2)], [0 E_vectors(2,2)], 'r-');   % first eigenvector
% plot([0 E_vectors(1,1)], [0 E_vectors(2,1)], 'g-');   % second eigenvector
% axis equal
% hold off;


% Modulate the skew angle according to how much variance is explained by the PC.
if nargin < 2
%     mod_angle = angle * var(1)^(((1-var(1))*10)^2);
    mod_angle = angle_modulator(angle,var(1));
else
    mod_angle = angle_mod_function(angle,var(1));
end


if abs(mod_angle) >= 1
    % Deskew the image
    DeskewedImage = imrotate(Image, mod_angle, 'bilinear', 'crop');
else
    DeskewedImage = Image;
end

end

function y = angle_modulator(a,x)
    y = a * x^(((1-x)*10)^2);
end