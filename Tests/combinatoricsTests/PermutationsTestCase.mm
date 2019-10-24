#import <XCTest/XCTest.h>
#import <permutations.hpp>

@interface PermutationsTestCase: XCTestCase @end

@implementation PermutationsTestCase

- (void)testNumberOfPermutations {
    XCTAssertEqual(Permutations::numberOfPermutations(3), 6);
}

@end
