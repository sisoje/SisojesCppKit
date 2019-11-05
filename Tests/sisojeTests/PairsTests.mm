#include <pairs.hpp>
#include "cpp_tests.hpp"

@interface PairsTests : XCTestCase
@end

@implementation PairsTests

- (void)testExample {
    const auto map = std::map<int, int> {
        {1,2},
        {2,3}
    };

    const auto keys = sisoje::pairs_first(SISOJE_BEG_END(map));
    const auto values = sisoje::pairs_second(SISOJE_BEG_END(map));

    XCTAssertEqual(keys, std::vector<int>({1, 2}));
    XCTAssertEqual(values, std::vector<int>({2, 3}));
}

@end
