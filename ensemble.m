%% Initialization
clear; close all; clc

data_path = 'data/';
predictions_path = 'predictions/';


%% LOAD DATA
load([data_path 'tr_labels']);

% load([predictions_path 'svm_sphog_dn_42k_poly9.mat']);
load([predictions_path 'svm_sphog_dn_32k_poly9.mat']);
% load([predictions_path 'svm_sphog_dn_32k_model_n.mat']);
pred_1 = pred;
prob_1 = dec_vals;
acc_1 = accuracy(1);

% load([predictions_path 'svm_sphog_n_42k_poly9.mat']);
load([predictions_path 'svm_sphog_n_32k_poly9.mat']);
% load([predictions_path 'svm_sphog_n_32k_model_n.mat']);
pred_2 = pred;
prob_2 = dec_vals;
acc_2 = accuracy(1);

% Mapping of prob column to predicted class
mapping = [1 0 4 7 3 5 8 9 2 6];

nTest = length(pred_1);
nTrain = length(tr_labels) - nTest;
% nTrain = 42000;

actual_labels = tr_labels(nTrain+1:end);
clear 'tr_labels';

%% Calculate the difference in predictions of the models
similarity = nnz(pred_1 == pred_2) / nTest;
n_diff_predictions = (1 - similarity) * nTest;
fprintf('The models differ in %.0f predictions.\n', n_diff_predictions);

fprintf('model 1 accuracy: %.2f%%\n', acc_1);
fprintf('model 2 accuracy: %.2f%%\n', acc_2);

% fprintf('Potential improvement: .\n', );


%% 1. Use prediction with max probability across models
ensemble_prob = max(prob_1,prob_2);
[m indices] = max(ensemble_prob,[],2);

ensemble_pred_1 = zeros(nTest,1);
for i = 1:nTest
    ensemble_pred_1(i) = mapping(indices(i));
end

ensemble_accuracy = nnz(ensemble_pred_1 == actual_labels) / nTest * 100;
fprintf('max ensemble accuracy: %0.2f%%\n',ensemble_accuracy);

% pred_filename = ['ensemble_max_prob_2models_' num2str(nTrain/1000) 'k'];
% save([predictions_path pred_filename '.mat'], 'ensemble_pred');
% csvwrite([predictions_path pred_filename '.csv'], pred);


%% 2. Use the prediction with the max average probability.

% Average predictions across models
avg_prob = (prob_1 + prob_2) / 2;

% For each instance, get index of the max probability
[m indices] = max(avg_prob,[],2);

ensemble_pred_2 = zeros(nTest,1);
for i = 1:nTest
    ensemble_pred_2(i) = mapping(indices(i));
end

ensemble_accuracy = nnz(ensemble_pred_2 == actual_labels) / nTest * 100;
fprintf('mean ensemble accuracy: %0.2f%%\n',ensemble_accuracy);

% pred_filename = ['ensemble_mean_prob_2models_' num2str(nTrain/1000) 'k'];
% save([predictions_path pred_filename '.mat'], 'ensemble_pred');
% csvwrite([predictions_path pred_filename '.csv'], pred);


%% Calculate the difference in predictions of the ensemble models
similarity = nnz(ensemble_pred_1 == ensemble_pred_2) / nTest;
n_diff_predictions = (1 - similarity) * nTest;
fprintf('The ensembles differ in %.0f predictions.\n', n_diff_predictions);

fprintf('model 1 accuracy: %.2f%%\n', acc_1);
fprintf('model 2 accuracy: %.2f%%\n', acc_2);

% fprintf('Potential improvement: .\n', );


%% Display the images that are misclassified

% Display n Misclassified Digits Deskewed and Not Deskewed

% Load the data to be displayed
load([data_path 'feats_deskew_norm.mat']);
load([data_path 'feats.mat']);

misclassified_instance_indices = find(ensemble_pred_1 ~= actual_labels);
nMisclassified = length(misclassified_instance_indices);

n = 28;
Images = cell(n*2,1);
Labels = cell(n*2,1);

d = 0;   % Count of images to be displayed
i = 1;   % Iterator
while (d < n) && (d < nMisclassified)
    if pred(i) ~= actual_labels(i)
        d = d + 1;
        instance_vector = tr_feats_desk_norm(i+nTrain,:);
        Image = vector_to_image(instance_vector);
        
        Images{d*2-1} = Image;
        Labels{d*2-1} = [num2str(actual_labels(i)) ' -> ' num2str(pred(i))];
        
        instance_vector = tr_feats(i+nTrain,:);
        Image = vector_to_image(instance_vector);
        Images{d*2} = Image;
        Labels{d*2} = 'orig';
        Labels{d*2} = ;
    end
    i = i+1;
end

display_multiple_images(Images, Labels)


%% Predict across models
% Predict non-deskewed images on deskewed model
% Predict deskewed images on non-deskewed model
% Combine predictions

% a = [.5 .4 .3 .8; .5 .7 .1 .9; .4 .0 .1 .1];
% b = [.2 .1 .5 .6; .4 .6 .1 .0; .7 .0 .3 .1];
% c = (a + b) / 2;


%% Load the predictions with probabilities

% pred_filenames = {'svm_sphog_dn_32k_poly9_pred.mat','svm_sphog_n_32k_poly9_pred.mat'};
% 
% nModels = length(pred_filenames);



%% RESULTS
% The models differ in 42 predictions.
% model 1 accuracy: 99.22%
% model 2 accuracy: 99.25%
% max ensemble accuracy: 99.30%
% mean ensemble accuracy: 99.31%

