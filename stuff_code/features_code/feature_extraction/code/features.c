#include <math.h>
#include "mex.h"

#define eps 0.0001

double uu[9] = {1.0000, 
		0.9397, 
		0.7660, 
		0.500, 
		0.1736, 
		-0.1736, 
		-0.5000, 
		-0.7660, 
		-0.9397};
double vv[9] = {0.0000, 
		0.3420, 
		0.6428, 
		0.8660, 
		0.9848, 
		0.9848, 
		0.8660, 
		0.6428, 
		0.3420};

double min(double x, double y) {
  if (x <= y)
    return x;
  else
    return y;
}

mxArray *process(const mxArray *image_ptr, const mxArray *sbin_ptr) {
  int ndim;
  const int *dims;
  ndim = mxGetNumberOfDimensions(image_ptr);
  dims = mxGetDimensions(image_ptr);
  if (ndim != 3 || dims[2] != 3)
    mexErrMsgTxt("Invalid input.");
  double *im = mxGetPr(image_ptr);
  int sbin = (int)mxGetScalar(sbin_ptr);

  int blocks[2];
  blocks[0] = dims[0]/sbin;
  blocks[1] = dims[1]/sbin;
  double *hist = mxCalloc(blocks[0]*blocks[1]*9, sizeof(double));
  double *norm = mxCalloc(blocks[0]*blocks[1], sizeof(double));

  int out[3];
  out[0] = blocks[0]-2;
  out[1] = blocks[1]-2;
  out[2] = 4*9;
  mxArray *feat_ptr = mxCreateNumericArray(3, out, mxDOUBLE_CLASS, mxREAL);
  double *feat = mxGetPr(feat_ptr);
  
  int visible[2];
  visible[0] = blocks[0]*sbin;
  visible[1] = blocks[1]*sbin;
  
  int x, y;
  for (x = 1; x < visible[1]-1; x++) {
    for (y = 1; y < visible[0]-1; y++) {
      /* first color channel */
      double *s = im + x*dims[0] + y;
      double dy = *(s+1) - *(s-1);
      double dx = *(s+dims[0]) - *(s-dims[0]);
      double v = dx*dx + dy*dy;

      /* second color channel */
      s += dims[0]*dims[1];
      double dy2 = *(s+1) - *(s-1);
      double dx2 = *(s+dims[0]) - *(s-dims[0]);
      double v2 = dx2*dx2 + dy2*dy2;

      /* third color channel */
      s += dims[0]*dims[1];
      double dy3 = *(s+1) - *(s-1);
      double dx3 = *(s+dims[0]) - *(s-dims[0]);
      double v3 = dx3*dx3 + dy3*dy3;

      /* pick channel with strongest gradient */
      if (v2 > v) {
	v = v2;
	dx = dx2;
	dy = dy2;
      } 
      if (v3 > v) {
	v = v3;
	dx = dx3;
	dy = dy3;
      }

      /* snap to one of 9 orientations & add to histogram */
      double best_dot = 0;
      int best_o = 0;
      int o;
      for (o = 0; o < 9; o++) {
	double dot = fabs(uu[o]*dx + vv[o]*dy);
	if (dot > best_dot) {
	  best_dot = dot;
	  best_o = o;
	}
      }
      
      double xp = (double)x/(double)sbin - 0.5;
      double yp = (double)y/(double)sbin - 0.5;
      int ixp = (int)xp;
      int iyp = (int)yp;
      double vx = xp-ixp;
      double vy = yp-iyp;
      
      if (ixp >= 0 && iyp >= 0) {
	*(hist + ixp*blocks[0] + iyp + best_o*blocks[0]*blocks[1]) += 
	  (1-vx)*(1-vy)*sqrt(v);
      }

      if (ixp+1 < blocks[1] && iyp >= 0) {
	*(hist + (ixp+1)*blocks[0] + iyp + best_o*blocks[0]*blocks[1]) += 
	  (vx)*(1-vy)*sqrt(v);
      }

      if (ixp >= 0 && iyp+1 < blocks[0]) {
	*(hist + ixp*blocks[0] + (iyp+1) + best_o*blocks[0]*blocks[1]) += 
	  (1-vx)*(vy)*sqrt(v);
      }

      if (ixp+1 < blocks[1] && iyp+1 < blocks[0]) {
	*(hist + (ixp+1)*blocks[0] + (iyp+1) + best_o*blocks[0]*blocks[1]) += 
	  (vx)*(vy)*sqrt(v);
      }

      /*
      *(hist + (x/sbin)*blocks[0] + (y/sbin) + best_o*blocks[0]*blocks[1]) += sqrt(v);
      */
    }
  }

  /* compute energy in each block by summing over orientation */
  int o;
  for (o = 0; o < 9; o++) {
    double *src = hist + o*blocks[0]*blocks[1];
    double *dst = norm;
    double *end = norm + blocks[1]*blocks[0];
    while (dst < end) {
      *(dst++) += (*src) * (*src);
      src++;
    }
  }

  /* compute normalized values */
  for (x = 0; x < out[1]; x++) {
    for (y = 0; y < out[0]; y++) {
      double *dst = feat + x*out[0] + y;
      
      double *p = norm + (x+1)*blocks[0] + y+1;
      double n = 1.0 / sqrt(*p + *(p+1) + *(p+blocks[0]) + *(p+blocks[0]+1) + eps);
      double *src = hist + (x+1)*blocks[0] + (y+1);
      for (o = 0; o < 9; o++) {
	*dst = min(*src * n, 0.2);
	dst += out[0]*out[1];
	src += blocks[0]*blocks[1];
      }

      p = norm + (x+1)*blocks[0] + y;
      n = 1.0 / sqrt(*p + *(p+1) + *(p+blocks[0]) + *(p+blocks[0]+1) + eps);
      src = hist + (x+1)*blocks[0] + (y+1);
      for (o = 0; o < 9; o++) {
	*dst = min(*src * n, 0.2);
	dst += out[0]*out[1];
	src += blocks[0]*blocks[1];
      }

      p = norm + x*blocks[0] + y+1;
      n = 1.0 / sqrt(*p + *(p+1) + *(p+blocks[0]) + *(p+blocks[0]+1) + eps);
      src = hist + (x+1)*blocks[0] + (y+1);
      for (o = 0; o < 9; o++) {
	*dst = min(*src * n, 0.2);
	dst += out[0]*out[1];
	src += blocks[0]*blocks[1];
      }

      p = norm + x*blocks[0] + y;      
      n = 1.0 / sqrt(*p + *(p+1) + *(p+blocks[0]) + *(p+blocks[0]+1) + eps);
      src = hist + (x+1)*blocks[0] + (y+1);
      for (o = 0; o < 9; o++) {
	*dst = min(*src * n, 0.2);
	dst += out[0]*out[1];
	src += blocks[0]*blocks[1];
      }      
    }
  }

  return feat_ptr;
}

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) { 
  if (nrhs != 2)
    mexErrMsgTxt("Wrong number of inputs."); 
  if (nlhs != 1)
    mexErrMsgTxt("Wrong number of outputs.");
  plhs[0] = process(prhs[0], prhs[1]);
}



