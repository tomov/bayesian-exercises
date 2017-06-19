% Simulate a binomial distribution with a small p. Show that this is
% approximated by a Poisson distribution.
%
close all;

% binomial distribution
%
m = 10000; % # of samples to generate distribution
n = 1000; % # of yes/no experiments in each sample
p = 0.01; % prob of yes

x = rand(n, m) < p; % run the n x m yes/no experiments
y = sum(x); % get the # yes'es in each sample

figure;
h = histogram(y, 30); % plot the distribution of # yes'es

% convert to probability distribution (scale)
%
figure;
distr = h.Values / sum(h.Values);
binEdges = h.BinEdges;
binMids = (h.BinEdges(2:end) + h.BinEdges(1:end-1)) / 2;
binWidth = h.BinWidth;
plot(binMids, distr, 'o');

hold on;

% overlay poisson distribution
%
lambda = n * p;
poiss = poisspdf(round(binMids), lambda);
plot(binMids, poiss, '-');

hold off;