#ifndef SISOJE_FONTS_H_
#define SISOJE_FONTS_H_

#include <array>
#include <bitset>

#include "font-headers/AVGA2_8x8.h"
#include "font-headers/IBM_VGA_8x8.h"
#include "sisoje_defines.hpp"


namespace sisoje {

inline uint8_t reverse_bits(uint8_t b) {
    return (uint8_t)(((b * 0x0802U & 0x22110U) | (b * 0x8020U & 0x88440U)) * 0x10101U >> 16);
}

template <size_t HEIGHT>
struct font_height {
    constexpr static auto bit_lines(const void *pFont, int index) {
        std::array<std::bitset<8>, HEIGHT> ret;
        const uint8_t *pBase = (uint8_t*)pFont + index*HEIGHT;
        for(int i=0;i<HEIGHT;++i) {
            ret[i] = std::bitset<8>(reverse_bits(pBase[i]));
        }
        return ret;
    }
};

typedef font_height<8> font_height_8;
typedef font_height<16> font_height_16;

static const void *pDefaultFont = font_IBM_VGA_8x8;

} // namespace sisoje
#endif // SISOJE_FONTS_H_
