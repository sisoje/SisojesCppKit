#ifndef SISOJE_VECTOR_ORDERED_H_
#define SISOJE_VECTOR_ORDERED_H_

#include <vector>
#include <algorithm>
#include <type_traits>

namespace sisoje {

template<bool ASCENDING>
struct vector_ordered {
    template<typename T>
    using comparator_type = typename std::conditional<ASCENDING, std::less<T>, std::greater<T>>::type;

    template<typename ITERATOR>
    using iterator_comparator_type = comparator_type<typename std::iterator_traits<ITERATOR>::value_type>;

    template <typename ForwardIterator>
    static auto is_sorted(ForwardIterator begin, ForwardIterator end) {
        return std::is_sorted(begin, end, iterator_comparator_type<ForwardIterator>());
    }

    template <typename ForwardIterator, typename T>
    static auto lower_bound(ForwardIterator begin, ForwardIterator end, const T &element) {
        return std::lower_bound(begin, end, element, iterator_comparator_type<ForwardIterator>());
    }

    template <typename ForwardIterator, typename T>
    static auto upper_bound(ForwardIterator begin, ForwardIterator end, const T &element) {
        return std::upper_bound(begin, end, element, iterator_comparator_type<ForwardIterator>());
    }
};

typedef vector_ordered<false> vector_descending;
typedef vector_ordered<true> vector_ascending;

} // namespace sisoje

#endif // SISOJE_VECTOR_ORDERED_H_
