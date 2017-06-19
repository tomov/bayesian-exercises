% n distinguishable balls, k distinguishable boxes
% balls randomly placed into boxes
% => find the expected number of empty boxes
%
% Problem 4 from HW 4 from STAT 110
% http://projects.iq.harvard.edu/stat110/strategic-practice-problems
%

clear;

n = 2; % boxes
k = 3; % balls

% ---------------- Solution #1: the easy way ------------------

% E(empty boxes)
%
% Using indicator variables
% I_j = 1 if box_j is empty, 0 if it has > 0 balls
% E(I_j) = P(box_j is empty) = (n-1)^k / n^k
% E(# empty boxes) = E (sum I_j) = sum E(I_j) = n * (n-1)^k / n^k
%
E_empty_boxes_closed_form = @(n, k) (n - 1)^k / n^(k - 1);

% ---------------- Solution #2: the hard way --------------------

% box1 = box1 has > 0 balls; -box1 = box1 has 0 balls
% #(-box1 or -box2 or -box3 ... or -box4) =
% = sum j=1..m: (m-j)^k (m choose j) (-1)^(j-1)
%
% this is the term for a given j (or multiple j's), i.e.
% +/- #(-box1 or -box2 or ... or -boxj) ... for all j-tuples of boxes
% 
%
incl_excl_j_boxes = @(m, k, j) (m - j).^k .* arrayfun(@(j) nchoosek(m, j), j) .* (-1).^(j - 1);

% m boxes, k balls
% # of ways to have at least 1 empty box
% = # of ways to have (-box1 or -box2 or -box3 ... or -box_m)
% => use inclusion exclusion (see above)
%
at_least_one_empty_box = @(m, k) sum(incl_excl_j_boxes(m, k, 1:m));

% m boxes (m = n-x below), k balls
% # of ways to have no empty boxes (i.e. at least 1 ball in each box)
%
no_empty_box = @(m, k) m^k - at_least_one_empty_box(m, k);

% n boxes, k balls
% # of ways to have exactly x empty boxes
% => pick which x boxes are empty; the rest n-x need to have at least 1 ball
%
exactly_x_empty_boxes = @(n, k, x) nchoosek(n, x) * no_empty_box(n - x, k);

% same but as a probability
%
P_exactly_x_empty_boxes = @(n, k, x) exactly_x_empty_boxes(n, k, x) / n^k;

% E(empty boxes)
% = sum x * P(x empty boxes)
%
E_empty_boxes = @(n, k) sum(arrayfun(@(x) x * P_exactly_x_empty_boxes(n, k, x), 0:n));

% sanity check
%
for n=1:10,
    for k=1:10
        ans1 = E_empty_boxes_closed_form(n, k);
        ans2 = E_empty_boxes(n, k);
        fprintf('n = %d, k = %d, ans1 = %f, ans2 = %d\n', n, k, ans1, ans2);
        assert(abs(ans1 - ans2) < 1e-9);
    end
end

