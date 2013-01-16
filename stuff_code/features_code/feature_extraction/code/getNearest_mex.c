#include "mex.h"

void mexFunction(int nlhs, mxArray *plhs[], int nrhs,
                 const mxArray *prhs[])
{
    int ndata;
    int nvars;
    int ncenters;
    double* data;
    double* centers;
    
    int argdims[2];
    int *idx;
    
    double dist, mindist, tmpdist;
    int minind;
    
    int i, j, k;
    
    if (nrhs != 5) {
      mexErrMsgTxt("Five inputs required: (int32)ndata (int32)nvars (int32)ncenters (double)data(nvars, ndata) (double)centers(nvars, ncenters)");
    } 
    
    ndata = (int)mxGetScalar(prhs[0]);
    nvars = (int)mxGetScalar(prhs[1]);
    ncenters = (int)mxGetScalar(prhs[2]);

    data = (double*)mxGetData(prhs[3]);
    centers = (double*)mxGetData(prhs[4]);
        
    
    argdims[0] = 1;
    argdims[1] = ndata;    
    plhs[0] = mxCreateNumericArray(2, argdims, mxINT32_CLASS, mxREAL);
    idx = (int*)mxGetPr(plhs[0]);
    for (i=0; i<ndata; i++) {
        minind = 0;  
        mindist = 0;
        for (j=0; j<ncenters; j++) {
            dist = 0;
            for (k=0; k<nvars; k++) {  
                tmpdist = (data[k+i*nvars]-centers[k+j*nvars]);
                dist = dist + tmpdist*tmpdist;
            }
            if (j==0 || dist < mindist) {
                mindist = dist;
                minind = j;
            }
        }
        idx[i] = minind+1;
    }
}

