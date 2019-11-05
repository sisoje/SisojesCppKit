#include <permutations.hpp>
#include "cpp_tests.hpp"

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
    const auto vec = std::vector<int> {1, 2, 2};
    const auto frequencyMap = sisoje::frequency_map(SISOJE_BEG_END(vec));
    XCTAssertEqual(frequencyMap.size(), 2);
    XCTAssertEqual(frequencyMap.at(1), 1);
    XCTAssertEqual(frequencyMap.at(2), 2);
}

- (void)testNumberOfPermutations {
    XCTAssertEqual(sisoje::number_of_permutations(std::vector<int> {}), 1);
    XCTAssertEqual(sisoje::number_of_permutations(std::vector<int> {1}), 1);
    XCTAssertEqual(sisoje::number_of_permutations(std::vector<int> {1, 1}), 1);
    XCTAssertEqual(sisoje::number_of_permutations(std::vector<int> {1, 2}), 2);
    XCTAssertEqual(sisoje::number_of_permutations(std::vector<int> {1, 1, 2}), 3);
    XCTAssertEqual(sisoje::number_of_permutations(std::vector<int> {1, 2, 2}), 3);
}

-(void)testGeneratePermutation {
    const auto cvec = std::vector<int> {1, 2, 2, 3, 3, 3};
    const auto n = sisoje::number_of_permutations(cvec);
    XCTAssertGreaterThan(n, 0);
    auto vec = cvec;
    std::sort(vec.begin(), vec.end());
    for(int i = 0; i < n; ++i, std::next_permutation(SISOJE_BEG_END(vec))) {
        const auto perm = sisoje::generate_permutation(i, cvec);
        XCTAssertEqual(perm, vec);
    }
    XCTAssert(std::is_sorted(SISOJE_BEG_END(vec)));
}

-(void)testGeneratePermutationEdge {
    XCTAssertEqual(sisoje::generate_permutation(0, std::vector<int> {}), std::vector<int> {});
    XCTAssertEqual(sisoje::generate_permutation(0, std::vector<int> {1}), std::vector<int> {1});
}

@end
