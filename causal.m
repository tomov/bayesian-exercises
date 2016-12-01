% Causal induction from contingency data
% Given a potential cause c and an effect e and the correlation between
% them (i.e. given # of occurences of (e+|c+), (e-|c+), (e+|c-), (e-|c-),
% infer whether c causes e.
% 
% Basically does a model comparison -- a bayes net that has a c->e edge vs.
% one that does not (and only has a edge from background noise b->e).
%


% counts for e+c+, e-c+, e+c-, e-c-
% Table 1 from http://cocosci.berkeley.edu/tom/papers/bayeschapter.pdf
%
d = [0 8 0 8];

dw0 = 0.01;
dw1 = 0.01;

noisy_OR = @(b, c, w0, w1) 1 - (1 - w0)^b * (1 - w1)^c;
% linear = @(b, c, w0, w1) w0 * b + w1 * c; % marginalization doesn't work b/c we need 0 <= w0 + w1 <= 1

parametrization = noisy_OR;

g0 = struct;
g1 = struct;

g0.prior = 0.5;
g1.prior = 0.5;

% P(d | w0, Graph 0) = P(e+)^(# of e+c+ and e+c-) + P(e-)^(# of e-c+ and e-c-)
% where P(e+) = P(e+ | b+) * P(b+) + P(e+ | b-) * P(b-) from marginalization / sum rule; ditto for P(e-)
% BUT... P(b+) = 1 and P(b-) = 0 ! (background noise is always present)
% => P(e+) = P(e+ | b+) = w0   P(e-) = P(e- | b+) = 1 - w0
%
g0.P_d_given_w0 = @(d, w0) w0 ^ (d(1) + d(3)) * (1 - w0) ^ (d(2) + d(4));

% P(d | w0, w1, Graph 1) = ...
% also don't forget P(b+) = 1
%
g1.P_d_given_w0_w1 = @(d, w0, w1) ...
                     parametrization(1, 1, w0, w1) ^ d(1) * ...  % e+c+
                (1 - parametrization(1, 1, w0, w1)) ^ d(2) * ... % e-c+
                     parametrization(1, 0, w0, w1) ^ d(3) * ...  % e+c-
                (1 - parametrization(1, 0, w0, w1)) ^ d(4);      % e-c-


% P(d | Graph 0) = integral P(d | w0, Graph 0) * P(Graph 0) * dw0
% assumes uniform pdf for w0
%
g0.likelihood = @(d) sum(arrayfun(@(w0) g0.P_d_given_w0(d, w0) * g0.prior * dw0, 0:dw0:1));

% P(d | Graph 1) = integral P(d | w0, w1, Graph 1) * P(Graph 1) * dw0 * dw1
% assumes uniform independent pdfs for w0 and w1
%
g1.likelihood = @(d) sum(arrayfun(@(w0) sum(arrayfun(@(w1) g1.P_d_given_w0_w1(d, w0, w1) * g1.prior * dw0 * dw1, 0:dw1:1)), 0:dw0:1));

fprintf('P(d | Graph 0) = %e\n', g0.likelihood(d));
fprintf('P(d | Graph 1) = %e\n', g1.likelihood(d));

% causal support for g1 over g0
support = @(d) log(g1.likelihood(d) / g0.likelihood(d));

fprintf('support for Graph 1 over Graph 0 = %f\n', support(d));

%
% Do some plotting
%

% each row = counts for e+c+ e-c+ e+c- e-c- 
cases = [8 0 8 0; ...
         6 2 6 2; ...
         4 4 4 4; ...
         2 6 2 6; ...
         0 8 0 8; ...
         8 0 6 2; ...
         6 2 4 4; ...
         4 4 2 6; ...
         2 6 0 8; ...
         8 0 4 4; ...
         6 2 2 6; ...
         4 4 0 8; ...
         8 0 2 6; ...
         6 2 0 8; ...
         8 0 0 8];
    
% Compute & slot causal support for each case
% Figure 4 in http://cocosci.berkeley.edu/tom/papers/bayeschapter.pdf
%
s = [];
labels = {};
for i = 1:size(cases, 1)
    d = cases(i, :);
    assert(sum(d) == 16);
    s = [s support(d)];
    labels = [labels, sprintf('%d/%d,%d/%d', d(1), d(1) + d(2), d(3), d(3) + d(4))];
end

figure;
bar(s - min(s) + 1);
set(gca, 'xticklabel', labels);
ylabel('support = P(d | Graph 1) / P(d | Graph 0)');