%% Initialization
clear; close all; clc

global config;
config.LIBSVM_t    = 1;                % kernal type
config.LIBSVM_c    = 10;               % C parameter for SVM
config.LIBSVM_d    = 9;                % LIBSVM poly degree
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
addpath 'classifiers/models'
addpath 'predictions'

data_path = 'data/';
original_data_path = 'data/original_data/';
models_path = 'classifiers/models/';
predictions_path = 'predictions/';

%% Load Data

% data_filename = 'feats_sphog_12_n.mat';
% model_filename = 'svm_sphog_n_42k_poly9.mat';
% pred_filename = 'svm_sphog_n_42k_poly9_pred.mat';

data_filename = 'feats_nonzero.mat';
model_filename = 'svm_feats_nonzero_dn_32k_poly9.mat';
pred_filename = 'svm_sphog_nonzero_dn_32k_poly9_pred.mat';

load 'tr_labels';
load([data_path data_filename]);


%% Setup variables

nInstances = length(tr_labels);   % 42,000
nTrain = 32000;
nTest = nInstances - nTrain;

tr_instances = tr_feats_sphog_n(1:nTrain,:);
tr_instances = tr_feats_sphog_n(1:nTrain,:);

%% Train SVM

% load([models_path model_filename]);

t = num2str(config.LIBSVM_t);
d = num2str(config.LIBSVM_d);
g = num2str(config.LIBSVM_g);
r = num2str(config.LIBSVM_r);
c = num2str(config.LIBSVM_c);

libsvm_options = ['-s 0 -t ' t ' -d ' d ' -g ' g ' -r ' r ' -c ' c ' -b 1 -q']

fprintf('Training degree %s polynomial SVM model.\n',d);
fprintf('Using %d training samples\n',nTrain);

tic
model = svmtrain(tr_labels(1:nTrain,:), tr_feats_sphog_n(1:nTrain,:), libsvm_options);
display_elapsed_time

save([models_path model_filename], 'model');


%% Predict

tic
if nTrain < nInstances
    fprintf('Predicting labels for the last %d training instances.\n',nTest);
    
    [pred accuracy dec_vals] = svmpredict(tr_labels(nTrain+1:end,:), tr_feats_sphog_n(nTrain+1:end,:), model, '-b 1');
else
    fprintf('Predicting labels for the test data.\n');
    te_labels = zeros(length(te_feats_sphog_n),1);
    
    [pred accuracy dec_vals] = svmpredict(te_labels, te_feats_sphog_n, model, '-b 1');
    
%     % Save predictions
%     csvwrite([predictions_path pred_filename '.csv'], pred);
end
save([predictions_path pred_filename], 'pred','accuracy','dec_vals');
display_elapsed_time


%% Outputs

% -s 0 -t 1 -d 3 -g 1 -r 1 -c 10 -b 0 -q
% 
% Training degree 3 polynomial SVM model.
% Using 32000 training samples
% Elapsed time: XX:XX:XX
% 
% Predicting labels for the test data.
% Accuracy = 99.06% (9906/10000) (classification)
% Elapsed time: 00:07:33


% -s 0 -t 1 -d 4 -g 1 -r 1 -c 10 -b 0 -q
% 
% Training degree 4 polynomial SVM model.
% Using 32000 training samples
% Elapsed time: 00:09:01
% 
% Predicting labels for the test data.
% Accuracy = 99.18% (9918/10000) (classification)
% Elapsed time: 00:08:38

% dn
% -s 0 -t 1 -d 4 -g 1 -r 1 -c 10 -b 1 -q
% 
% Training degree 4 polynomial SVM model.
% Using 32000 training samples
% Elapsed time: 00:50:31
% 
% Predicting labels for the 10000 last training instances.
% Accuracy = 99.18% (9918/10000) (classification)
% Elapsed time: 00:07:23


% -s 0 -t 1 -d 5 -g 1 -r 1 -c 10 -b 0 -q
% 
% Training degree 5 polynomial SVM model.
% Using 32000 training samples
% Elapsed time: 00:10:03
% 
% Predicting labels for the test data.
% Accuracy = 99.21% (9921/10000) (classification)
% Elapsed time: 00:07:45


% -s 0 -t 1 -d 6 -g 1 -r 1 -c 10 -b 0 -q
% 
% Training degree 6 polynomial SVM model.
% Using 32000 training samples
% Elapsed time: 00:11:11
% 
% Predicting labels for the test data.
% Accuracy = 99.18% (9918/10000) (classification)
% Elapsed time: 00:08:09


% -s 0 -t 1 -d 7 -g 1 -r 1 -c 10 -b 0 -q
% 
% Training degree 7 polynomial SVM model.
% Using 32000 training samples
% Elapsed time: 00:12:48
% 
% Predicting labels for the test data.
% Accuracy = 99.16% (9916/10000) (classification)
% Elapsed time: 00:09:03


% -s 0 -t 1 -d 8 -g 1 -r 1 -c 10 -b 0 -q
% 
% Training degree 8 polynomial SVM model.
% Using 32000 training samples
% Elapsed time: 00:14:18
% 
% Predicting labels for the test data.
% Accuracy = 99.19% (9919/10000) (classification)
% Elapsed time: 00:09:10


% -s 0 -t 1 -d 9 -g 1 -r 1 -c 10 -b 0 -q
% 
% Training degree 9 polynomial SVM model.
% Using 32000 training samples
% Elapsed time: 00:16:04
% 
% Predicting labels for the test data.
% Accuracy = 99.21% (9921/10000) (classification)
% Elapsed time: 00:09:39

% dn

% n
% -s 0 -t 1 -d 9 -g 1 -r 1 -c 10 -b 1 -q
% 
% Training degree 9 polynomial SVM model.
% Using 42000 training samples
% Elapsed time: 02:24:57
% 
% Predicting labels for the test data.
% Model supports probability estimates, but disabled in predicton.
% Accuracy = 9.89286% (2770/28000) (classification)
% Elapsed time: 00:32:55
