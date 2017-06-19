% Multiple Phosphorylation Sites Confer Reproducibility of the Rod?s Single-Photon Responses
%
% the coefficient of variation (CV = standard deviation/mean) for
% rhodopsin?s integrated activity is 1= sqrt N for N independent steps that 
% each control an equal  fraction of rhodopsin?s integrated catalytic activity

cvs = [];
ns = 1:20;
S = 100; % number of single-photon absorbtion trials

for N = ns % number of phosphorylation sites
    x = normrnd(10, 10, N, S); % S single-photon absorbtion trials, each with N phosphorylations
    s = sum(x, 1); % time for each response = sum of time for each of its N phosphorylation
    CV = std(s) / mean(s); % coefficient of variance for single-photon response times
    cvs = [cvs CV];
end

figure;
plot(ns, cvs, 'o');
hold on;
plot(ns, 1 ./ sqrt(ns));
hold off;

