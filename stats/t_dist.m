mu = 0.342; % UNKNOWN
sigma = 0.4; % UNKNOWN

draw = @(n) normrnd(mu, sigma, n, 1);

x = draw(1000);




%{
draw1 = @(n) normrnd(0.342, 0.4, n, 1);
draw2 = @(n) normrnd(0.3, 0.4, n, 1);

sample1 = draw1(1000);
sample2 = draw2(1000);

figure;
h1 = histogram(sample1, 20);
hold on;
h2 = histogram(sample2, 20);
hold off;

%h1.Normalization = 'probability';
%h1.BinWidth = 0.25;
%h2.Normalization = 'probability';
%h2.BinWidth = 0.25;
%}