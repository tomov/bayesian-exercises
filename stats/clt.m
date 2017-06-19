% Central limit theorem demonstration
%
% Draw s samples of size n from some distribution.
% Then plot a histogram of their means to show that it's a Gaussian.
%

% draw a sample of size n from some distribution
%
%draw = @(n) unifrnd(0, 1, n, 1); % uniform random between 0 and 1
draw = @(n) betarnd(0.4, 0.3, n, 1); % beta distribution with A = 0.4, B = 0.3

n = 40; % sample size
s = 1000; % # of samples

samples = zeros(n, s);
for i = 1:s
    samples(:, i) = draw(n);
end

figure;
hold on;

hist(mean(samples));

% the constants are totally made up
% this is just to make the point that it's a gaussian
plot(0:0.01:1, 30 * normpdf(0:0.01:1, 0.57, 0.05));

hold off;

