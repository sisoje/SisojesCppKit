#ifndef SISOJE_CPP_TESTS_H_
#define SISOJE_CPP_TESTS_H_

#include <XCTest/XCTest.h>
#include <map>
#include <vector>
#include <algorithm>
#include <sisoje_defines.hpp>

namespace sisoje_tests {

typedef std::vector<int> int_vector;

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
