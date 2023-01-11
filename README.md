

<h3 align="center">Biometrics Demo</h3>

  <p align="center">
    A project for Biometrics (LocalAuthentication) for SwiftUI
    <br />
  </p>
</div>

## About The Project
This project uses LocalAuthentication framework to use FaceID/TouchID from the device and add a new step verification to the Login section of an app.

The main ideas were taken from this sites:
https://www.hackingwithswift.com/books/ios-swiftui/using-touch-id-and-face-id-with-swiftui
https://navoshta.com/unit-tests-for-touch-id/

According with Apple documentation (https://developer.apple.com/documentation/localauthentication/)

* Create instance of `LAContext`, which allows us to query biometric status and perform the authentication check
* Ask that context whether it’s capable of performing biometric authentication – this is important because iPod touch has neither Touch ID nor Face ID.
* If biometrics are possible, then we kick off the actual request for authentication, passing in a closure to run when authentication completes.
* When the user has either been authenticated or not, our completion closure will be called and tell us whether it worked or not, and if not what the error was.
