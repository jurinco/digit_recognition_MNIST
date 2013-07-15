%% Load the Traning and Testing Data
% 
%  1. Load the traning and testing data from the original csv files
%  2. Save the testing and training data as .m files
% 

%% 1. Load the data from csv files

% Load train data
original_train_data_path = [ORIGINAL_DATA_PATH 'train.csv'];
fprintf('Loading training data from: %s\n',original_train_data_path)

tr_feats = csvread(original_train_data_path,1,0);
tr_labels = tr_feats(:,1);
tr_feats = tr_feats(:,2:end);   % The first row is pixel labels

% Load test data
original_test_data_path = [ORIGINAL_DATA_PATH, 'test.csv'];
fprintf('Loading testing data from: %s\n',original_test_data_path)

te_feats = csvread(original_test_data_path,1,0);


%% 2. Save the data as .m files

% fprintf('Saving data files to:\n%s\n\n', DATA_PATH);

save([DATA_PATH 'feats'],'tr_feats','te_feats');
save([DATA_PATH 'tr_labels'],'tr_labels');
