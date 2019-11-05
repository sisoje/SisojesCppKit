#include <permutations.hpp>
#include "cpp_tests.hpp"
using namespace sisoje_tests;

@interface PermutationsTests: XCTestCase
@end

@implementation PermutationsTests

- (void)testFactorial {
    XCTAssertEqual(sisoje::factorial(0), 1);
    XCTAssertEqual(sisoje::factorial(1), 1);
    XCTAssertEqual(sisoje::factorial(2), 2);
    XCTAssertEqual(sisoje::factorial(3), 6);
}

-(void) testCount {
    const auto vec = int_vector {1, 2, 2};
    const auto frequencyMap = sisoje::frequency_map(SISOJE_RANGE(vec));
    XCTAssertEqual(frequencyMap.size(), 2);
    XCTAssertEqual(frequencyMap.at(1), 1);
    XCTAssertEqual(frequencyMap.at(2), 2);
}

- (void)testNumberOfPermutations {
    XCTAssertEqual(sisoje::number_of_permutations(int_vector {}), 1);
    XCTAssertEqual(sisoje::number_of_permutations(int_vector {1}), 1);
    XCTAssertEqual(sisoje::number_of_permutations(int_vector {1, 1}), 1);
    XCTAssertEqual(sisoje::number_of_permutations(int_vector {1, 2}), 2);
    XCTAssertEqual(sisoje::number_of_permutations(int_vector {1, 1, 2}), 3);
    XCTAssertEqual(sisoje::number_of_permutations(int_vector {1, 2, 2}), 3);
}

-(void)testGeneratePermutation {
    const auto cvec = int_vector {1, 2, 2, 3, 3, 3};
    const auto n = sisoje::number_of_permutations(cvec);
    XCTAssertGreaterThan(n, 0);
    auto vec = cvec;
    std::sort(SISOJE_RANGE(vec));
    for(int i = 0; i < n; ++i, std::next_permutation(SISOJE_RANGE(vec))) {
        const auto perm = sisoje::generate_permutation(i, SISOJE_RANGE(cvec));
        XCTAssertEqual(perm, vec);
    }
    XCTAssert(std::is_sorted(SISOJE_RANGE(vec)));
}

-(void)testGeneratePermutationEmpty {
    const int_vector vec;
    XCTAssertEqual(sisoje::generate_permutation(0, SISOJE_RANGE(vec)), vec);
}

-(void)testGeneratePermutationOne {
    const auto vec = int_vector {1};
    XCTAssertEqual(sisoje::generate_permutation(0, SISOJE_RANGE(vec)), vec);
}

@end
