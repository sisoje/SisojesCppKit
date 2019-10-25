#import <XCTest/XCTest.h>
#import <vector_ordered.hpp>
#include <iterator>
using namespace sisoje;

typedef std::vector<int> int_vector;

struct Custom { int value; };

bool operator<(const Custom &x, const Custom &y) {
    return x.value < y.value;
}

template<>
struct std::less<Custom> {
    bool operator()(const Custom& x, const Custom& y) const {
        return x.value < y.value;
    }
};

template<>
struct std::greater<Custom> {
    bool operator()(const Custom& x, const Custom& y) const {
        return x.value > y.value;
    }
};

@interface SortedVectorTests: XCTestCase
@end

@implementation SortedVectorTests

- (void)testIsSorted1 {
    const int v[] = {1, 2};
    XCTAssertTrue(vector_ascending::is_sorted(std::begin(v), std::end(v)));
    XCTAssertFalse(vector_descending::is_sorted(std::begin(v), std::end(v)));
}

- (void)testIsSorted {
    const auto vec11 = int_vector { 1, 1 };
    const auto vec12 = int_vector { 1, 2 };
    const auto vec21 = int_vector { 2, 1 };
    const auto vec1 = int_vector { 1 };
    const auto vecEmpty = int_vector();

    // Test ascending
    XCTAssertFalse(vector_ascending::is_sorted(vec21));
    XCTAssertTrue(vector_ascending::is_sorted(vec12));
    XCTAssertTrue(vector_ascending::is_sorted(vec11));
    XCTAssertTrue(vector_ascending::is_sorted(vec1));
    XCTAssertTrue(vector_ascending::is_sorted(vecEmpty));

    // Test descending
    XCTAssertTrue(vector_descending::is_sorted(vec21));
    XCTAssertFalse(vector_descending::is_sorted(vec12));
    XCTAssertTrue(vector_descending::is_sorted(vec11));
    XCTAssertTrue(vector_descending::is_sorted(vec1));
    XCTAssertTrue(vector_descending::is_sorted(vecEmpty));

}

- (void)testBounds {
    const auto vec = int_vector { 1, 1 };

    // Test ascending
    XCTAssertEqual(vector_ascending::lower_bound(vec, 1), vec.begin());
    XCTAssertEqual(vector_ascending::upper_bound(vec, 1), vec.end());
    XCTAssertEqual(vector_ascending::lower_bound(vec, 2), vec.end());
    XCTAssertEqual(vector_ascending::upper_bound(vec, 2), vec.end());
    XCTAssertEqual(vector_ascending::lower_bound(vec, 0), vec.begin());
    XCTAssertEqual(vector_ascending::upper_bound(vec, 0), vec.begin());

    // Test descending
    XCTAssertEqual(vector_descending::lower_bound(vec, 1), vec.begin());
    XCTAssertEqual(vector_descending::upper_bound(vec, 1), vec.end());
    XCTAssertEqual(vector_descending::lower_bound(vec, 2), vec.begin());
    XCTAssertEqual(vector_descending::upper_bound(vec, 2), vec.begin());
    XCTAssertEqual(vector_descending::lower_bound(vec, 0), vec.end());
    XCTAssertEqual(vector_descending::upper_bound(vec, 0), vec.end());
}

-(void)testCustom {
    auto vec = std::vector<Custom>();
    vec.push_back(Custom { 1 });
    vec.push_back(Custom { 2 });
    vec.push_back(Custom { 3 });
    XCTAssertTrue(vector_ascending::is_sorted(vec));
    XCTAssertFalse(vector_descending::is_sorted(vec));

    auto p = vector_ascending::lower_bound(vec, Custom { 2 } );
    XCTAssertEqual(p-vec.begin(), 1);
}

@end
