#include <CoreFoundation/CoreFoundation.h>
#include <fonts.hpp>
#include "cpp_tests.hpp"
using namespace sisoje_tests;

template <typename T>
inline T grayscale(const uint8_t* pPixelBytes) {
    return (0.299 / 255.0) * T(pPixelBytes[0]) + (0.587 / 255.0) * T(pPixelBytes[1]) + (0.114 / 255.0) * T(pPixelBytes[2]);
}

template <size_t COMPONENTS = 4, typename FONT>
inline auto makeAsciiComponent(const uint8_t* pOrigin, size_t width, const FONT& font) {
    typedef typename FONT::level_type T;
    std::array<sisoje::letter_similarity<T>, FONT::characters()> similarity;
    T patchLevel = 0;
    SISOJE_STRIDE(y, FONT::height(), py, pOrigin, width * COMPONENTS) {
        SISOJE_STRIDE(x, FONT::width(), px, py, COMPONENTS) {
            const T pixelLevel = *px / T(255);
            SISOJE_FOR(c, FONT::characters()) {
                similarity[c].detail += font.letters[c].pixels[y][x] ? (1 - pixelLevel) : pixelLevel;
            }
            patchLevel += pixelLevel;
        }
    }
    patchLevel /= FONT::area();
    patchLevel *= font.maxBrighness();
    SISOJE_FOR(c, FONT::characters()) {
        similarity[c].level = abs(font.letters[c].allAverage - patchLevel);
        similarity[c].detail /= FONT::area();
    }
    return similarity;
}

std::vector<std::vector<sisoje::similarity_type>> asciiArtRGB(const void* pRgba, size_t width, size_t height, const sisoje::font_type& font) {
    const size_t numCharsX = width / font.width();
    const size_t numCharsY = height / font.height();
    std::vector<std::vector<sisoje::similarity_type>> result(numCharsY);
    SISOJE_STRIDE(y, numCharsY, py, (uint8_t*)pRgba, width*font.height()*4) {
        result[y].resize(numCharsX);
        SISOJE_STRIDE(x, numCharsX, px, py, font.width()*4) {
            result[y][x] = makeAsciiComponent(px + (x + y%2) % 3, width, font);
        }
    }
    return result;
}

std::vector<std::vector<char>> asciiArtByLevel(const std::vector<std::vector<sisoje::similarity_type>>& similarity, float koef) {
    std::vector<std::vector<char>> result(similarity.size());
    SISOJE_FOR(y, similarity.size()) {
        const auto& similarityLine = similarity[y];
        result[y].resize(similarityLine.size());
        SISOJE_FOR(x, similarityLine.size()) {
            const auto& similarityArray = similarityLine[x];
            const auto minIt = std::min_element(SISOJE_RANGE(similarityArray), [koef](const auto &x, const auto &y) {
                return x.detail*(1-koef) + x.level*koef < y.detail*(1-koef) + y.level*koef;
            });

            const auto minIndex = minIt - std::begin(similarityArray);
            result[y][x] = 32 + minIndex;
        }
    }
    return result;
}




@interface FontsTests : XCTestCase
@end

@implementation FontsTests

- (void)testFonts {

    const int width = 1024;
    const int height = 1024;
    /*
    NSURL * urla = NSFileManager.defaultManager.homeDirectoryForCurrentUser;
    urla = [urla URLByAppendingPathComponent:@"djolo.rgba" isDirectory:NO];
    NSData *data = [NSData dataWithContentsOfURL:urla];*/

    NSString *base64 = [NSString stringWithUTF8String:daca1024.c_str()];
    NSData *data = [[NSData alloc] initWithBase64EncodedString:base64 options:0];
    XCTAssertEqual(width*height*4, data.length);

    NSDate* date = [NSDate new];
    const auto font = sisoje::font_type::make_font(sisoje::defaultFont);
    NSLog(@"Font loading: %@", @(date.timeIntervalSinceNow));
    date = [NSDate new];
    auto similar = asciiArtRGB(data.bytes, width, height, font);
    auto chars = asciiArtByLevel(similar, 0.175);
    auto elapsed = date.timeIntervalSinceNow;
    NSLog(@"Asci took: %@", @(elapsed));
    for(const auto& line: chars) {
        for(char ch: line) {
            std::cout << ch;
        }
        std::cout << std::endl;
    }

    std::string htm = "<!DOCTYPE html><html><body><style type='text/css'>\
    body {\
       color:#ffffff;\
       background-color:#000000;\
       font-family:courier, courier new, serif;\
       font-size:8px;\
    }\
    r {color:#ff0000;}\
    g {color:#00ff00;}\
    b {color:#0000ff;}\
    </style>";
    
    std::string colorTags[] = {"r", "g", "b"};
    SISOJE_FOR(y, chars.size()) {
        const auto& charLine = chars[y];
        SISOJE_FOR(x, charLine.size()) {
            auto colorIndex = (x + y%2) % 3;
            auto sch = sisoje::htmlEscape(charLine[x]);
            const auto &tag = colorTags[colorIndex];
            htm += "<"+tag+">"+sch+"</"+tag+">";
        }
        htm += "</br>";
    }
    htm += "</body></html>";

    NSURL * url = NSFileManager.defaultManager.homeDirectoryForCurrentUser;
    url = [url URLByAppendingPathComponent:@"ascii.htm" isDirectory:NO];
    NSData *fff = [NSData dataWithBytes:htm.data() length:htm.length()];
    [fff writeToURL:url atomically:YES];
}

@end
