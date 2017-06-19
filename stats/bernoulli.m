% Simulate a Bernoulli (binomial) distribution with coin flips
% Overlay the simulated result with an actual binomial and a Gaussian PDF
%

N = 20; % # flips
M = 100000; % # sequences of coins
theta = 0.5; % # P(heads)

heads = rand(N, M) < theta; % M sequences of N coin flips

% Histogram of how many heads in each sequence.
% Make sure to use N buckets, otherwise the overlay will be off
%
figure;
hist(sum(heads), N);
xlabel('# heads');
ylabel('# sequences');

% Binomial distribution
%
binomial = @(x) nchoosek(N, x) * theta^x * (1 - theta)^(N - x);

hold on;

% Overlay the actual binomial distribution, scaled by the # of sequences
%
x = 0:1:N;
plot(x, arrayfun(binomial, x) * M, 'o-', 'LineWidth', 3);

% Overlay with a Gaussain distribution with variance = N * theta * (1 - theta)
% scaled by # of sequences. The Gaussain PDF approximates the binomial
%
x = 0:0.01:N;
plot(x, normpdf(x, theta * N, sqrt(N * theta * (1 - theta))) * M, '-', 'LineWidth', 1);

hold off;
