# Microsoft Quick Authentication for iOS

This package originated from the source code from the [microsoft/quick-authentication-mobile](https://github.com/microsoft/quick-authentication-mobile) repository. I extracted the Objective-C and Swift source code for iOS, updated the version of [MSAL](https://github.com/AzureAD/microsoft-authentication-library-for-objc) framework, and converted the library to be installable using Swift Package Manager.

## Getting Started

### Installing the Swift Package

To install this package in your application, you can reference the package from `https://github.com/mfcollins3/msquickauth-ios.git` or update the `dependencies` section in your `Package.swift` file:

```swift
dependencies: [
    .package(
        url: "https://github.com/mfcollins3/msquickauth-ios.git", 
        exact: "0.1.0"
    )
],
```

After installing the project, you must [configure your application to use MSAL](https://learn.microsoft.com/en-us/entra/msal/objc/install-and-configure-msal#configuring-your-project-to-use-msal). For more information about using MSAL and Microsoft Identity with your application, see the [Next Steps](https://learn.microsoft.com/en-us/entra/msal/objc/install-and-configure-msal#configuring-your-project-to-use-msal) in the [MSAL README](https://github.com/AzureAD/microsoft-authentication-library-for-objc/blob/dev/README.md).

### Creating and accessing the Microsoft Sign In Client

The Microsoft Quick Authentication code requires a `MSQASignInClient` object to invoke MSAL to authenticate the user. The best way that I've found to create and access this client is to use the SwiftUI environment. I created a custom `EnvironmentKey` type and added the `MSQASignInClient` object to the `EnvironmentValues` type.

In your project, create a file named `MSQASignInClientKey.swift` and add the following code:

```swift
import MicrosoftQuickAuth
import SwiftUI

struct MSQASigninClientKey: EnvironmentKey {
    static let defaultValue: MSQASignInClient = MSQASignInClientKey.makeSignInClient()

    private static func makeSignInClient() -> MSQASignInClient {
        var error: NSError?
        let signInClient = MSQASignInClient(
            configuration: .init(clientID: "PUT-YOUR-CLIENT-ID-HERE"),
            error: &error
        )
        if let error {
            fatalError("Failed to initialize Microsoft Quick Auth: \(error.localizedDescription)")
        }

        return signInClient
    }
}

extension EnvironmentValues {
    var microsoftSignInClient: MSQASignInClient {
        get {
            self[MSQASignInClientKey.self]
        }
        set {
            self[MSQASignInClientKey.self] = newValue
        }
    }
}
```

In my application, I created a wrapper View that encapsulates most of the Microsoft Quick Auth framework. For example, I created a `SignUpWithMicrosoftButton` view for user sign up using a Microsoft account:

```swift
import MicrosoftQuickAuth
import MicrosoftQuickAuthSwift
import SwiftUI

struct SignUpWithMicrosoftButton: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var viewModel: MSQASignInButtonViewModel

    // SignUpResult is a custom type I created to return the identity token.
    private var completion: (Result<SignUpResult, Error>) -> Void

    init(
        microsoftSignInClient: MSQASignInClient,
        completion: @escaping SignUpView.Completion
    ) {
        _viewModel = .init(
            wrappedValue: .init(
                signInClient: microsoftSignInClient,
                presentingViewController: nil,
                completionBlock: { account, error in
                if let error {
                    let nserror = error as NSError
                    if nserror.code == MSALError.userCanceled.rawValue {
                        // SignUpError is an enum that conforms to Error
                        completion(.failure(SignUpError.canceled))
                        return
                    }

                    completion(.failure(error))
                    return
                }

                guard let idToken = account?.idToken else {
                    completion(.failure(SignUpError.tokenNotProvided))
                    return
                }

                completion(.success(.init(idToken: .idToken(idToken))))
            ),
            text: .signUpWith,
            shape: .rounded,
            layout: .logoTextCenter
        )
        self.completion = completion
    }

    var body: some View {
        MSQASignInButton(viewModel: viewModel)
            .onChange(of: colorScheme, initial: true) { _, newValue in
                viewModel.theme = newValue == .dark ? .dark : .light
            }
    }
}
```

In my `SignUpView`, I access the `MSQASignInClient` object from the environment and use the `SignUpWithMicrosoftButton` view:

```swift
struct SignUpView: View {
    @Environment(\.microsoftSignInClient) private var microsoftSignInClient

    var body: some View {
        VStack(spacing: 8) {
            SignUpWithMicrosoftButton(microsoftSignInClient: microsoftSignInClient) {
                ... // handle the result
            }
        }
    }
}
```

Similar code should work for login as well. Just remember to update the view model to indicate that the button is for `sign in` and not `sign up`.
