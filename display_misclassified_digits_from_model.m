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

DATA_PATH = 'data/';
ORIGINAL_DATA_PATH = 'data/original_data/';
MODELS_PATH = 'classifiers/models/';

%% Load Data

load('tr_labels');

filename = sprintf([DATA_PATH 'feats_sphog_%i_dn.mat'], config.NORI);
load(filename);


%% Load Model
nInstances = length(tr_labels);   % 42,000
nTrain = 32000;
nTest = length(tr_labels) - nTrain;

load('svm_sphog_dn_32k_poly9');


%% Predict on Validation Set

val_feats = tr_feats_sphog_dn(nTrain+1:end,:);
val_labels = tr_labels(nTrain+1:end,:);

tic
[pred accuracy dec_vals] = svmpredict(val_labels, val_feats, model);
display_elapsed_time


%% Display n Misclassified Digits

% Load the data to be displayed
load 'feats_deskew_norm.mat';

nMisclassified = accuracy(1) * nTest;

n = 4;
Images = cell(n,1);
Labels = cell(n,1);

d = 0;   % Count of images to be displayed
i = 1;   % Iterator
while (d < n) && (d < nMisclassified)
    if pred(i) ~= val_labels(i)
        d = d + 1;
        disp(i+nTrain);
        instance_vector = tr_feats_desk_norm(i+nTrain,:);
        Image = vector_to_image(instance_vector);
        
        Images{d} = Image;
        Labels{d} = [num2str(val_labels(i)) ' -> ' num2str(pred(i))];
    end
    i = i+1;
end

display_multiple_images(Images, Labels)


%% Display n Misclassified Digits Deskewed and Not Deskewed

% Load the data to be displayed
load 'feats_deskew_norm.mat';
load 'feats.mat';

nMisclassified = accuracy(1) * nTest;

% n = 28;
n = 21;
Images = cell(n*2,1);
Labels = cell(n*2,1);

d = 0;   % Count of images to be displayed
i = 1;   % Iterator
while (d < n) && (d < nMisclassified)
    if pred(i) ~= val_labels(i)
        d = d + 1;
        instance_vector = tr_feats_desk_norm(i+nTrain,:);
        Image = vector_to_image(instance_vector);
        
        Images{d*2-1} = Image;
        Labels{d*2-1} = [num2str(val_labels(i)) ' -> ' num2str(pred(i))];
        
        instance_vector = tr_feats(i+nTrain,:);
        Image = vector_to_image(instance_vector);
        Images{d*2} = Image;
        Labels{d*2} = 'orig';
    end
    i = i+1;
end

display_multiple_images(Images, Labels)
