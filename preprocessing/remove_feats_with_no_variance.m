%% Remove features with 0 variance across instances
% For this data, features that are 0 for all instances


%% Initialization
clear; close all; clc

data_path = 'data/';


%% Load Data

data_filename = 'feats.mat';
load([data_path data_filename]);


%% Sum over columns

tr_col_sums = sum(tr_feats);
te_col_sums = sum(te_feats);

col_sums = tr_col_sums + te_col_sums;
num_of_non_zer_cols = nnz(col_sums);   % 719/784
zero_col_indices = find(col_sums == 0);


%% Remove feats that are always 0
% Initialize new feature matrices
tr_feats_nonzero = zeros(length(tr_feats),num_of_non_zer_cols);
te_feats_nonzero = zeros(length(te_feats),num_of_non_zer_cols);

nfeats = size(tr_feats,2);

z = 1;   % Iterator for zero_col_indices vector
for i = 1:nfeats
    if i == zero_col_indices(z)
       z = z + 1;
    else
%         fprintf('i: %d. z %d.  new_col: %d\n',[i z i-z+1]);
        tr_feats_min(:,i-z+1) = tr_feats(:,i);
        te_feats_min(:,i-z+1) = te_feats(:,i);
    end
end

r = length(zero_col_indices);   % Number of features removed
fprintf('Removed %d features (%.2f%%)\n',[r, r/nfeats*100]);
fprintf('Saving %d/%d features.\n',[num_of_non_zer_cols,nfeats]);

filename = 'feats_nonzero.mat';
save([data_path filename], 'tr_feats_nonzero','te_feats_nonzero');


