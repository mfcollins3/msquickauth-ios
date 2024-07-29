// Copyright 2024 Michael F. Collins, III
//
// Permission is hereby granted, free of charge, to any person obtaining a
// copy of this software and associated documentation files (the "Software"),
// to deal in the Software without restriction, including without limitation
// the rights to use, copy, modify, merge, publish, distribute, sublicense,
// and/or sell copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT, OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
// IN THE SOFTWARE.

#import <CoreText/CoreText.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// Reference: https://dev.jeremygale.com/swiftui-how-to-use-custom-fonts-and-images-in-a-swift-package-cl0k9bv52013h6bnvhw76alid

BOOL MSQARegisterFonts(NSError **error) {
    @autoreleasepool {
        NSURL * _Nullable url = [SWIFTPM_MODULE_BUNDLE URLForResource:@"SegoeUI-SemiBold" withExtension:@"ttf"];
        NSCAssert(url != NULL, @"The SegoeUI-SemiBold fold was not found");
        CFErrorRef cfError = NULL;
        BOOL success = CTFontManagerRegisterFontsForURL((__bridge CFURLRef)url, kCTFontManagerScopeProcess, &cfError);
        if (success && cfError == NULL) {
            return YES;
        }
        
        if (error) {
            *error = (__bridge NSError *)cfError;
        }
        
        return NO;
    }
}
