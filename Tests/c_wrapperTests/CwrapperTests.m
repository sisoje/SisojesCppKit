#import <XCTest/XCTest.h>
#include <c_wrapper.h>

@interface CwrapperTests: XCTestCase
@end

@implementation CwrapperTests

- (void)testBinarySearch {
    const int NMAX = 3;
    int v[NMAX];
    for(int ascending=0;ascending<=1;++ascending) {
        for(int i=0;i<NMAX;++i) {
            int index = ascending ? i : (NMAX-1-i);
            v[index] = i;
        }
        for(int first=0;first<=1;++first) {
            XCTAssertEqual(c_BinaryFindInsertionIndexInt(v, 0, -1, ascending, first), 0);
            for(int count=1;count<NMAX;++count) {
                for(int i=0;i<count;++i) {
                    float elem = v[i];
                    XCTAssertEqual(c_BinaryFindInsertionIndexInt(v, count, elem, ascending, first), first ? i : i+1);
                }
            }
        }
    }
}

@end
