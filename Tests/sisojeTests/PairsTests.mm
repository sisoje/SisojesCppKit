#include <pairs.hpp>
#include "cpp_tests.hpp"
using namespace sisoje_tests;

@interface PairsTests : XCTestCase
@end

@implementation PairsTests

- (void)testExample {
    const auto map = std::map<int, int> {
        {1,2},
        {2,1}
    };

    const auto keys = sisoje::pairs_first(SISOJE_RANGE(map));
    const auto values = sisoje::pairs_second(SISOJE_RANGE(map));

    XCTAssertEqual(keys, int_vector({1, 2}));
    XCTAssertEqual(values, int_vector({2, 1}));
}

@end
