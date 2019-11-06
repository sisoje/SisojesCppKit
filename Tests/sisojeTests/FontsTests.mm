#include <CoreFoundation/CoreFoundation.h>
#include <fonts.hpp>
#include "cpp_tests.hpp"
using namespace sisoje_tests;

@interface FontsTests : XCTestCase
@end

@implementation FontsTests

- (void)testFonts {
    constexpr int asciiFontWidth = 8;
    constexpr auto asciiFontHeight = 13;
    typedef uint32_t pixel_sum_type;
    std::array<std::bitset<asciiFontWidth>, asciiFontHeight> charBits[256];
    for(int c=32; c<127; ++c) {
        charBits[c] = sisoje::font_height<asciiFontHeight>::bit_lines(sisoje::defaultFont, c-32);
        if (c == 'j') {
            const auto &bitLines = charBits[c];
            for(const auto &bitLine: bitLines) {
                for(int i=0;i<8;++i) {
                    const auto bit = bitLine[i];
                    char ch = bit ? 'X' : '.';
                    std::cout << ch;
                }
                std::cout << std::endl;
            }
            std::cout << std::endl;
        }
    }

    NSString *base64 = [NSString stringWithUTF8String:lena512.c_str()];
    NSData *data = [[NSData alloc] initWithBase64EncodedString:base64 options:0];
    XCTAssertEqual(512*512*4, data.length);
    const uint8_t *pBytes = (uint8_t*)data.bytes;
    const int width = 512;
    const int height = 512;
    const int asciiArtWidth = width / asciiFontWidth;
    const int asciiArtHeight = height / asciiFontHeight;

    char asciiArt[asciiArtHeight][asciiArtWidth];

    pixel_sum_type brightMatch[256];
    for(auto ay=0; ay<asciiArtHeight; ++ay) {
        for(auto ax=0; ax<asciiArtWidth; ++ax) {
            for(int c=32; c<127; ++c) {
                brightMatch[c] = 0;
            }
            for(auto y=0; y<asciiFontHeight; ++y) {
                for(auto x=0; x<asciiFontWidth; ++x) {
                    const auto currentPixel = ((ay * asciiFontHeight) + y)*height + ((ax * asciiFontWidth) + x);
                    const auto pPixelBytes = pBytes + currentPixel*4;
                    pixel_sum_type grayLevel = 0;
                    grayLevel += pPixelBytes[0];
                    grayLevel += pPixelBytes[1];
                    grayLevel += pPixelBytes[2];
                    for(int c=32; c<127; ++c) {
                        const auto bit = charBits[c][y][x];
                        brightMatch[c] += bit ? (3*255 - grayLevel) : grayLevel;
                    }
                }
            }
            const auto minIt = std::min_element(brightMatch+32, brightMatch+127);
            const char myc = minIt - brightMatch;
            asciiArt[ay][ax] = myc;
            std::cout << myc;
        }
        std::cout << std::endl;
    }
    std::cout << std::endl;
}

@end
