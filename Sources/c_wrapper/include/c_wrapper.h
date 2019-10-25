#ifndef SISOJE_CWRAPPER_H_
#define SISOJE_CWRAPPER_H_

#ifdef __cplusplus
extern "C" {
#endif

int c_BinarySearchFloat(const float *p, int count, float element, int ascending, int first);
int c_BinarySearchInt(const int *p, int count, int element, int ascending, int first);

#ifdef __cplusplus
}
#endif

#endif
