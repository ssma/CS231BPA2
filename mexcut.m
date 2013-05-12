function alpha = mexcut()
  U = [inf,2;inf,4;5,inf]
  V = magic(3)
  alpha = mexEnergyMin(U,V)
  size(alpha),
