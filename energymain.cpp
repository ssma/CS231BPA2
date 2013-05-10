#include <stdio.h>
#include "graph.h"
#include "graph.cpp"
#include "block.h"
#include "maxflow.cpp"

//int main()
//{
//	typedef Graph<int,int,int> GraphType;
//	GraphType *g = new GraphType(/*estimated # of nodes*/ 2, /*estimated # of edges*/ 1); 

//	g -> add_node(); 
//	g -> add_node(); 

//	g -> add_tweights( 0,   /* capacities */  1, 5 );
//	g -> add_tweights( 1,   /* capacities */  2, 6 );
//	g -> add_edge( 0, 1,    /* capacities */  3, 4 );

//	int flow = g -> maxflow();

//	printf("Flow = %d\n", flow);
//	printf("Minimum cut:\n");
//	if (g->what_segment(0) == GraphType::SOURCE)
//		printf("node0 is in the SOURCE set\n");
//	else
//		printf("node0 is in the SINK set\n");
//	if (g->what_segment(1) == GraphType::SOURCE)
//		printf("node1 is in the SOURCE set\n");
//	else
//		printf("node1 is in the SINK set\n");

//	delete g;

//	return 0;
//}

#include "energy.h"

int main()
{
	// Minimize the following function of 3 binary variables:
	// E(x, y, z) = x - 2*y + 3*(1-z) - 4*x*y + 5*|y-z|
	   
	Energy<float,float,float>::Var varx, vary, varz;
	Energy<float,float,float> *e = new Energy<float,float,float>(3,2);
	varx = e -> add_variable();
	vary = e -> add_variable();
	varz = e -> add_variable();
	e -> add_term1(varx, 0, 1);  // add term x 
	e -> add_term1(vary, 0, -2); // add term -2*y
	e -> add_term1(varz, 3, 0);  // add term 3*(1-z)
	e -> add_term2(varx, vary, 0, 0, 0, -4); // add term -4*x*y
	e -> add_term2(vary, varz, 0, 5, 5, 0); // add term 5*|y-z|

	Energy<float,float,float>::TotalValue Emin = e -> minimize();
	
	printf("Minimum = %f\n", Emin);
	printf("Optimal solution:\n");
	printf("x = %d\n", e->get_var(varx));
	printf("y = %d\n", e->get_var(vary));
	printf("z = %d\n", e->get_var(varz));
	delete e;
	
	return 0;
}


