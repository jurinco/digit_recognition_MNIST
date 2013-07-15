%% Plot data and eigenvalues
% http://www.cs.wits.ac.za/~michael/Lab8.html#One

% Create dataset
data = [linspace(0,1,100)', linspace(0,0.5,100)'];
data = awgn(data,30); % Add noise to SNR of 30

% Plot the original dataset
figure
plot(data(:,1), data(:,2), '.')
axis equal;

% Calculate covariance and eigenvalues
Covar = cov(data);
% Manually calculate the covariance
% data0 = bsxfun(@minus, data, mean(data));
% covar0 = 1/99 * data0' * data0;

[P E] = eig(Covar);

% Sort the eigenvalues and principal components in descending order
[e perm] = sort(diag(E),'descend'); % Sort eigenvalues and get the sorting permutation.
P = P(:,perm);

data0 = bsxfun(@minus, data, mean(data));

figure
plot(data0(:,1),data0(:,2),'b.');   % centered data
hold on;
plot([0 P(1,2)],[0 P(2,2)],'r-');   % first eigenvector
plot([0 P(1,1)],[0 P(2,1)],'g-');   % second eigenvector
axis equal;
hold off;


% Calculate how much of the variance is explained by each variable
100 * e ./ sum(e)


deskewed = data0 * P;
figure
plot(deskewed(:,1),deskewed(:,2),'r.');   % centered data
axis equal;



