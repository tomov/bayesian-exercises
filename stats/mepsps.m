% Poisson statistics of mEPSPs from Katz Sherringon lecture
% Neurobio 220
%

m = 2.33;

x = 0:10;

P = 198 * poisspdf(x, m);

figure;
bar(x, P);
xlabel('# of fusions');
ylabel('# of occurences');


P = 198 * poisspdf(x, m);

n = [];
xx = 0:0.01:10;
n = zeros(size(xx));
for i = 2:length(x)
    n = n + P(i) * 0.2 * normpdf(xx, x(i), sqrt((i-1) * 0.2^2));
end

figure;
plot(xx, n);
xlabel('Amplitude of end-plate potentials (units of single fusion potential)');
ylabel('# of occurences');
