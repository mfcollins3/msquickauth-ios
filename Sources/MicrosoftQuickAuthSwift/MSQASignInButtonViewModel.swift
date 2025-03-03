//------------------------------------------------------------------------------
//
// Copyright (c) Microsoft Corporation.
// All rights reserved.
//
// This code is licensed under the MIT License.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files(the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and / or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions :
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
//-----------------------------------------------------------------------------

import Foundation
import MicrosoftQuickAuth

/// A view model for Microsoft Quick Auth sign in button publishing changes for the button's type, theme, size, etc.
@available(iOS 13.0, *)
@MainActor
public class MSQASignInButtonViewModel: ObservableObject {
  @Published public var type: MSQASignInButtonType
  @Published public var theme: MSQASignInButtonTheme
  @Published public var size: MSQASignInButtonSize
  @Published public var text: MSQASignInButtonText
  @Published public var shape: MSQASignInButtonShape
  @Published public var layout: MSQASignInButtonLayout
  @Published public var state: MSQASignInButtonState

  private var signInClient: MSQASignInClient
  private var presentingViewController: UIViewController?
  private var completionBlock: MSQACompletionBlock

  /// Creates an instance of the view model for Microsoft Quick Auth sign in button.
  /// - parameter signInClient: An instance of properly configured `MSQASignInClient`.
  /// - parameter presentingViewController: The view controller on which the sign in page will be presented.
  ///     Defaults to the root view controller of the first window.
  /// - parameter completionBlock: The completion to run when sign in complete.
  /// - parameter type: The `MSQASignInButtonType` to use.
  ///     Defaults to `.standard`.
  /// - parameter theme: The `MSQASignInButtonTheme` to use.
  ///     Defaults to `.light`.
  /// - parameter size: The `MSQASignInButtonSize` to use.
  ///     Defaults to `.large`.
  /// - parameter text: The `MSQASignInButtonText` to use.
  ///     Defaults to `.signInWith`.
  /// - parameter shape: The `MSQASignInButtonShape` to use.
  ///     Defaults to `.rectangular`.
  /// - parameter layout: The `MSQASignInButtonLayout` to use.
  ///     Defaults to `.logoTextLeft`.
  /// - parameter state: The `MSQASignInButtonState` to use.
  ///     Defaults to `.normal`.
  public init(
    signInClient: MSQASignInClient,
    presentingViewController: UIViewController?,
    completionBlock: @escaping MSQACompletionBlock,
    type: MSQASignInButtonType = .standard,
    theme: MSQASignInButtonTheme = .light,
    size: MSQASignInButtonSize = .large,
    text: MSQASignInButtonText = .signInWith,
    shape: MSQASignInButtonShape = .rectangular,
    layout: MSQASignInButtonLayout = .logoTextLeft,
    state: MSQASignInButtonState = .normal
  ) {
    self.signInClient = signInClient
    self.presentingViewController = presentingViewController
    self.completionBlock = completionBlock
    self.type = type
    self.theme = theme
    self.size = size
    self.text = text
    self.shape = shape
    self.layout = layout
    self.state = state
  }

  var buttonStyle: MSQASignInButtonStyle {
    return MSQASignInButtonStyle(
      type: type, theme: theme, size: size, text: text, shape: shape, layout: layout, state: state)
  }

  func signIn() {
    if let viewController = presentingViewController {
      signInClient.signIn(with: viewController, completionBlock: completionBlock)
      return
    }
    guard let viewController = (UIApplication.shared.connectedScenes.first(where: { $0.session.role == .windowApplication }) as? UIWindowScene)?.windows.first?.rootViewController else {
      return
    }
    signInClient.signIn(with: viewController, completionBlock: completionBlock)
  }
}
