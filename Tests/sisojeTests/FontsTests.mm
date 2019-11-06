#include <CoreFoundation/CoreFoundation.h>
#include <fonts.hpp>
#include "cpp_tests.hpp"
using namespace sisoje_tests;

@interface FontsTests : XCTestCase
@end

@implementation FontsTests

- (void)testFonts {
    std::map<int, std::vector<char>> brighnerses;
    std::unordered_map<char, std::array<std::bitset<8>, 8>> charBits;
    std::unordered_map<char, int> charBr;
    for(int c=32; c<127; ++c) {
        const auto bitLines = sisoje::font_height_8::bit_lines(sisoje::pDefaultFont, c);
        charBits[c] = bitLines;
        int bright = 0;
        for(const auto &bitLine: bitLines) {
            bright += bitLine.count();
            auto bits = bitLine.to_string();
            std::reverse(bits.begin(), bits.end());
            //std::cout << bits << std::endl;
        }
        brighnerses[bright].push_back(c);
        charBr[c] = bright;
        //std::cout << std::endl;
    }

    const float maxBrightness = brighnerses.rbegin()->first;

    NSString *base64 = [NSString stringWithUTF8String:lena512.c_str()];
    NSData *data = [[NSData alloc] initWithBase64EncodedString:base64 options:0];
    XCTAssertEqual(512*512*4, data.length);
    const uint8_t *pBytes = (uint8_t*)data.bytes;
    const int width = 512;
    const int height = 512;
    const int asciiFontWidth = 8;
    const int asciiFontHeight = 8;
    const int asciiFontPixels = asciiFontWidth * asciiFontHeight;
    const int maxPixelSumPerAscii = asciiFontPixels * 255 * 3;
    const int numberOfPixels = width * height;

    typedef uint32_t pixel_sum_type;

    const int asciiArtWidth = width / asciiFontWidth;
    const int asciiArtHeight = height / asciiFontHeight;

    char asciiArt[asciiArtHeight][asciiArtWidth];

    std::unordered_map<char, pixel_sum_type> brightMatch;
    for(auto ay=0; ay<asciiArtHeight; ++ay) {
        for(auto ax=0; ax<asciiArtWidth; ++ax) {
            for(auto it=brightMatch.begin(); it != brightMatch.end(); ++it) {
                it->second = 0;
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
                        const auto bit = charBits[c].at(y)[x];
                        auto dif = bit ? (3*255 - grayLevel) : grayLevel;
                        brightMatch[c] += dif;
                    }
                }
            }
            const auto minIt = std::min_element(brightMatch.begin(), brightMatch.end(), [](auto x, auto y) {
                return x.second < y.second;
            });
            const auto myc = minIt->first;
            asciiArt[ay][ax] = myc;
            std::cout << myc;
        }
        std::cout << std::endl;
    }
    std::cout << std::endl;
}

@end
