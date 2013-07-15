%% SVM - linear
% Examples of options: -s 0 -c 10 -t 1 -g 1 -r 1 -d 3 
% Classify a binary data with polynomial kernel (u'v+1)^3 and C = 10
% 
%  
% options:
% -s svm_type : set type of SVM (default 0)
% 	0 -- C-SVC
% 	1 -- nu-SVC
% 	2 -- one-class SVM
% 	3 -- epsilon-SVR
% 	4 -- nu-SVR
% -t kernel_type : set type of kernel function (default 2)
% 	0 -- linear: u'*v
% 	1 -- polynomial: (gamma*u'*v + coef0)^degree
% 	2 -- radial basis function: exp(-gamma*|u-v|^2)
% 	3 -- sigmoid: tanh(gamma*u'*v + coef0)
% -d degree : set degree in kernel function (default 3)
% -g gamma : set gamma in kernel function (default 1/num_features)
% -r coef0 : set coef0 in kernel function (default 0)
% -c cost : set the parameter C of C-SVC, epsilon-SVR, and nu-SVR (default 1)
% -n nu : set the parameter nu of nu-SVC, one-class SVM, and nu-SVR (default 0.5)
% -p epsilon : set the epsilon in loss function of epsilon-SVR (default 0.1)
% -m cachesize : set cache memory size in MB (default 100)
% -e epsilon : set tolerance of termination criterion (default 0.001)
% -h shrinking: whether to use the shrinking heuristics, 0 or 1 (default 1)
% -b probability_estimates: whether to train a SVC or SVR model for probability estimates, 0 or 1 (default 0)
% -wi weight: set the parameter C of class i to weight*C, for C-SVC (default 1)


%% Initialization
clear; close all; clc

addpath 'libsvm-3.12';


%% Load data files
load 'data/TrainData.mat';
load 'data/DeskewedTrainData.mat';
load 'data/TrainLabels.mat';
load 'data/TestData.mat';

%% Linear SVM on Original Data
n = 10000;   % Number of instances to use

libsvm_options = '-s 0 -t 0 -c 10 -b 1 -q';
% % Options from the 802 project
% svmoptions = ['-s 0 -t ', num2str(krnl_type), ' -d ', num2str(degree), ' -g 1 -r 1 -c 10 -b 1 -q'];

model = svmtrain(TrainLabels(1:n), TrainData(1:n,:), libsvm_options);
% model = svmtrain(TrainLabels, TrainData, svm_options);
save('models/lin_10k.mat', 'model')

test_labels = zeros(length(TestData),1);
[predicted_labels, accuracy, prob_estimates] = svmpredict(test_labels, TestData, model, '-b 1');










