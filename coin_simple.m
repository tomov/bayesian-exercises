% Bayesian inference for coin flips: Comparing hypotheses
%
% Two simple hypotheses -- which one of two given coins is it?
% Compute posterior probability of each hypothesis given a sequence of coin
% flips
%

% Generative process
% flip coin; probability of getting heads is theta
%
theta = 0.9; % = P(heads)
N = 20;
d = rand(1, N) < theta; % sequence of coin flips
disp(d)

% Hypothesis space
%
h1 = struct;
h2 = struct;

h1.theta = 0.5; % candidate coin #1
h2.theta = 0.9; % candidate coin #2

h1.prior = 0.5; % prior P(h1) -- both coins are equally likely
h2.prior = 0.5; % prior P(h2)

H = [h1 h2]; % all hypotheses

% likelihood = P(data | hypothesis)
%
likelihood = @(d, h) h.theta ^ sum(d) * (1 - h.theta) ^ (length(d) - sum(d));

fprintf('P(d | h1) = %e\n', likelihood(d, h1));
fprintf('P(d | h2) = %e\n', likelihood(d, h2));

% prior = P(h)
%
prior = @(h) h.prior;
fprintf('P(h1) = %e\n', prior(h1));
fprintf('P(h2) = %e\n', prior(h2));

% marginalize over h to find P(d)
%
marginalize = @(d) sum(arrayfun(@(h) likelihood(d, h) * prior(h), H));
fprintf('P(d) = %e\n', marginalize(d));

% find the posterior P(h | d)
%
posterior = @(h, d) likelihood(d, h) * prior(h) / marginalize(d);

fprintf('P(h1 | d) = %e\n', posterior(h1, d));
fprintf('P(h2 | d) = %e\n', posterior(h2, d));