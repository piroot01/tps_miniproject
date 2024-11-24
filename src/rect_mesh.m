classdef rect_mesh
    properties (Access = private)
        % patch count in the x direction
        m_;
        % patch count in the y dir
        n_;
        % width of the patch
        a_;
        % height of the patch
        b_;
    end
    
    methods
        function obj = rect_mesh(m, n, a, b)
            obj.m_ = m;
            obj.n_ = n;
            obj.a_ = a;
            obj.b_ = b;
        end
    end

    methods
        function coords = vertex_coords(obj)
            [vx, vy] = ndgrid(0:obj.m_, 0:obj.n_);
            coords = [vx(:) .* obj.a_, vy(:) .* obj.b_];
        end
                
        function idx = vertex_idx(obj)
            [y, x] = meshgrid(1:obj.n_, 1:obj.m_);
            
            x = x(:);
            y = flipud(y);
            y = y(:);
            
            v1 = (obj.m_ + 1) * (y - 1) + x;
            v2 = v1 + 1;
            v3 = v1 + obj.m_ + 2;
            v4 = v1 + obj.m_ + 1;
            
            idx = [v1, v2, v3, v4];
        end

        function idx = patch_idx(obj)
            idx = (1:(obj.m_ * obj.n_));
        end

        function coords = patch_centers_coords(obj)
            xc = (0:(obj.m_ - 1)) * obj.a_ + obj.a_ / 2;
            yc = (0:(obj.n_ - 1)) * obj.b_ + obj.b_ / 2;

            [x, y] = ndgrid(xc, yc);
            coords = [x(:), y(:)];
        end
    end
end
