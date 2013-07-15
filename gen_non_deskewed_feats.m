
DATA_PATH = 'data/';

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


%% Normalize Data

filename = 'feats_norm.mat';

tic
fprintf('Normalizing training and testing features.');
fprintf('Saving results to: %s\n',filename);
tr_feats_norm = normalize_data(tr_feats, norm_type);
te_feats_norm = normalize_data(te_feats, norm_type);
save([DATA_PATH filename], 'tr_feats_norm','te_feats_norm');
display_elapsed_time


%% Compute SPHOG Features

filename = sprintf([DATA_PATH 'feats_sphog_%i_n.mat'], config.NORI);

% Compute SPHOG features from the deskewed normalized features
tic
data_var_name = 'tr_feats_norm';
fprintf('Computing SPHOG features for variable: %s\n',data_var_name);
tr_feats_sphog_n = compute_sphog_features(eval(data_var_name));
display_elapsed_time

tic
data_var_name = 'te_feats_norm';
fprintf('Computing SPHOG features for variable: %s\n',data_var_name);
te_feats_sphog_n = compute_sphog_features(eval(data_var_name));
display_elapsed_time

fprintf('Saving SPHOG features to: %s\n',filename);
save(filename,'tr_feats_sphog_n','te_feats_sphog_n');


%% SVM

% Common stuff
% ntrain = 4000;
% ntrain = 8000;
% ntrain = 16000;
% ntrain = 32000;
ntrain = 42000;

% -------------------------------------------------------------------------
% --- LINEAR ---
fprintf('Training linear SVM model.\n');
libsvm_options = '-s 0 -t o -d 3 -c 10 -q';

fprintf('Using %d training samples\n',ntrain);


% NORMALIZED SPHOG data
fprintf('SPHOG data\n');
tic
model = svmtrain(tr_labels(1:ntrain,:), tr_feats_sphog_n(1:ntrain,:), libsvm_options);
display_elapsed_time

tic
te_labels = zeros(length(te_feats_sphog_n),1);
[pred accuracy dec_vals] = svmpredict(te_labels, te_feats_sphog_n, model);
display_elapsed_time

out_filename = 'pred_sphog_not_deskewed_svm_linear.csv';
csvwrite(out_filename,pred);

