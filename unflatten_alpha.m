function alpha = unflatten_alpha(flat_alpha, z)
	alpha = zeros(size(z, 1), size(z, 2));
	t = 1;
	for i = 1:size(z, 1)
		for j = 1:size(z, 2)
			alpha(i, j) = flat_alpha(t);
			t = t + 1;
		end;
	end;
