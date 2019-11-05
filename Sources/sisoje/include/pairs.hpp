#ifndef SISOJE_PAIRS_H_
#define SISOJE_PAIRS_H_

#include <algorithm>
#include <type_traits>
#include <utility>
#include <vector>

namespace sisoje {

template<typename PairIterator>
auto pairs_second(PairIterator begin, PairIterator end) {
    std::vector<typename std::iterator_traits<PairIterator>::value_type::second_type> vec;
    std::transform(begin, end, std::back_inserter(vec), [](auto pair){
        return pair.second;
    });
    return vec;
}

template<typename PairIterator>
auto pairs_first(PairIterator begin, PairIterator end) {
    std::vector<typename std::remove_const_t<typename std::iterator_traits<PairIterator>::value_type::first_type>> vec;
    std::transform(begin, end, std::back_inserter(vec), [](auto pair){
        return pair.first;
    });
    return vec;
}

} // namespace sisoje
#endif // SISOJE_PAIRS_H_
