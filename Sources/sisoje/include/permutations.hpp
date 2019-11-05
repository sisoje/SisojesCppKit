#ifndef SISOJE_PERMUTATIONS_H_
#define SISOJE_PERMUTATIONS_H_

#include <cmath>
#include <map>
#include <numeric>
#include "sisoje_defines.hpp"

namespace sisoje {

inline int factorial(int N) {
    return std::tgamma(N+1);
}

template<typename IT>
auto frequency_map(IT begin, IT end) {
    std::map<typename std::iterator_traits<IT>::value_type, int> result;
    while (begin != end) {
        ++result[*begin++];
    }
    return result;
}

template <typename IT>
int number_of_permutations(IT begin, IT end) {
    const auto frequencyMap = frequency_map(begin, end);
    return std::accumulate(SISOJE_RANGE(frequencyMap), factorial(end - begin), [](auto permutations, auto pair) {
        return permutations / factorial(pair.second);
    });
}

template <typename IT>
auto generate_permutation(int index, IT begin, IT end) {
    auto frequencyMap = frequency_map(begin, end);
    const auto places = end - begin;
    const auto total = std::accumulate(SISOJE_RANGE(frequencyMap), factorial(places), [](auto permutations, auto pair) {
        return permutations / factorial(pair.second);
    });
    std::vector<typename std::iterator_traits<IT>::value_type> permutation(places);
    auto currentIndex = index;
    auto currentTotal = total;
    for(int i=0;i<places;++i) {
        for (auto it = frequencyMap.begin(); it != frequencyMap.end(); ++it) {
            int totalWithoutIt = currentTotal * it->second / (places - i);
            if (currentIndex < totalWithoutIt) {
                currentTotal = totalWithoutIt;
                permutation[i] = it->first;
                it->second--;
                if (it->second == 0) {
                    frequencyMap.erase(it);
                }
                break;
            }
            currentIndex -= totalWithoutIt;
        }
    }
    return permutation;
}

} // namespace sisoje
#endif // SISOJE_PERMUTATIONS_H_
