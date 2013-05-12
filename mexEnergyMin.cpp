#include "energy.h"
#include "mex.h"
#include "matrix.h"
#include "graph.h"
#include "graph.cpp"
#include "block.h"
#include "maxflow.cpp"
#include <vector>

/*
 * This program provides an interface with MATLAB for the Energy Minimization
 * step of the GrabCut algorithm. Its input weights are pre-calculated in
 * MATLAB, and then sent as inputs to here. It then uses the C++ implementation
 * of Energy Minimization to get the new labelings.
 * 
 * Inputs:
 * - U: A Nx2 matrix of D values. Left column is for alpha=0, right for alpha=1
 * - V: A Tx3 matrix.  Each row is of the form [i, j, w_{ij}].  If a row is not included, that means they're not connected.
 *
 * Outputs:
 * - alpha: A Nx1 matrix with alpha values.
 * - E: The E achieved by this minimization.
 */

void minimizeEnergy(double* U, double* V, int N, int T, double *alpha, double *E);

/*
 * Interface with MATLAB
 */
void mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[] )
{
  double *U, *V;
  double *alpha;
  double *E;
  int usize1,usize2,vsize1,vsize2;
  
  //Error check input/output sizes
  if (nrhs != 2) mexErrMsgTxt("ERROR: mexEnergyMin takes exactly 2 inputs.");
  
  U = mxGetPr(prhs[0]);
  V = mxGetPr(prhs[1]);
  
  usize1 = mxGetM(prhs[0]);
  usize2 = mxGetN(prhs[0]);
  vsize1 = mxGetM(prhs[1]);
  vsize2 = mxGetN(prhs[1]);
  
  //Error checks
  if (usize2 != 2) mexErrMsgTxt("ERROR: U must contain 2 columns.");
  if (vsize2 != 3) mexErrMsgTxt("ERROR: V must contain 3 columns.");
  
  //Output the labelings back to MATLAB
  assert(nlhs == 2);
  plhs[0] = mxCreateDoubleMatrix(usize1, 1, mxREAL);
  plhs[1] = mxCreateDoubleMatrix(1, 1, mxREAL);
  alpha = mxGetPr(plhs[0]);
  E = mxGetPr(plhs[1]);
  
  //Get the new labelings
  minimizeEnergy(U,V, usize1, vsize1, alpha, E);
}

/*
 * Determine the variables that will minimize the energy in
 * the equation.
 */
void minimizeEnergy(double* U, double* V, int N, int T, double *alpha, double *E)
{
  // initialization
  std::vector<Energy<float,float,float>::Var> vars(N);
  Energy<float,float,float> e(N,T);
  
  //Add nodes and unary terms
  mexPrintf("Adding Nodes and Unary Terms\n");
  for (int i=0;i<N;i++)
  {
    //Add node
    vars[i] = e.add_variable();
    //Add Unary term for that node
    e.add_term1(vars[i], U[i], U[N+i]);
  }
  
  //Add pairwise terms
  mexPrintf("Adding Pairwise Terms\n");
//  for (int i=0;i<N;i++)
//    for (int j=0;j<N;j++) 
//    {
//      e.add_term2(vars[i],vars[j],0,V[N*j+i],V[N*j+i],0);
//    }

  for (int t = 0; t < T; ++t) {
    int i = V[t] - 1;
    int j = V[T + t] - 1;
    double val = V[2 * T + t];
    e.add_term2(vars[i],vars[j],0,val,val,0);
  //Minimize the Energy
  }
  Energy<float,float,float>::TotalValue mnE = e.minimize();
  
  mexPrintf("Minimum Energy: %f\n",mnE);
  //Get new alphas
  for (int i=0;i<N;i++)
  {
    if (e.get_var(vars[i])) alpha[i] = 1;
    else alpha[i] = 0;
  }
  *E = (double)mnE;
}


