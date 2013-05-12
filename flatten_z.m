function flat_z = flatten_z(z)
	flat_z = zeros(size(z, 3), size(z, 1) * size(z, 2));
	t = 1;
	for i = 1:size(z, 1)
		for j = 1:size(z, 2)
			flat_z(:, t) = z(i, j, :);
			t = t + 1;
		end;
	end;
