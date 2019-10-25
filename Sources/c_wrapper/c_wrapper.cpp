#import <vector_ordered.hpp>
#import <c_wrapper.h>

template <typename T>
int cpp_BinarySearch(const T *p, int count, const T &element, int ascending, int first) {
    auto func = ascending ?
    (first ? (sisoje::vector_ascending::lower_bound<const T*, const T&>) : (sisoje::vector_ascending::upper_bound<const T*, const T&>))
    :
    (first ? (sisoje::vector_descending::lower_bound<const T*, const T&>) : (sisoje::vector_descending::upper_bound<const T*, const T&>));
    
    auto index = func(p, p+count, element) - p;
    
    if (!first) {
        --index;
    }
    
    return index >= 0 && index < count && p[index] == element ? index : -1;
}

extern "C" {

int c_BinarySearchFloat(const float *p, int count, float element, int ascending, int first) {
    return cpp_BinarySearch(p, count, element, ascending, first);
}

int c_BinarySearchInt(const int *p, int count, int element, int ascending, int first) {
    return cpp_BinarySearch(p, count, element, ascending, first);
}

} // extern "C"
