#include <CoreFoundation/CoreFoundation.h>
#include <fonts.hpp>
#include "cpp_tests.hpp"
using namespace sisoje_tests;

inline double grayscale(const uint8_t* pPixelBytes) {
    return (0.299 / 255.0) * pPixelBytes[0] + (0.587 / 255.0) * pPixelBytes[1] + (0.114 / 255.0) * pPixelBytes[2];
}
inline double grayscaleR(const uint8_t* pPixelBytes) {
    return pPixelBytes[0] / 255.0;
}
inline double grayscaleG(const uint8_t* pPixelBytes) {
    return pPixelBytes[1] / 255.0;
}
inline double grayscaleB(const uint8_t* pPixelBytes) {
    return pPixelBytes[2] / 255.0;
}

template <typename COLORFUNC>
inline std::vector<std::string> makeAscii(const void* pRgba, const int width, const int height, double sharpness, COLORFUNC func) {
    constexpr size_t asciiFontWidth = 8;
    constexpr size_t asciiFontHeight = 13;
    constexpr size_t asciiCharacterNumber = 95;
    constexpr size_t asciiFontPixels = asciiFontHeight * asciiFontHeight;
    std::array<std::array<double, asciiFontWidth>, asciiFontHeight> charBits[asciiCharacterNumber];
    double charBrightness[asciiCharacterNumber];
    for(auto c=0; c<asciiCharacterNumber; ++c) {
        auto &charBit = charBits[c];
        sisoje::font_height<>::bit_lines(sisoje::defaultFont, c, charBit);
        const auto *pRaw = &charBit[0][0];
        charBrightness[c] = std::accumulate(pRaw, pRaw + asciiFontPixels, 0);
    }

    const double maxBrightness = *std::max_element(SISOJE_RANGE(charBrightness));

    for(auto c=0; c<asciiCharacterNumber; ++c) {
        charBrightness[c] /= maxBrightness;
    }

    const size_t asciiArtWidth = width / asciiFontWidth;
    const size_t asciiArtHeight = height / asciiFontHeight;

    std::vector<std::string> asciiArt(asciiArtHeight);
    double brightMatch[asciiCharacterNumber];
    for(auto ay=0; ay<asciiArtHeight; ++ay) {
        auto &asciiLine = asciiArt[ay];
        asciiLine.resize(asciiArtWidth);
        for(auto ax=0; ax<asciiArtWidth; ++ax) {
            const auto currentPixel = (ay * asciiFontHeight)*height + (ax * asciiFontWidth);
            std::fill(SISOJE_RANGE(brightMatch), 0);
            double grayall = 0;
            for(auto y=0; y<asciiFontHeight; ++y) {
                for(auto x=0; x<asciiFontWidth; ++x) {
                    const auto currentPixelOfs = y*height + x;
                    const auto pPixelBytes = (uint8_t*)pRgba + (currentPixel+currentPixelOfs)*4;
                    double grayLevel = func(pPixelBytes);
                    grayall += grayLevel;
                    for(auto c=0; c<asciiCharacterNumber; ++c) {
                        const auto bit = charBits[c][y][x];
                        brightMatch[c] += pow(bit ? (1 - grayLevel) : grayLevel, 1);
                    }
                }
            }
            grayall /= asciiFontPixels;
            for(auto c=0; c<asciiCharacterNumber; ++c) {
                brightMatch[c] = brightMatch[c] / asciiFontPixels * sharpness;
                brightMatch[c] += abs(charBrightness[c] - grayall) * (1 - sharpness);
            }
            const auto minIt = std::min_element(SISOJE_RANGE(brightMatch));
            asciiLine[ax] = 32 + (minIt - brightMatch);
        }
    }
    std::string &last = *asciiArt.rbegin();
    const std::string ponzi = " @PonziDemocracy";
    auto dst = last.rbegin();
    auto src = ponzi.rbegin();
    for(; dst != last.rend() && src != ponzi.rend(); src++, dst++) {
        *dst = *src;
    }
    return asciiArt;
}

@interface FontsTests : XCTestCase
@end

@implementation FontsTests

- (void)testFonts {
    const int width = 512;
    const int height = width;
    NSString *base64 = [NSString stringWithUTF8String:nole512.c_str()];
    NSData *data = [[NSData alloc] initWithBase64EncodedString:base64 options:0];
    XCTAssertEqual(width*height*4, data.length);
    auto date = [NSDate new];
    auto artGray = makeAscii(data.bytes, width, height, 0.80, grayscale);
    auto artR = makeAscii(data.bytes, width, height, 0.80, grayscaleR);
    auto artG = makeAscii(data.bytes, width, height, 0.80, grayscaleG);
    auto artB = makeAscii(data.bytes, width, height, 0.80, grayscaleB);
    auto elapsed = date.timeIntervalSinceNow;

    std::vector<std::string> art(artR.size());
    std::string htm;

    std::string colorTags[] = {"r", "g", "b"};

    for(auto y = 0; y < art.size(); ++y) {
        const std::array<std::string*, 3> lines = {&artR[y], &artG[y], &artB[y]};
        std::string &line = art[y];
        line.resize(lines[0]->size());
        for(auto x = 0; x < line.size(); ++x) {
            auto colorIndex = (x + y%2) % 3;
            auto ch = (*lines[colorIndex])[x];
            auto sch = sisoje::htmlEscape(ch);
            const auto &tag = colorTags[colorIndex];
            line[x] = ch;
            htm += "<"+tag+">"+sch+"</"+tag+">";
        }
        htm += "</br>";
    }

    NSURL * url = NSFileManager.defaultManager.homeDirectoryForCurrentUser;
    url = [url URLByAppendingPathComponent:@"ascii.htm" isDirectory:NO];

    NSData *fff = [NSData dataWithBytes:htm.data() length:htm.length()];
    [fff writeToURL:url atomically:YES];

    NSLog(@"Asci took: %@", @(elapsed));
    for(const auto& line: artGray) {
        for(char ch: line) {
            std::cout << ch;
        }
        std::cout << std::endl;
    }

    NSLog(@"Asci took: %@", @(elapsed));
    for(const auto& line: art) {
        for(char ch: line) {
            auto sch = sisoje::htmlEscape(ch);
            std::cout << sch;
        }
        std::cout << "</br>" << std::endl;
    }
    NSLog(@"Asci took: %@", @(elapsed));
}

@end
