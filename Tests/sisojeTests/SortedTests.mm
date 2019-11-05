#include <sorted.hpp>
#include "cpp_tests.hpp"
using namespace sisoje_tests;

@interface SortedTests: XCTestCase
@end

@implementation SortedTests

- (void)testIsSortedInt {
    const int v[] = {1, 2};
    XCTAssertTrue(sisoje::ascending::is_sorted(SISOJE_RANGE(v)));
    XCTAssertFalse(sisoje::descending::is_sorted(SISOJE_RANGE(v)));
}

- (void)testIsSorted {
    const int vec11[] = {1, 1};
    const int vec12[] = {1, 2};
    const int vec21[] = {2, 1};

    // Test ascending
    XCTAssertFalse(sisoje::ascending::is_sorted(SISOJE_RANGE(vec21)));
    XCTAssertTrue(sisoje::ascending::is_sorted(SISOJE_RANGE(vec12)));
    XCTAssertTrue(sisoje::ascending::is_sorted(SISOJE_RANGE(vec11)));
    XCTAssertTrue(sisoje::ascending::is_sorted(SISOJE_RANGE(int_one)));
    XCTAssertTrue(sisoje::ascending::is_sorted(SISOJE_RANGE(int_empty)));

    // Test descending
    XCTAssertTrue(sisoje::descending::is_sorted(SISOJE_RANGE(vec21)));
    XCTAssertFalse(sisoje::descending::is_sorted(SISOJE_RANGE(vec12)));
    XCTAssertTrue(sisoje::descending::is_sorted(SISOJE_RANGE(vec11)));
    XCTAssertTrue(sisoje::descending::is_sorted(SISOJE_RANGE(int_one)));
    XCTAssertTrue(sisoje::descending::is_sorted(SISOJE_RANGE(int_empty)));

}

- (void)testBounds {
    const int vec[] = {1, 1};

    // Test ascending
    XCTAssertEqual(sisoje::ascending::lower_bound(SISOJE_RANGE(vec), 1), std::begin(vec));
    XCTAssertEqual(sisoje::ascending::upper_bound(SISOJE_RANGE(vec), 1), std::end(vec));
    XCTAssertEqual(sisoje::ascending::lower_bound(SISOJE_RANGE(vec), 2), std::end(vec));
    XCTAssertEqual(sisoje::ascending::upper_bound(SISOJE_RANGE(vec), 2), std::end(vec));
    XCTAssertEqual(sisoje::ascending::lower_bound(SISOJE_RANGE(vec), 0), std::begin(vec));
    XCTAssertEqual(sisoje::ascending::upper_bound(SISOJE_RANGE(vec), 0), std::begin(vec));

    // Test descending
    XCTAssertEqual(sisoje::descending::lower_bound(SISOJE_RANGE(vec), 1), std::begin(vec));
    XCTAssertEqual(sisoje::descending::upper_bound(SISOJE_RANGE(vec), 1), std::end(vec));
    XCTAssertEqual(sisoje::descending::lower_bound(SISOJE_RANGE(vec), 2), std::begin(vec));
    XCTAssertEqual(sisoje::descending::upper_bound(SISOJE_RANGE(vec), 2), std::begin(vec));
    XCTAssertEqual(sisoje::descending::lower_bound(SISOJE_RANGE(vec), 0), std::end(vec));
    XCTAssertEqual(sisoje::descending::upper_bound(SISOJE_RANGE(vec), 0), std::end(vec));
}

-(void)testCustom {
    const Custom vec[] = {
        Custom {1},
        Custom {2},
        Custom {3}
    };
    XCTAssertTrue(sisoje::ascending::is_sorted(SISOJE_RANGE(vec)));
    XCTAssertFalse(sisoje::descending::is_sorted(SISOJE_RANGE(vec)));
    const auto p = sisoje::ascending::lower_bound(SISOJE_RANGE(vec), Custom {2} );
    XCTAssertEqual(p - std::begin(vec), 1);
}

@end
