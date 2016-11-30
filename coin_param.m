% Bayesian inference for coin flips: Parameter estimation
%
% Infinitely many hypotheses -- infer probability of heads for given coin.
%
% Compare three methods:
% 1) maximum likelihood
% 2) maximum a posteriori (MAP)
% 3) posterior mean
%

% Some constants
%
dtheta = 0.01;

% Generative process
% flip coin; probability of getting heads is theta
%
theta = 0.9; % = P(heads)
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
%prior = @(theta) 1; % uniform prior
prior = @(theta) betapdf(theta, 10, 10); % alterantive -- conjugate prior: Beta distribution, as if we've seen 10 heads and 10 tails in the past

fprintf('p(0.5) = %e\n', prior(0.5));
fprintf('p(0.3) = %e\n', prior(0.3));

% marginalize over theta to find P(d)
% note that p(theta) is a PDF => we "integrate" (numerically)
%
marginalize = @(d) sum(arrayfun(@(theta) likelihood(d, theta) * prior(theta) * dtheta, 0:dtheta:1));
fprintf('P(d) = %e\n', marginalize(d));

% find the posterior p(theta | d)
% note it's a PDF
%
posterior = @(theta, d) likelihood(d, theta) * prior(theta) / marginalize(d);

fprintf('p(0.5 | d) = %e\n', posterior(0.5, d));
fprintf('p(0.3 | d) = %e\n', posterior(0.3, d));

% for comparison, the posterior should equal Beta(heads + 1, tails + 1)
% where Beta is the beta distribution.
% This is only in the case of a uniform prior p(theta) = 1
%
Beta_posterior = @(theta, d) betapdf(theta, sum(d) + 1, length(d) - sum(d) + 1);

fprintf('p(0.5) using Beta(heads + 1, tails + 1) = %e\n', Beta_posterior(0.5, d));
fprintf('p(0.3) using Beta(heads + 1, tails + 1) = %e\n', Beta_posterior(0.3, d));

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
theta_postmean = sum(arrayfun(@(theta) theta * posterior(theta, d) * dtheta, 0:dtheta:1));

fprintf('posterior mean theta = %e\n', theta_postmean);

% Sanity check
%
fprintf('heads / (heads + tails) = %e\n', sum(d) / length(d)); % for comparison

% Some plotting for prettyness
%

figure;
thetas = 0:0.01:1;

subplot(2, 2, 1);
plot(thetas, arrayfun(@(theta) prior(theta), thetas), 'LineWidth', 2);
xlabel('\theta');
ylabel('p(\theta)');
title('prior');

subplot(2, 2, 2);
plot(thetas, arrayfun(@(theta) likelihood(d, theta), thetas), 'LineWidth', 2);
xlabel('\theta');
ylabel('P(d | \theta)');
title('likelihood');

subplot(2, 2, 3);
plot(thetas, arrayfun(@(theta) posterior(theta, d), thetas), 'LineWidth', 2);
xlabel('\theta');
ylabel('p(\theta | d)');
title('posterior');

subplot(2, 2, 4);
bar([theta, sum(d) / length(d), theta_maxlik, theta_map, theta_postmean]);
set(gca, 'xticklabel', {'true \theta', 'N_H / N', 'max lik', 'MAP', 'post mean'});
ylabel('P(heads)');

flips = '';
for head = d
    if head
        flips = strcat(flips, 'H');
    else
        flips = strcat(flips, 'T');
    end
end
subtitle(['d = ', flips]);