% normalize_data()
% Normalize a matrix row-wise by dividing each element in a row by the norm
% of that row.
% 
% INPUTS
%   type: the type of norm to computer ('l1', 'l2')
%   D: matrix of data
% 
% OUTPUTS:
%   nD: matrix D with row-wise normalized data
% 
% This function is equivelent to calling the MATLAB function norm() on each
% row of the matrix,and then dividing each element in each row by the 
% result of norm().
% 
% nD(r,:) = D(r,:) ./ norm(D(r,:),p)
% where:
%   p=1 corresponds to the l1 (Manhattan) norm
%   p=2 corresponds to the l2 (Euclidean) norm
% 

function nD = normalize_data(D,type)
    if strcmpi(type,'l1') == 1
        row_sums = sum(D,2);
        % Normalize each row
        nD = zeros(size(D));
        for i = 1:size(D,1)
            nD(i,:) = D(i,:) ./ row_sums(i);
        end
    elseif strcmpi(type,'l2') == 1
        row_norms = sqrt(sum(D.^2,2));
        % Normalize each row
        nD = zeros(size(D));
        for i = 1:size(D,1)
            nD(i,:) = D(i,:) ./ row_norms(i);
        end
    end
end
