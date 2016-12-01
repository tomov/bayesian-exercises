% Bayesian inference for coin flips: Model selection
%
% Two hypotheses -- 1) coin is fair, 2) coin is unfair
% Note that h1 has multiple possible values of theta.
% Solve by computing marginal probability of d under h1 by integrating over theta
%

% Constants
%
dtheta = 0.01;

% Generative process
% flip coin; probability of getting heads is theta
%
theta = 0.5; % = P(heads)
N = 20;
d = rand(1, N) < theta; % sequence of coin flips
disp(d)

%
% Hypothesis space
%
h0 = struct;
h1 = struct;

h0.theta = 0.5; % candidate coin #1 is fair => specific theta
h1.theta_prior = @(theta) 1; % candidate coin #2 is unfair; have a uniform prior for theta p(theta | h1)

h0.prior = 0.5; % prior P(h0) -- both coins are equally likely
h1.prior = 0.5; % prior P(h1)

% theta likelihood = P(data | theta)
%
likelihood = @(d, theta) theta ^ sum(d) * (1 - theta) ^ (length(d) - sum(d));

% hypothesis likelihood = P(data | h)
%
h0.likelihood = @(d) likelihood(d, h0.theta); % the fair coin has only 1 theta
% the unfair coin can be any one of many thetas => we must marginalize d over
% theta to get P(d | h1)
h1.likelihood = @(d) sum(arrayfun(@(theta) likelihood(d, theta) * h1.theta_prior(theta) * dtheta, 0:dtheta:1));

fprintf('P(d | h0) = %e\n', h0.likelihood(d));
fprintf('P(d | h1) = %e\n', h1.likelihood(d));

H = {h0 h1}; % all hypotheses

%
% Compute the posteriors
%

% marginalize over h to find P(d)
%
marginalize = @(d) sum(cellfun(@(h) h.likelihood(d) * h.prior, H));

% posterior P(h | d)
%
posterior = @(h, d) h.likelihood(d) * h.prior / marginalize(d);

fprintf('P(h0 | d) = %e\n', posterior(h0, d));
fprintf('P(h1 | d) = %e\n', posterior(h1, d));

% log posterior odds in favor of h1 (biased coin)
%
fprintf('log P(h1 | d) / P(h0 | d) = %f\n', log(posterior(h0, d) / posterior(h1, d)));

% some plotting
% Figure 1 in http://cocosci.berkeley.edu/tom/papers/bayeschapter.pdf
%
thetas = 0:0.1:1;
lpos = [];
for theta = thetas
    N = 10;
    while true
        d = rand(1, N) < theta; % sequence of coin flips
        % make sure fraction of heads is same as theta
        % kinda lame but makes the plot pretty
        if abs(sum(d) / length(d) - theta) < 0.01
            break
        end
    end
    lpo = log(posterior(h1, d) / posterior(h0, d));
    lpos = [lpos lpo];
end

figure;
bar(thetas, lpos);
xlabel('\theta = P(heads)');
ylabel('log posterior odds in favor of h1 (biased coin)');