%% Kaggle Digit Recognition Challenge (using the MNIST dataset)
%  https://www.kaggle.com/c/digit-recognizer
%

%% Initialization
clear; close all; clc

global config;
config.LIBSVM_t    = 1;                % kernal type
config.LIBSVM_c    = 10;               % C parameter for SVM
config.LIBSVM_d    = 3;                % LIBSVM poly degree
config.LIBSVM_r    = 1;                % LIBSVM r (coefficient)
config.LIBSVM_g    = 1;                % LIBSVM gamma for rbf kernel
config.BLOCKS      = [14 7 4; 14 7 4]; % block sizes for histogramming
config.DO_OVERLAP  = true;             % have overlapping blocks
config.NORI        = 12;               % number of orientations
config.PATCH_W     = 28;               % patch width (do not change)
config.PATCH_H     = 28;               % patch height (do not change)
config.NORM_TYPE   = 'l2';             % normalization type (l1 or l2)
config.GRAD_TYPE   = 2;                % 0:tap, 1:sobel, 2:gaussian filters
config.GRAD_SIGMA  = 2;                % sigma of the gaussian filter

addpath 'io'
addpath 'data'
addpath 'preprocessing'
addpath 'feature_extraction'
addpath 'classifiers/libsvm-3.13'

data_path = 'data/';
original_data_path = [data_path 'original_data/'];
models_path = 'classifiers/models/';
predictions_path = 'predictions/';


%% Set Variables

nTrain = 32000;

% data_filename = 'feats.mat';
% deskewed_data_filename = 'feats_d.mat';
% norm_data_filename = 'feats_dn.mat';
% sphog_data_filename = sprintf([data_path 'feats_sphog_%i_dn_nonzero.mat'], config.NORI);

data_filename = 'feats_nonzero.mat';
deskewed_data_filename = 'feats_d_nonzero.mat';
norm_data_filename = 'feats_dn_nonzero.mat';
sphog_data_filename = sprintf([data_path 'feats_sphog_%i_dn_nonzero.mat'], config.NORI);


%% Load Data

if exist([data_path data_filename],'file')
    fprintf('Loading original preprocessed data from: %s\n',data_filename);
    load(data_filename)
    load('tr_labels.mat')
else
    tic
    fprintf('Processing original data.\n');
    read_data
    display_elapsed_time
end


%% Deskew Data

if exist([data_path deskewed_data_filename],'file')
    fprintf('Loading precomputed deskewed features from: %s\n',deskewed_data_filename);
    load(filename)
else
    tic
    fprintf('Deskewing training features.\n');
%     tr_feats_desk = deskew_image_data(tr_feats);
    tr_feats_desk = deskew_image_data(tr_feats_nonzero);
    display_elapsed_time
    
    tic
    fprintf('Deskewing testing features.\n');
%     te_feats_desk = deskew_image_data(te_feats);
    te_feats_desk = deskew_image_data(te_feats_nonzero);
    display_elapsed_time
    
    fprintf('Saving deskewed features to: %s\n',deskewed_data_filename);
    save([data_path deskewed_data_filename], 'tr_feats_desk','te_feats_desk');
end


%% Normalize Data

norm_type = config.NORM_TYPE;

if exist([data_path norm_data_filename],'file')
    fprintf('Loading precomputed normalized features from: %s\n',norm_data_filename);
    load(norm_data_filename)
else
    tic
    fprintf('Normalizing training and testing features.\n');
    fprintf('Saving results to: %s\n',norm_data_filename);
    tr_feats_desk_norm = normalize_data(tr_feats_desk, norm_type);
    te_feats_desk_norm = normalize_data(te_feats_desk, norm_type);
    save([data_path norm_data_filename], 'tr_feats_desk_norm','te_feats_desk_norm');
    display_elapsed_time
end


%% Compute SPHOG Features

if exist(sphog_data_filename,'file')
    fprintf('Loading precomputed SPHOG features from: %s\n',sphog_data_filename);
    load(sphog_data_filename);
else
    % Compute SPHOG features from the deskewed normalized features
    tic
    data_var_name = 'tr_feats_desk_norm';
    fprintf('Computing SPHOG features for variable: %s\n',data_var_name);
    tr_feats_sphog_dn = compute_sphog_features(eval(data_var_name));
    display_elapsed_time
    
    tic
    data_var_name = 'te_feats_desk_norm';
    fprintf('Computing SPHOG features for variable: %s\n',data_var_name);
    te_feats_sphog_dn = compute_sphog_features(eval(data_var_name));
    display_elapsed_time
    
    fprintf('Saving SPHOG features to: %s\n',sphog_data_filename);
    save(sphog_data_filename,'tr_feats_sphog_dn','te_feats_sphog_dn');
end


% %% Train SVM
% 
% tic
% 
% t = num2str(config.LIBSVM_t);
% d = num2str(config.LIBSVM_d);
% g = num2str(config.LIBSVM_g);
% r = num2str(config.LIBSVM_r);
% c = num2str(config.LIBSVM_c);
% 
% fprintf('Training degree %s polynomial SVM model.\n',d);
% libsvm_options = ['-s 0 -t ' t ' -d ' d ' -g ' g ' -r ' r ' -c ' c ' -b 0 -q']
% 
% fprintf('Using %d training samples\n',nTrain);
% model = svmtrain(tr_labels(1:nTrain,:), tr_feats_sphog_dn(1:nTrain,:), libsvm_options);
% 
% display_elapsed_time
% 
% 
% % Predict
% tic
% 
% fprintf('Predicting labels for the test data.\n');
% te_labels = zeros(length(te_feats),1);
% [pred accuracy dec_vals] = svmpredict(te_labels, te_sphog_feats, model, '-b 1');
% 
% display_elapsed_time
% 
% % Output predictions
% out_filename = ['pred_' num2str(nTrain) '_p'  '.csv'];
% % out_filename = 'pred_sphog_linear.csv';
% csvwrite(out_filename,pred);


%% Display images

% % indices = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25];
% % display_multiple_images(tr_feats, indices)
% 
% % data = 'te_sphog_feats';
% nInstances = length(te_labels);
% n = 56;
% 
% Images{n,1} = [];
% Labels{n,1} = [];
% 
% i = 1;   % Index of data to start iterating from
% while (i <= nInstances) && (i <= n)
%     instance_vector = te_feats_desk_norm(i,:);
%     Image = vector_to_image(instance_vector);
%     
%     Images{i} = Image;
%     Labels{i} = i;
% 
%     i = i + 1;
% end
% display_multiple_images(Images, Labels)
% 
% % Show predictions for the displayed digits
% for i = 1:n
%    fprintf('%d: %d\n',[i,pred(i)]); 
% end
% 
% 
% true_vals = [1 0 1 4 0 0 7 3 5 3 8 9 1 3 3 1 2 0 7 5 8 6 2 0 2 3 6 9 9 7 8 9 4 9 2 1 3 1 1 4 9 1 4 4 2 6 3 7 7 4 7 5 1 9 0 2];
% accuracy_p = nnz(pred(1:n) == true_vals') / n * 100;
% fprintf('accuracy for %d samples: %.2f%%\n',[n,accuracy_p]);



%% TESTING SVM MODELS
% % Setup
% clear; close all; clc
% 
% addpath 'io'
% addpath 'data'
% addpath 'preprocessing'
% addpath 'feature_extraction'
% addpath 'classifiers/libsvm-3.13'
% 
% load 'feats.mat';
% load 'tr_labels.mat';
% load 'feats_deskew.mat';
% load 'feats_deskew_norm.mat';
% load 'sphog_12.mat';
% 
% 
% % Common stuff
% % nTrain = 4000;
% % nTrain = 8000;
% % nTrain = 16000;
% % nTrain = 32000;
% nTrain = 42000;
% 
% -------------------------------------------------------------------------
--- LINEAR ---
fprintf('Training linear SVM model.\n');
libsvm_options = '-s 0 -t o -d 3 -c 10 -b 1 -q';

fprintf('Using %d training samples\n',nTrain);


% ORIGINAL data
fprintf('original data\n');
model = svmtrain(tr_labels(1:nTrain,:), tr_feats(1:nTrain,:), libsvm_options);
[pred accuracy dec_vals] = svmpredict(tr_labels(nTrain+1:end,:), tr_feats(nTrain+1:end,:), model, '-b 1');
% % Accuracy = 90.4842% (34384/38000)
% % Accuracy = 91.0118% (30944/34000)
% % Accuracy = 91.3192% (23743/26000)
% % Accuracy = 90.7% (9070/10000)

% % DESKEWED TRAINING data
% fprintf('deskewed data\n');
% model = svmtrain(tr_labels(1:nTrain,:), tr_feats_desk(1:nTrain,:), libsvm_options);
% [pred accuracy dec_vals] = svmpredict(tr_labels(nTrain+1:end,:), tr_feats_desk(nTrain+1:end,:), model, '-b 1');
% % Accuracy = 92.1368% (35012/38000)
% % Accuracy = 92.3059% (31384/34000)
% % 
% % 
% 
% % NORMALIZED DESKEWED data
% fprintf('deskewed normalized data\n');
% model = svmtrain(tr_labels(1:nTrain,:), tr_feats_desk_norm(1:nTrain,:), libsvm_options);
% [pred accuracy dec_vals] = svmpredict(tr_labels(nTrain+1:end,:), tr_feats_desk_norm(nTrain+1:end,:), model, '-b 1');
% % Accuracy = 93.3789% (35484/38000)
% % Accuracy = 94.3147% (32067/34000)
% % 
% % 
% 
% % % SPHOG data
% fprintf('SPHOG data\n');
% tic
% model = svmtrain(tr_labels(1:nTrain,:), tr_sphog_feats(1:nTrain,:), libsvm_options);
% display_elapsed_time
% % [pred accuracy dec_vals] = svmpredict(tr_labels(nTrain+1:end,:), tr_sphog_feats(nTrain+1:end,:), model, '-b 1');
% tic
% te_labels = zeros(length(te_feats),1);
% [pred accuracy dec_vals] = svmpredict(te_labels, te_sphog_feats, model, '-b 1');
% display_elapsed_time
% % 
% % Accuracy = 98.5538% (25624/26000)
% % Accuracy = 98.81% (9881/10000)
% % Accuracy = 98.857% (entire training set)
% % 
% 
% 
% % -------------------------------------------------------------------------
% % --- POLYNOMIAL ---
% fprintf('Training polynomial SVM model.\n');
% libsvm_options = '-s 0 -t 1 -d 3 -c 10 -b 1 -q';
% 
% fprintf('Using %d training samples\n',nTrain);
% 
% 
% % ORIGINAL data
% fprintf('Original Data\n');
% model = svmtrain(tr_labels(1:nTrain,:), tr_feats(1:nTrain,:), libsvm_options);
% [pred accuracy dec_vals] = svmpredict(tr_labels(nTrain+1:end,:), tr_feats(nTrain+1:end,:), model, '-b 1');
% % 
% % Accuracy = 95.2324% (32379/34000)
% 
% 
% % DESKEWED TRAINING data
% fprintf('Deskewed Data\n');
% tic
% model = svmtrain(tr_labels(1:nTrain,:), tr_feats_desk(1:nTrain,:), libsvm_options);
% display_elapsed_time
% tic
% [pred accuracy dec_vals] = svmpredict(tr_labels(nTrain+1:end,:), tr_feats_desk(nTrain+1:end,:), model, '-b 1');
% display_elapsed_time
% % Accuracy = 50.2553% (19097/38000)
% % Accuracy = 73.9794% (25153/34000)
% % Accuracy = 77.9719% (24951/32000)
% % Accuracy = 80.7556% (21804/27000)
% 
% 
% % NORMALIZED DESKEWED data
% fprintf('Deskewed Normalized Data\n');
% model = svmtrain(tr_labels(1:nTrain,:), tr_feats_desk_norm(1:nTrain,:), libsvm_options);
% [pred accuracy dec_vals] = svmpredict(tr_labels(nTrain+1:end,:), tr_feats_desk_norm(nTrain+1:end,:), model, '-b 1');
% % Accuracy = 11.1526% (4238/38000)


% % SPHOG data
% svm_sphog_dn_32k_poly3
%   Accuracy = 99.06% (9906/10000) 00:07:33
%   Elapsed time: 00:07:33


%% Display n misclassified digits

% Images{n,1} = [];
% Labels{n,1} = [];
% 
% n = 28;
% while i <= n
%     if pred(i) ~= tr_labels(i)
%         instance_vector = tr_feats_desk_norm(i,:);   % change the source vector
%         Image = vector_to_image(instance_vector);
%         
%         Images{i} = Image;
%         Labels{i} = [num2str(tr_labels(i)) ' -> ' num2str(pred(i))];
%     end
%     
% end
% 
% display_multiple_images(Images, Labels)


