#include <sorted.hpp>
#include "cpp_tests.hpp"

typedef std::vector<int> int_vector;

struct Custom { int value; };
bool operator<(const Custom &x, const Custom &y) {
    return x.value < y.value;
}
bool operator>(const Custom &x, const Custom &y) {
    return x.value > y.value;
}

@interface SortedTests: XCTestCase
@end

@implementation SortedTests

- (void)testIsSortedInt {
    constexpr int N = 2;
    const int v[N] = {1, 2};
    const auto endv = v + N;
    XCTAssertTrue(sisoje::ascending::is_sorted(v, endv));
    XCTAssertFalse(sisoje::descending::is_sorted(v, endv));
}

- (void)testIsSorted {
    const auto vec11 = int_vector {1, 1};
    const auto vec12 = int_vector {1, 2};
    const auto vec21 = int_vector {2, 1};
    const auto vec1 = int_vector {1};
    const auto vecEmpty = int_vector {};

    // Test ascending
    XCTAssertFalse(sisoje::ascending::is_sorted(SISOJE_BEG_END(vec21)));
    XCTAssertTrue(sisoje::ascending::is_sorted(SISOJE_BEG_END(vec12)));
    XCTAssertTrue(sisoje::ascending::is_sorted(SISOJE_BEG_END(vec11)));
    XCTAssertTrue(sisoje::ascending::is_sorted(SISOJE_BEG_END(vec1)));
    XCTAssertTrue(sisoje::ascending::is_sorted(SISOJE_BEG_END(vecEmpty)));

    // Test descending
    XCTAssertTrue(sisoje::descending::is_sorted(SISOJE_BEG_END(vec21)));
    XCTAssertFalse(sisoje::descending::is_sorted(SISOJE_BEG_END(vec12)));
    XCTAssertTrue(sisoje::descending::is_sorted(SISOJE_BEG_END(vec11)));
    XCTAssertTrue(sisoje::descending::is_sorted(SISOJE_BEG_END(vec1)));
    XCTAssertTrue(sisoje::descending::is_sorted(SISOJE_BEG_END(vecEmpty)));

}

- (void)testBounds {
    const auto vec = int_vector {1, 1};

    // Test ascending
    XCTAssertEqual(sisoje::ascending::lower_bound(SISOJE_BEG_END(vec), 1), vec.begin());
    XCTAssertEqual(sisoje::ascending::upper_bound(SISOJE_BEG_END(vec), 1), vec.end());
    XCTAssertEqual(sisoje::ascending::lower_bound(SISOJE_BEG_END(vec), 2), vec.end());
    XCTAssertEqual(sisoje::ascending::upper_bound(SISOJE_BEG_END(vec), 2), vec.end());
    XCTAssertEqual(sisoje::ascending::lower_bound(SISOJE_BEG_END(vec), 0), vec.begin());
    XCTAssertEqual(sisoje::ascending::upper_bound(SISOJE_BEG_END(vec), 0), vec.begin());

    // Test descending
    XCTAssertEqual(sisoje::descending::lower_bound(SISOJE_BEG_END(vec), 1), vec.begin());
    XCTAssertEqual(sisoje::descending::upper_bound(SISOJE_BEG_END(vec), 1), vec.end());
    XCTAssertEqual(sisoje::descending::lower_bound(SISOJE_BEG_END(vec), 2), vec.begin());
    XCTAssertEqual(sisoje::descending::upper_bound(SISOJE_BEG_END(vec), 2), vec.begin());
    XCTAssertEqual(sisoje::descending::lower_bound(SISOJE_BEG_END(vec), 0), vec.end());
    XCTAssertEqual(sisoje::descending::upper_bound(SISOJE_BEG_END(vec), 0), vec.end());
}

-(void)testCustom {
    auto vec = std::vector<Custom>();
    vec.push_back(Custom {1});
    vec.push_back(Custom {2});
    vec.push_back(Custom {3});
    XCTAssertTrue(sisoje::ascending::is_sorted(SISOJE_BEG_END(vec)));
    XCTAssertFalse(sisoje::descending::is_sorted(SISOJE_BEG_END(vec)));

    auto p = sisoje::ascending::lower_bound(SISOJE_BEG_END(vec), Custom {2} );
    XCTAssertEqual(p - vec.begin(), 1);
}

@end
