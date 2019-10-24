#include "permutations.hpp"

int Permutations::numberOfPermutations(int N) {
    return N <= 1 ? 1 : (N * numberOfPermutations(N-1));
}
