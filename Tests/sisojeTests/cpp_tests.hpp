#ifndef SISOJE_CPP_TESTS_H_
#define SISOJE_CPP_TESTS_H_

#include <XCTest/XCTest.h>
#include <map>
#include <unordered_map>
#include <vector>
#include <algorithm>
#include <sisoje_defines.hpp>
#include <fonts.hpp>
#include <iostream>
#include "lena.hpp"
#include <numeric>

namespace sisoje_tests {

typedef std::vector<int> int_vector;

const auto int_empty = int_vector {};
const auto int_one = int_vector {1};

struct Custom {
    int value;
};
inline bool operator<(const Custom &x, const Custom &y) {
    return x.value < y.value;
}
inline bool operator>(const Custom &x, const Custom &y) {
    return x.value > y.value;
}

} // sisoje_tests
#endif // SISOJE_CPP_TESTS_H_
