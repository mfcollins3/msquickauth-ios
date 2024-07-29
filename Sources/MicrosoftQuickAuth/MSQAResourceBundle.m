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

#import <Foundation/Foundation.h>

// Returns the NSBundle containing the resources for the MicrosoftQuickAuth
// Swift package.
//
// Because the MicrosoftQuickAuth framework is loaded using Swift Package
// Manager and it includes resources, Swift Package Manager generates an
// extension to NSBundle to return the NSBundle containing the resources for
// the target. In Swift, this extension is Bundle.module, but in Objective-C
// it is defined using SWIFTPM_MODULE_BUNDLE.
//
// This function is exposed from the MicrosoftQuickAuth package for
// MicrosoftQuickAuthSwift to use to access the resources for rendering the
// sign in button using SwiftUI.
NSBundle *MSQAResourceBundle() {
    return SWIFTPM_MODULE_BUNDLE;
}
