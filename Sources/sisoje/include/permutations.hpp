#ifndef SISOJE_PERMUTATIONS_H_
#define SISOJE_PERMUTATIONS_H_

#include <cmath>
#include <map>
#include <numeric>

namespace sisoje {

static int factorial(int N) {
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

template <typename T>
int number_of_permutations(const std::vector<T>& elements) {
    const auto frequencyMap = frequency_map(elements.begin(), elements.end());
    return std::accumulate(frequencyMap.begin(), frequencyMap.end(), factorial(elements.size()), [](auto permutations, auto pair) {
        return permutations / factorial(pair.second);
    });
}

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
    std::vector<typename std::iterator_traits<PairIterator>::value_type::first_type> vec;
    std::transform(begin, end, std::back_inserter(vec), [](auto pair){
        return pair.first;
    });
    return vec;
}

template <typename T>
std::vector<T> generate_permutation(int index, const std::vector<T>& elements) {
    auto frequencyMap = frequency_map(elements.begin(), elements.end());
    const auto places = elements.size();
    const auto total = std::accumulate(frequencyMap.begin(), frequencyMap.end(), factorial(places), [](auto permutations, auto pair) {
        return permutations / factorial(pair.second);
    });
    std::vector<T> permutation(places);
    auto currentIndex = index;
    auto currentTotal = total;
    for(auto i=0;i<places;++i) {
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

}


#endif // SISOJE_PERMUTATIONS_H_
