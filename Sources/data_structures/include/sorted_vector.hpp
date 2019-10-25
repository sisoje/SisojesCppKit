#include <vector>

template<bool ASCENDING>
struct element_comparer {};

template<>
struct element_comparer<true> {
    template <typename T>
    static bool areOrdered(const T &x, const T &y) {
        return x < y;
    }
};

template<>
struct element_comparer<false> {
    template <typename T>
    static bool areOrdered(const T &x, const T &y) {
        return x > y;
    }
};

template<bool ASCENDING, bool FIRST>
struct pivot_strategy {};

template<bool ASCENDING>
struct pivot_strategy<ASCENDING, true> {
    template <typename T>
    static bool shouldUseUpperHalf(const T &pivot, const T &element) {
        return element_comparer<ASCENDING>::areOrdered(pivot, element);
    }
};

template<bool ASCENDING>
struct pivot_strategy<ASCENDING, false> {
    template <typename T>
    static bool shouldUseUpperHalf(const T &pivot, const T &element) {
        return
        element_comparer<ASCENDING>::areOrdered(pivot, element) ||
        !element_comparer<ASCENDING>::areOrdered(element, pivot);
    }
};

template<bool ASCENDING, bool FIRST>
struct insertion_index_finder {
    template <typename T>
    static int findInsertionIndex(const T *array, int count, const T &element) {
        int lowerBound = 0;
        int upperBound = count;
        while (lowerBound != upperBound) {
            auto midIndex = (upperBound + lowerBound) / 2;
            auto pivot = array[midIndex];
            if (pivot_strategy<ASCENDING, FIRST>::shouldUseUpperHalf(pivot, element)) {
                lowerBound = midIndex + 1;
            } else {
                upperBound = midIndex;
            }
        }
        return lowerBound;
    }
};

template<bool ASCENDING>
struct sorted_array {
    template <typename T>
    static bool isSorted(const T *array, int count) {
        for(int i=1;i<count;++i) {
            if (element_comparer<ASCENDING>::areOrdered(array[i], array[i-1])) {
                return false;
            }
        }
        return true;
    }

    template <typename T>
    static int firstIndex(const T *array, int count, const T &element) {
        auto index = insertion_index_finder<ASCENDING, true>::findInsertionIndex(array, count, element);
        return index < count && array[index] == element ? index : -1;
    }

    template <typename T>
    static int lastIndex(const T *array, int count, const T &element) {
        auto index = insertion_index_finder<ASCENDING, false>::findInsertionIndex(array, count, element) - 1;
        return index >= 0 && array[index] == element ? index : -1;
    }
};

template<bool ASCENDING>
struct sorted_vector {
    template <typename T>
    static bool isSorted(const std::vector<T> &vec) {
        return sorted_array<ASCENDING>::isSorted(vec.data(), vec.size());
    }

    template <typename T>
    static int firstIndex(const std::vector<T> &vec, const T &element) {
        return sorted_array<ASCENDING>::firstIndex(vec.data(), vec.size(), element);
    }

    template <typename T>
    static int lastIndex(const std::vector<T> &vec, const T &element) {
        return sorted_array<ASCENDING>::lastIndex(vec.data(), vec.size(), element);
    }

    template <typename T>
    static int insert(std::vector<T> &vec, const T &element) {
        auto index = insertion_index_finder<ASCENDING, false>::findInsertionIndex(vec.data(), vec.size(), element);
        vec.insert(vec.begin()+index, element);
        return index;
    }

    template <typename T>
    static int removeOne(std::vector<T> &vec, const T &element) {
        auto index = lastIndex(vec, element);
        if (index >= 0) {
            vec.erase(vec.begin()+index);
        }
        return index;
    }

    template <typename T>
    static int removeAll(std::vector<T> &vec, const T &element) {
        auto index0 = firstIndex(vec, element);
        if (index0 >= 0) {
            auto index1 = lastIndex(vec, element);
            vec.erase(vec.begin()+index0, vec.begin()+index1+1);
        }
        return index0;
    }
};
