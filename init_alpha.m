function [flat_alpha, U_infinitizer] = init_alpha(z, bbox)
	U_infinitizer = zeros(length(flat_alpha), 2);
	flat_alpha = zeros(1, size(z, 1) * size(z, 2));
	t = 1;
	xmin = bbox(1);
	ymin = bbox(2);
	xmax = bbox(3);
	ymax = bbox(4);
	for i = 1:size(z, 1)
		for j = 1:size(z, 2)
			if i < ymin || i >= ymax || j < xmin || j >= xmax
				flat_alpha(t) = 0;
				U_infinitizer(t, 2) = inf;
			else
				flat_alpha(t) = 1;
			end;
			t = t + 1;
		end;
	end;
