%% Status 

 % Example Code for Printing Progress to the Command Window
 fprintf(1,'here''s my integer:  ');
 for i=1:9
     fprintf(1,'\b%d',i); pause(.1)
 end
 fprintf('\n')



% Deskew each image and save it to a row in DeskewedImages
p = 0;   % Current percent complete
step = 1;
fprintf('Progress: 0%%');
n = 1000000;
for i = 1:n
    if (i/n*100) >= (p + step)
        fprintf(repmat('\b',1,length(num2str(p))+1));   % Clear the last percentage
        p = p + step;
        fprintf(1,'%d%%',p);
        if p == 100
            fprintf('\n\n')
        end
    end
end



%% Classification Techniques
% 
% SVM
%   one-vs-all => N
%   one-vs-one => 10 x N
% k-NN
% Random Forest
% Neural Networks
%     Convolutional NNs
% 

%% Preprocessing
% 
Deskewingli
% Ink Normalization - the image is normalized so that the l2-norm of the pixel values is 1.
% 


%% Feature Extraction
% 
% Spatial pyramids over responses in various channels computed from the image. 
% Gradient based features
% 
% 

v = [0 1 0 0;
     0 0 0 0;
     0 0 1 0]
 
v = [1 2 3 4;
     2 3 4 5;
     3 4 5 6;
     4 5 6 7;
     5 6 7 8;
     6 7 8 9]

% Gaussian
y = exp( -((x-b)^2) / (2*c^2) );


%% Gradient Features
http://www.mathworks.com/help/matlab/ref/gradient.html
[FX,FY] = gradient(F)

% Get pixels for a specified block size

% pixel 293
train_data(3, 293)

% up
293 - 28 - 1
293 - 28
293 - 28 + 1

% left and right
292
294

% down
293 + 28 - 1
293 + 28
293 + 28 + 1






