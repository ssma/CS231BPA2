function alpha = mexcut()
  U = [inf,2;inf,4;5,inf]
  VV = magic(3)
  V = zeros(9, 3);
  t = 1;
  for i = 1:3
	for j = 1:3
		V(t, 1) = i;
		V(t, 2) = j;
		V(t, 3) = VV(i, j);
		t = t + 1;
	end;
  end;
  [alpha, E] = mexEnergyMin(U,V)
  size(alpha),
  E,
