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
    const int vec[] = {1, 2, 2};
    const auto frequencyMap = sisoje::frequency_map(SISOJE_RANGE(vec));
    XCTAssertEqual(frequencyMap.size(), 2);
    XCTAssertEqual(frequencyMap.at(1), 1);
    XCTAssertEqual(frequencyMap.at(2), 2);
}

- (void)testNumberOfPermutations {
    const int vec_11[] = {1, 1};
    const int vec_12[] = {1, 2};
    const int vec_122[] = {1, 2, 2};

    XCTAssertEqual(sisoje::number_of_permutations(SISOJE_RANGE(int_empty)), 1);
    XCTAssertEqual(sisoje::number_of_permutations(SISOJE_RANGE(int_one)), 1);
    XCTAssertEqual(sisoje::number_of_permutations(SISOJE_RANGE(vec_11)), 1);
    XCTAssertEqual(sisoje::number_of_permutations(SISOJE_RANGE(vec_12)), 2);
    XCTAssertEqual(sisoje::number_of_permutations(SISOJE_RANGE(vec_122)), 3);
}

-(void)testGeneratePermutation {
    const int cvec[] = {1, 2, 2, 3, 3, 3};
    const auto n = sisoje::number_of_permutations(SISOJE_RANGE(cvec));
    XCTAssertGreaterThan(n, 0);
    auto vec = int_vector(SISOJE_RANGE(cvec));
    std::sort(SISOJE_RANGE(vec));
    for(int i = 0; i < n; ++i, std::next_permutation(SISOJE_RANGE(vec))) {
        const auto perm = sisoje::generate_permutation(i, SISOJE_RANGE(cvec));
        XCTAssertEqual(perm, vec);
    }
    XCTAssert(std::is_sorted(SISOJE_RANGE(vec)));
}

-(void)testGeneratePermutationEmpty {
    XCTAssertEqual(sisoje::generate_permutation(0, SISOJE_RANGE(int_empty)), int_empty);
}

-(void)testGeneratePermutationOne {
    XCTAssertEqual(sisoje::generate_permutation(0, SISOJE_RANGE(int_one)), int_one);
}

@end
