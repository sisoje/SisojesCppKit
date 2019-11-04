#include <c_wrapper.h>
#include <vector_ordered.hpp>

template <typename T>
int cpp_BinaryFindInsertionIndex(const T *p, int count, const T &element, int ascending, int first) {
    auto func = ascending ?
    (first ? (sisoje::vector_ascending::lower_bound<const T*, const T&>) : (sisoje::vector_ascending::upper_bound<const T*, const T&>))
    :
    (first ? (sisoje::vector_descending::lower_bound<const T*, const T&>) : (sisoje::vector_descending::upper_bound<const T*, const T&>));

    return func(p, p+count, element) - p;
}

extern "C" {

int c_BinaryFindInsertionIndexInt(const int *p, int count, int element, int ascending, int first) {
    return cpp_BinaryFindInsertionIndex(p, count, element, ascending, first);
}

} // extern "C"
