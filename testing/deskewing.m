%% Deskew Image Data

% DESKEW ALL TRAINING IMAGES
% nInstances = length(TrainData);
% fprintf('Deskewing training data\n');
% 
% TrainDataDeskewed = zeros(size(TrainData));
% nfeatures = length(TrainData(1,:));
% 
% % Deskew each image and save it into DeskewedImages
% for i = 1:nInstances
%     instance_vector = TrainData(i,:);
%     Image = vector_to_image(instance_vector);
%     DeskewedImage = deskew_grayscale_image(Image);
% 
%     if DeskewedImage == -1
%         % Use the original data
%         TrainDataDeskewed(i,:) = TrainData(i,:);
%     else
%         deskewed_instance = reshape(DeskewedImage', 1, nfeatures);
%         TrainDataDeskewed(i,:) = deskewed_instance;
%     end
% end
% 
% save([DATA_PATH 'TrainDataDeskewed.mat'], 'TrainDataDeskewed')



%% SAVE THE SKEWS OF ALL IMAGES
% mInstances = length(TrainData);
% fprintf('Calculating the skew for all images\n');
% 
% skews = zeros(mInstances,1);
% 
% % Get the skew for each image and save it to the vector 'skew'
% for i = 1:mInstances
%     instance_vector = TrainData(i,:);
%     Image = vector_to_image(instance_vector);
%     [~, skew] = deskew_grayscale_image(Image);
%     
%     skews(i) = skew;
% 
% %     % Compact version of the code above
% %     [~, skews(i)] = deskew_grayscale_image(vector_to_image(TrainData(i,:)));
% end
% 
% save([DATA_PATH 'skews.mat'], 'skews')



%% DESKEW DATASETS
% good = [1 12 16 21 28 31 62 68 105 122 125 135 148 198 256 368 369 376 399 402 403 412 416 432 459 460 492];
% 
% bad = [30 129 152 219 266 270 279 295 310 326 362 465 385 388 386 414 437 463 478 479 480 627 6394];
% terrible = [4 33 35 43 45 56 67 73 76 81 82 90 95 116 117 121 144 145 146 149 163 171 180 245 342 350 348 359 379 386 388 391 398 410 411 421 444 447 451 474 488 493 497 499 500];
% terrible1 = [76 81 121 144 149 180 398 410 474];
% 
% interesting = [22 24 25 40 44 392 413 418 431 434 473 484 495 521 2384];
% unnecessary = [3 5 7 8 9 10 64 352 343 346 349 381 382 385 390 423 467 469 470 481];
% 
% pc_angle_gt_180 = [33 43 73 82 90 95 142 144 196 205 236 265 379 398 404 434 521 525 543 568 589 639 651 659 701 729 757 801];

% Sets for final deskew function




% % DESKEW SPECIFIC VECTOR OF IMAGE INDICES
% % 
% % indices = terrible(1:28);
% % indices = terrible(29:end);
% indices = good;
% n = length(indices);   % Number of instances
% 
% Images{n*2,1} = [];
% Labels{n*2,1} = [];
% 
% for i = 1:n
%     instance_vector = TrainData(indices(i),:);
%     Image = vector_to_image(instance_vector);
%     [DeskewedImage, skew] = deskew_grayscale_image(Image);
%     
%     if (DeskewedImage ~= -1) 
%         Images{i*2-1} = Image;
%         Labels{i*2-1} = indices(i);
%         Images{i*2} = DeskewedImage;
%         Labels{i*2} = skew;
%     end
% end
% 
% % Display deskewed image with labels for instance index and skew
% display_multiple_images(Images, Labels)




% % DESKEW SINGLE IMAGE - For testing deskew_grayscale_image()
% i = 1;   % Index of instance number in 'data' which will be deskewed
% data = TrainData;
% 
% instance = data(i,:);
% Image = vector_to_image(instance);
% [DeskewedImage, skew] = deskew_grayscale_image(Image);
% 
% Images = {Image DeskewedImage};
% Labels = {i skew};
% 
% display_multiple_images(Images, Labels);




% % DESKEW SINGLE IMAGE THAT MEETS A CONDITINO IN deskew_grayscale_image()
% mInstances = length(TrainData);
% 
% i = 1;   % Index of instance number in 'data' which will be deskewed
% while (i <= mInstances)
%     instance = TrainData(i,:);
%     Image = vector_to_image(instance);
%     [DeskewedImage, skew] = deskew_grayscale_image(Image);
%     
%     if (DeskewedImage ~= -1)
%         Images{i} = Image;
%         Labels{i} = i;
%         Images{i+1} = DeskewedImage;
%         Labels{i+1} = skew;
%         indices(d) = i;
%     end
%     i = i + 1;
% end
% 
% 
% Images = {Image DeskewedImage};
% Labels = {data(i) skew};
% 
% display_multiple_images(Images, Labels);






% % DESKEW n TRAINING IMAGES
% mInstances = length(TrainData);
% n = 28;
% 
% Images{n*2,1} = [];
% Labels{n*2,1} = [];
% indices = zeros(n,1);
% 
% % Deskew each image and save it into DeskewedImages
% d = 0;   % Count of deskewed images
% i = 1;   % Index of TrainData to start iterating from
% while (i <= mInstances) && (d < n)
%     instance_vector = TrainData(i,:);
%     Image = vector_to_image(instance_vector);
%     [DeskewedImage, skew] = deskew_grayscale_image(Image);
%     
%     if (DeskewedImage ~= -1)
%         d = d + 1;
%         Images{d*2-1} = Image;
%         Labels{d*2-1} = i;
%         Images{d*2} = DeskewedImage;
%         Labels{d*2} = skew;
%         indices(d) = i;
%     end
%     i = i + 1;
% end
% 
% % Display deskewed image with labels for instance index and skew
% display_multiple_images(Images, Labels)
% 
% % disp(indices);




% DESKEW n TRAINING IMAGES
% SHOW DESKEWED IMAGES ONLY WHEN ONE IS CREATED, OTHERWISE SHOW ONLY THE ORIGINAL IMAGE
interesting = [76 81 99 105 106 ];
mInstances = length(tr_feats);
n = 55;

Images{n,1} = [];
Labels{n,1} = [];
indices = zeros(n,1);

% Deskew each image and save it into DeskewedImages
d = 0;   % Count of deskewed images
i = 1;   % Index of TrainData to start iterating from
while (i <= mInstances) && (d < n)
    instance_vector = tr_feats(i,:);
    Image = vector_to_image(instance_vector);
    [DeskewedImage, skew] = deskew_grayscale_image(Image);
    
    d = d + 1;
    Images{d} = Image;
    Labels{d} = i;
    
    if (DeskewedImage ~= -1)
        d = d + 1;
        Images{d} = DeskewedImage;
        Labels{d} = skew;
    end
    i = i + 1;
end

% Display deskewed image with labels for instance index and skew
display_multiple_images(Images, Labels)





%% TEST DESKEWING

% For each digit, average the original and the deskewed images.

% % AVG OF ORIGINAL IMAGES
% 
% digit_instances = containers.Map('KeyType','single','ValueType','any');
% avg_digits = containers.Map('KeyType','single','ValueType','any');
% 
% Images{10,1} = [];
% Labels{10,1} = [];
% 
% for i = 0:9
%     % Separate the instances for digit i
%     digit_instances(i) = TrainData(TrainLabels == i, :);
%     % Average the digit i into a single image
%     avg_digits(i) = mean(digit_instances(i));
%     
%     % Create and save the averaged image of digit i
%     Image = vector_to_image(avg_digits(i));
%     Images{i+1} = Image;
%     Labels{i+1} = i;
% end
% 
% display_multiple_images(Images, Labels)


% AVG OF DESKEWED IMAGES
% digit_instances = containers.Map('KeyType','single','ValueType','any');
% avg_digits = containers.Map('KeyType','single','ValueType','any');
% 
% Images{10,1} = [];
% Labels{10,1} = [];
% 
% for i = 0:9
%     % Separate the instances for digit i
%     digit_instances(i) = TrainDataDeskewed(TrainLabels == i, :);
%     % Average the digit i into a single image
%     avg_digits(i) = mean(digit_instances(i));
%     
%     % Create and save the averaged image of digit i
%     Image = vector_to_image(avg_digits(i));
%     Images{i+1} = Image;
%     Labels{i+1} = i;
% end
% 
% display_multiple_images(Images, Labels)
