#ifndef SISOJE_VECTOR_ORDERED_H_
#define SISOJE_VECTOR_ORDERED_H_

#include <vector>
#include <algorithm>
#include <type_traits>

namespace sisoje {

template<bool ASCENDING>
struct sorted {
    template <typename ForwardIterator>
    constexpr static auto comparator() {
        typedef typename std::iterator_traits<ForwardIterator>::value_type value_type;
        typedef typename std::conditional<ASCENDING, std::less<value_type>, std::greater<value_type>>::type comparator_type;
        return comparator_type();
    }

    template <typename ForwardIterator>
    constexpr static auto is_sorted(ForwardIterator begin, ForwardIterator end) {
        return std::is_sorted(begin, end, comparator<ForwardIterator>());
    }

    template <typename ForwardIterator, typename T>
    constexpr static auto lower_bound(ForwardIterator begin, ForwardIterator end, const T &element) {
        return std::lower_bound(begin, end, element, comparator<ForwardIterator>());
    }

    template <typename ForwardIterator, typename T>
    constexpr static auto upper_bound(ForwardIterator begin, ForwardIterator end, const T &element) {
        return std::upper_bound(begin, end, element, comparator<ForwardIterator>());
    }
};

typedef sorted<false> descending;
typedef sorted<true> ascending;

} // namespace sisoje
#endif // SISOJE_VECTOR_ORDERED_H_
