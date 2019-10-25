#import <XCTest/XCTest.h>
#import <permutations.hpp>

@interface PermutationsTests: XCTestCase @end

@implementation PermutationsTests

- (void)testNumberOfPermutations {
    XCTAssertEqual(Permutations::numberOfPermutations(3), 6);
}

@end
