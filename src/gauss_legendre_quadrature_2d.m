classdef gauss_legendre_quadrature_2d
    methods (Static)
        function [points, weights] = compute(N, a, b)
            [p1d, w1d] = lgwt(N, a, b);
            
            [py, px] = meshgrid(p1d, p1d);
            [wy, wx] = meshgrid(w1d, w1d);
            
            points = [px(:), py(:)];
            weights = wx(:) .* wy(:);
        end

    end
end