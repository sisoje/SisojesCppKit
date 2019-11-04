#import <XCTest/XCTest.h>
#include <vector_ordered.hpp>
#include <iterator>

using namespace sisoje;

#define SISOJE_BEG_END(BEG_END) BEG_END.begin(), BEG_END.end()

typedef std::vector<int> int_vector;

struct Custom { int value; };
bool operator<(const Custom &x, const Custom &y) {
    return x.value < y.value;
}
bool operator>(const Custom &x, const Custom &y) {
    return x.value > y.value;
}

@interface SortedVectorTests: XCTestCase
@end

@implementation SortedVectorTests

- (void)testIsSortedInt {
    constexpr int N = 2;
    const int v[N] = {1, 2};
    const auto endv = v + N;
    XCTAssertTrue(vector_ascending::is_sorted(v, endv));
    XCTAssertFalse(vector_descending::is_sorted(v, endv));
}

- (void)testIsSorted {
    const auto vec11 = int_vector {1, 1};
    const auto vec12 = int_vector {1, 2};
    const auto vec21 = int_vector {2, 1};
    const auto vec1 = int_vector {1};
    const auto vecEmpty = int_vector {};

    // Test ascending
    XCTAssertFalse(vector_ascending::is_sorted(SISOJE_BEG_END(vec21)));
    XCTAssertTrue(vector_ascending::is_sorted(SISOJE_BEG_END(vec12)));
    XCTAssertTrue(vector_ascending::is_sorted(SISOJE_BEG_END(vec11)));
    XCTAssertTrue(vector_ascending::is_sorted(SISOJE_BEG_END(vec1)));
    XCTAssertTrue(vector_ascending::is_sorted(SISOJE_BEG_END(vecEmpty)));

    // Test descending
    XCTAssertTrue(vector_descending::is_sorted(SISOJE_BEG_END(vec21)));
    XCTAssertFalse(vector_descending::is_sorted(SISOJE_BEG_END(vec12)));
    XCTAssertTrue(vector_descending::is_sorted(SISOJE_BEG_END(vec11)));
    XCTAssertTrue(vector_descending::is_sorted(SISOJE_BEG_END(vec1)));
    XCTAssertTrue(vector_descending::is_sorted(SISOJE_BEG_END(vecEmpty)));

}

- (void)testBounds {
    const auto vec = int_vector {1, 1};

    // Test ascending
    XCTAssertEqual(vector_ascending::lower_bound(SISOJE_BEG_END(vec), 1), vec.begin());
    XCTAssertEqual(vector_ascending::upper_bound(SISOJE_BEG_END(vec), 1), vec.end());
    XCTAssertEqual(vector_ascending::lower_bound(SISOJE_BEG_END(vec), 2), vec.end());
    XCTAssertEqual(vector_ascending::upper_bound(SISOJE_BEG_END(vec), 2), vec.end());
    XCTAssertEqual(vector_ascending::lower_bound(SISOJE_BEG_END(vec), 0), vec.begin());
    XCTAssertEqual(vector_ascending::upper_bound(SISOJE_BEG_END(vec), 0), vec.begin());

    // Test descending
    XCTAssertEqual(vector_descending::lower_bound(SISOJE_BEG_END(vec), 1), vec.begin());
    XCTAssertEqual(vector_descending::upper_bound(SISOJE_BEG_END(vec), 1), vec.end());
    XCTAssertEqual(vector_descending::lower_bound(SISOJE_BEG_END(vec), 2), vec.begin());
    XCTAssertEqual(vector_descending::upper_bound(SISOJE_BEG_END(vec), 2), vec.begin());
    XCTAssertEqual(vector_descending::lower_bound(SISOJE_BEG_END(vec), 0), vec.end());
    XCTAssertEqual(vector_descending::upper_bound(SISOJE_BEG_END(vec), 0), vec.end());
}

-(void)testCustom {
    auto vec = std::vector<Custom>();
    vec.push_back(Custom {1});
    vec.push_back(Custom {2});
    vec.push_back(Custom {3});
    XCTAssertTrue(vector_ascending::is_sorted(SISOJE_BEG_END(vec)));
    XCTAssertFalse(vector_descending::is_sorted(SISOJE_BEG_END(vec)));

    auto p = vector_ascending::lower_bound(vec.begin(), vec.end(), Custom {2} );
    XCTAssertEqual(p - vec.begin(), 1);
}

@end
