% simple PCA exercise
%
close all;

%% generate some 2D data
% imagine you recorded data from P = 2 neurons on N trials
% x = firing rate of neuron 1
% y = firing rate of neuron 2
% each row = another trial
% each col = firing rate of given neuron across all trials
% say this data is in "firing rate" (FR) space
%
N = 10;
P = 2;

x = 1:N;
y = x * 4 + 40 + rand(1,N);
x = x + rand(1,10) * 5;
X = [x' y'];

X = X - mean(X); % center data -- this is important; PC space has same origin as FR-space

figure;
imagesc(X);

figure;
scatter(X(:,1), X(:,2));

%% run PCA & plot PCs over data in FR space
%
[coef, score] = pca(X);

pc1 = coef(1, :); % first principal component (PC1) i.e. "eigenneuron" = linear combo of other neurons s.t. most variance is captured i.e. it's most descriptive of the data set
pc2 = coef(2, :); % second principal componenet (PC2) 

% plot PC1
line([-pc1(1) pc1(1)] * 25, [-pc1(2) pc1(2)] * 25, 'Color','red','LineStyle','--');

% plot PC2
line([-pc2(1) pc2(1)] * 25, [-pc2(2) pc2(2)] * 25, 'Color','red','LineStyle','--');

title('FR space');

%% plot "rotated" data & PCs in PC space
%
figure;
scatter(score(:,1), score(:,2));

line([-1 1] * 25, [0 0] * 25, 'Color','red','LineStyle','--'); % PC1
line([0 0] * 25, [-1 1] * 25, 'Color','red','LineStyle','--'); % PC2

title('PC space');

%% "restore" complete data using all PCs
%
proj = score * coef;
figure;
scatter(proj(:,1), proj(:,2));

title('data restored from PCs in FR space (i.e. all info preserved)');

%% "restore" data using PC1 only (i.e. 'compressed' data)
%
proj = score(:,1) * coef(1, :);
figure;
scatter(proj(:,1), proj(:,2));

title('data restored from PC1 in FR space (i.e. some data is lost)');