%% tps_miniproject main.m
clc; clearvars; close all;

addpath('~/Documents/MATLAB/matlab2tikz-master/src/');

m = 10;
n = 10;
a = 0.1;
b = 0.1;

plate_mesh = rect_mesh(m, n, a, b);

patch_indices = plate_mesh.patch_idx();
vertex_indices = plate_mesh.vertex_idx();
vertex_coordinates = plate_mesh.vertex_coords();
patch_center_coordinates = plate_mesh.patch_centers_coords();

quadrature_order = 4;

[p, w] = gauss_legendre_quadrature_2d.compute(quadrature_order, 0, 1);

% coordinate transformation
T = @(r, s, v) (1 - r - s) .* v(1, :) + r .* v(2, :) + s .* v(4, :);

% core of the Jacobian matrix of the transformation
J = [-1, 1, 0, 0; -1, 0, 0, 1];

integrand = @(x, y, xm, ym) 1 ./ (sqrt((xm - x).^2 + (ym - y).^2));

% singular integral
function result = singular_integral(a, b)
    result = 2 * (b * log((a + sqrt(a^2 + b^2)) / b) ...
                + a * log((b + sqrt(a^2 + b^2)) / a));
end

tic;

singularity_value = singular_integral(a, b);

M = zeros(length(patch_indices));

for r = patch_indices
    region = vertex_coordinates(vertex_indices(r, :), :);
    jacobian = abs(det(J * region));

    for s = patch_indices

        if (r == s)
            M(r, s) = singularity_value;
        else
            cm = patch_center_coordinates(s, :);
            p_transformed = T(p(:, 1), p(:, 2), region);
            M(r, s) = (w' * integrand(p_transformed(:, 1), ...
                p_transformed(:, 2), cm(1), cm(2))) * jacobian;
        end
    end
end

toc;

tic;

e0 = 8.854187e-12;
M = M ./ (4 * pi * e0);

M_inv = inv(M);
S = ones(length(patch_indices), 1) * (a * b);
C = M_inv * S;
C = flipud(reshape(C, m, n));

x = linspace(0, n * a, n + 1);
y = linspace(0, m * b, m + 1);
[X, Y] = meshgrid(x, y);
Z = repmat(C, 2, 2) * 10^12;

figure('Name','Potential Distribution');
s = surf(X(1:m, 1:n), Y(1:m, 1:n), Z(1:m, 1:n));
xlabel('x');
ylabel('y');
zlabel('pC');
s.EdgeColor = 'black';
s.FaceColor = 'white';
s.LineWidth = 3;
ax = gca;
ax.Color = 'none';
toc;

