#import <XCTest/XCTest.h>
#import <sorted_vector.hpp>

typedef std::vector<int> int_vector;

@interface SortedVectorTests: XCTestCase @end

@implementation SortedVectorTests

- (void)testIsSortedAsc {
    typedef sorted_vector<true> checker;
    XCTAssertFalse(checker::isSorted(int_vector({2, 1})));
    XCTAssertTrue(checker::isSorted(int_vector({1, 2})));
    XCTAssertTrue(checker::isSorted(int_vector({1, 1})));
    XCTAssertTrue(checker::isSorted(int_vector({1})));
    XCTAssertTrue(checker::isSorted(int_vector({})));
}

- (void)testIsSortedDesc {
    typedef sorted_vector<false> checker;
    XCTAssertFalse(checker::isSorted(int_vector({1, 2})));
    XCTAssertTrue(checker::isSorted(int_vector({2, 1})));
    XCTAssertTrue(checker::isSorted(int_vector({1, 1})));
    XCTAssertTrue(checker::isSorted(int_vector({1})));
    XCTAssertTrue(checker::isSorted(int_vector({})));
}

- (void)testIndexFindingAsc {
    typedef sorted_vector<true> checker;
    auto asc = int_vector { 1 };
    XCTAssertEqual(checker::firstIndex(asc, 1), 0);
    XCTAssertEqual(checker::lastIndex(asc, 1), 0);
    XCTAssertEqual(checker::firstIndex(asc, 2), -1);
    XCTAssertEqual(checker::lastIndex(asc, 2), -1);
}

- (void)testIndexFindingDesc {
    typedef sorted_vector<true> checker;
    auto asc = int_vector { 1 };
    XCTAssertEqual(checker::firstIndex(asc, 1), 0);
    XCTAssertEqual(checker::lastIndex(asc, 1), 0);
    XCTAssertEqual(checker::firstIndex(asc, 2), -1);
    XCTAssertEqual(checker::lastIndex(asc, 2), -1);
}

- (void)testFirstLastAsc {
    typedef sorted_vector<true> checker;
    auto asc = int_vector { 1, 1 };
    XCTAssertEqual(checker::firstIndex(asc, 1), 0);
    XCTAssertEqual(checker::lastIndex(asc, 1), 1);
}

- (void)testFirstLastDesc {
    typedef sorted_vector<false> checker;
    auto asc = int_vector { 1, 1 };
    XCTAssertEqual(checker::firstIndex(asc, 1), 0);
    XCTAssertEqual(checker::lastIndex(asc, 1), 1);
}

- (void)testInsertAsc {
    typedef sorted_vector<true> checker;
    auto vec = int_vector();
    checker::insert(vec, 1);
    checker::insert(vec, 1);
    XCTAssertTrue(checker::isSorted(int_vector({1, 1})));
}

- (void)testInsertDesc {
    typedef sorted_vector<false> checker;
    auto vec = int_vector();
    checker::insert(vec, 1);
    checker::insert(vec, 1);
    XCTAssertTrue(checker::isSorted(int_vector({1, 1})));
}

- (void)testRemoveOneAsc {
    typedef sorted_vector<true> checker;
    auto vec = int_vector({1});
    XCTAssertEqual(checker::removeOne(vec, 1), 0);
    XCTAssertEqual(checker::removeOne(vec, 1), -1);
}

- (void)testRemoveOneDesc {
    typedef sorted_vector<false> checker;
    auto vec = int_vector({1});
    XCTAssertEqual(checker::removeOne(vec, 1), 0);
    XCTAssertEqual(checker::removeOne(vec, 1), -1);
}

@end
