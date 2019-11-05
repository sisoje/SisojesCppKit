#include <c_wrapper.h>
#include <sorted.hpp>

template <typename T>
int cpp_BinaryFindInsertionIndex(const T *p, int count, const T &element, int ascending, int first) {
    auto func = ascending ?
    (first ? (sisoje::ascending::lower_bound<const T*, const T&>) : (sisoje::ascending::upper_bound<const T*, const T&>))
    :
    (first ? (sisoje::descending::lower_bound<const T*, const T&>) : (sisoje::descending::upper_bound<const T*, const T&>));

    return func(p, p+count, element) - p;
}

extern "C" {

int c_BinaryFindInsertionIndexInt(const int *p, int count, int element, int ascending, int first) {
    return cpp_BinaryFindInsertionIndex(p, count, element, ascending, first);
}

} // extern "C"
