#import <XCTest/XCTest.h>
#import <c_wrapper.h>

@interface CwrapperTests: XCTestCase @end

@implementation CwrapperTests

- (void)doTestBinarySearchWithCount:(int)count ascending:(BOOL)ascending {
    int v[count];
    int c[count];
    int nonexisting = -1;
    int same = count;
    for(int i=0;i<count;++i) {
        int index = ascending ? i : (count-1-i);
        v[index] = i;
        c[i] = same;
    }
    for(int first=0;first<=1;++first) {
        XCTAssertEqual(c_BinarySearchInt(v, 0, nonexisting, ascending, first), -1);
        XCTAssertEqual(c_BinarySearchInt(v, count, nonexisting, ascending, first), -1);
        XCTAssertEqual(c_BinarySearchInt(c, count, nonexisting, ascending, first), -1);
        XCTAssertEqual(c_BinarySearchInt(c, count, same, ascending, first), first ? 0 : (count-1));
        for(int i=0;i<count;++i) {
            float elem = v[i];
            XCTAssertEqual(c_BinarySearchInt(v, count, elem, ascending, first), i);
        }
    }
}

- (void)testBinarySearch {
    [self doTestBinarySearchWithCount:3 ascending:YES];
    [self doTestBinarySearchWithCount:3 ascending:NO];
}

@end
