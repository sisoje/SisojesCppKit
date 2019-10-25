#ifndef SISOJE_VECTOR_ORDERED_H_
#define SISOJE_VECTOR_ORDERED_H_

#include <vector>
#include <algorithm>
#include <type_traits>

namespace sisoje {

template<typename ITERATOR>
using iterator_value_type = typename std::iterator_traits<ITERATOR>::value_type;

template<bool ASCENDING>
struct vector_ordered {
    template<typename T>
    using comparator_type = typename std::conditional<ASCENDING, std::less<T>, std::greater<T>>::type;

    template<typename ITERATOR>
    using iterator_comparator_type = comparator_type<iterator_value_type<ITERATOR>>;

    template <typename ForwardIterator>
    static auto is_sorted(ForwardIterator begin, ForwardIterator end) {
        return std::is_sorted(begin, end, iterator_comparator_type<ForwardIterator>());
    }

    template <typename T>
    static auto is_sorted(const std::vector<T> &vec) {
        return is_sorted(vec.begin(), vec.end());
    }

    template <typename ForwardIterator, typename T>
    static auto lower_bound(ForwardIterator begin, ForwardIterator end, const T &element) {
        return std::lower_bound(begin, end, element, iterator_comparator_type<ForwardIterator>());
    }

    template <typename ForwardIterator, typename T>
    static auto upper_bound(ForwardIterator begin, ForwardIterator end, const T &element) {
        return std::upper_bound(begin, end, element, iterator_comparator_type<ForwardIterator>());
    }

    template <typename T>
    static auto lower_bound(const std::vector<T> &vec, const T &element) {
        return lower_bound(vec.begin(), vec.end(), element);
    }

    template <typename T>
    static auto upper_bound(const std::vector<T> &vec, const T &element) {
        return upper_bound(vec.begin(), vec.end(), element);
    }
};

typedef vector_ordered<false> vector_descending;
typedef vector_ordered<true> vector_ascending;

} // namespace sisoje

#endif
