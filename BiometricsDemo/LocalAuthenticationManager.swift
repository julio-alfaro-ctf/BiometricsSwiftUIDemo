//
//  LocalAuthenticationManager.swift
//  BiometricsDemo
//
//  Created by Julio Rico on 10/1/23.
//

import LocalAuthentication
import SwiftUI

public class LocalAuthenticatorManager {
    private(set) var context: LAContext
    
    enum LocalAuthenticationError: Error {
        case biometricNotAvailable, biometricCheckingFailed
    }
    
    init(authenticationContext: LAContext) {
        self.context = authenticationContext
    }
    
    func biometricAvailable() -> Bool {
        context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }

    public func authenticate(reason: String, completion: @escaping (Bool, Error?) -> Void) {
        guard biometricAvailable() else {
            completion(false, LocalAuthenticationError.biometricNotAvailable)
            return
        }
        
        // Check for Users Defaults flag, to verify if the Biometrics is still active
        
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
            if success {
                completion(true, nil)
            } else {
                completion(false, LocalAuthenticationError.biometricCheckingFailed)
            }
        }
    }
}


extension LocalAuthenticatorManager {
    class StubLocalAuthentication: LAContext {
        override func evaluatePolicy(_ policy: LAPolicy, localizedReason: String, reply: @escaping (Bool, Error?) -> Void) {
            reply(true, nil)
        }
        
        override func canEvaluatePolicy(_ policy: LAPolicy, error: NSErrorPointer) -> Bool {
            true
        }
    }
    
    class StubLocalAuthenticationFailure: LAContext {
        override func evaluatePolicy(_ policy: LAPolicy, localizedReason: String, reply: @escaping (Bool, Error?) -> Void) {
            reply(false, NSError(domain: "an error", code: 0))
        }
        
        override func canEvaluatePolicy(_ policy: LAPolicy, error: NSErrorPointer) -> Bool {
            true
        }
    }
    
    class StubLocalAuthenticationNoBiometrics: LAContext {
        override func evaluatePolicy(_ policy: LAPolicy, localizedReason: String, reply: @escaping (Bool, Error?) -> Void) {
            reply(false, NSError(domain: "an error", code: 0))
        }
        
        override func canEvaluatePolicy(_ policy: LAPolicy, error: NSErrorPointer) -> Bool {
            false
        }
    }
    
}
