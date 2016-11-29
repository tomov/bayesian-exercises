% Bayesian inference for coin flips
% Infinitely many hypotheses -- infer probability of heads for given coin
% using parameter estimation.
%
% Compare three methods:
% 1) maximum likelihood
% 2) maximum a posteriori (MAP)
% 3) posterior mean
%

% Generative process
% flip coin; probability of getting heads is theta
%
theta = 0.6; % = P(heads)
N = 20;
d = rand(1, N) < theta; % sequence of coin flips
disp(d)

% likelihood = P(data | theta)
%
likelihood = @(d, theta) theta ^ sum(d) * (1 - theta) ^ (length(d) - sum(d));

fprintf('P(d | 0.5) = %e\n', likelihood(d, 0.5));
fprintf('P(d | 0.3) = %e\n', likelihood(d, 0.3));

% prior = p(theta)
% note it's a PDF
%
prior = @(theta) 1; % uniform prior
%prior = @(theta) normpdf(theta, 0.5, 0.1); % alternative -- Gaussian prior around 0.5

fprintf('p(0.5) = %e\n', prior(0.5));
fprintf('p(0.3) = %e\n', prior(0.3));

% marginalize over theta to find P(d)
% note that p(theta) is a PDF => we "integrate" (numerically)
%
marginalize = @(d, dtheta) sum(arrayfun(@(theta) likelihood(d, theta) * prior(theta) * dtheta, 0:dtheta:1));
fprintf('P(d) = %e (dtheta = 0.01)\n', marginalize(d, 0.01));
fprintf('P(d) = %e (dtheta = 0.001)\n', marginalize(d, 0.001));
fprintf('P(d) = %e (dtheta = 0.0001)\n', marginalize(d, 0.0001));

% find the posterior p(theta | d)
% note it's a PDF
%
posterior = @(theta, d) likelihood(d, theta) * prior(theta) / marginalize(d, 0.01);

fprintf('p(0.5 | d) = %e\n', posterior(0.5, d));
fprintf('p(0.3 | d) = %e\n', posterior(0.3, d));

% Maximum likelihood to find best theta
%
theta_maxlik = fmincon(@(t) 1 / likelihood(d, t) , [0.5], [], [], [], [], [0], [1]);

fprintf('max likelihood theta = %e\n', theta_maxlik);

% Maximum a posteriori (MAP) to find best theta
%
theta_map = fmincon(@(t) 1 / posterior(t, d) , [0.5], [], [], [], [], [0], [1]);

fprintf('max a posteriori theta = %e\n', theta_map);

% Posterior mean to find best theta
%
posterior_mean = @(dtheta) sum(arrayfun(@(theta) theta * posterior(theta, d) * dtheta, 0:dtheta:1));
theta_postmean = posterior_mean(0.01);

fprintf('posterior mean theta = %e\n', theta_postmean);

% Sanity check
%
fprintf('heads / (heads + tails) = %e\n', sum(d) / length(d)); % for comparison
