#ifndef SISOJE_DEFIUNES_H_
#define SISOJE_DEFIUNES_H_

#define SISOJE_RANGE(COLECTION) std::begin(COLECTION), std::end(COLECTION)
#define SISOJE_SIZE(COLECTION) (std::end(COLECTION) - std::begin(COLECTION))
#define SISOJE_FOR(I,C) for(size_t I = 0; I < C; ++I)
#define SISOJE_STRIDE(I, C, IT, BEG, STRIDE) size_t I = 0; for(auto IT = BEG; I < C; ++I, IT += STRIDE)
#define SISOJE_IT(IT, BEG, END) for(auto IT = BEG; I != END; ++IT)
#define SISOJE_SUM(X) std::accumulate(SISOJE_RANGE(X), 0.0)
#define SISOJE_AVG(X) (SISOJE_SUM(X) / SISOJE_SIZE(X))
#define SISOJE_MAX(X) std::max_element(SISOJE_RANGE(X))
#define SISOJE_MIN(X) std::min_element(SISOJE_RANGE(X))

#endif // SISOJE_DEFIUNES_H_
