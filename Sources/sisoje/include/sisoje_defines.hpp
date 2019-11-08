#ifndef SISOJE_DEFIUNES_H_
#define SISOJE_DEFIUNES_H_

#define SISOJE_RANGE(COLECTION) std::begin(COLECTION), std::end(COLECTION)
#define SISOJE_SIZE(COLECTION) (std::end(COLECTION) - std::begin(COLECTION))
#define SISOJE_FOR(I,C) for(size_t I=0; I<C; ++I)
#define SISOJE_IT(IT, BEG, END, OFFSET, STRIDE) for(auto IT = BEG + OFFSET; IT < END; IT += STRIDE)
#define SISOJE_SUM(X) std::accumulate(SISOJE_RANGE(X), 0)
#define SISOJE_AVG(X) (SISOJE_SUM(X) / SISOJE_SIZE(X))
#define SISOJE_MAX(X) (*std::max_element(SISOJE_RANGE(X)))
#define SISOJE_MIN(X) (*std::min_element(SISOJE_RANGE(X)))

#endif // SISOJE_DEFIUNES_H_
