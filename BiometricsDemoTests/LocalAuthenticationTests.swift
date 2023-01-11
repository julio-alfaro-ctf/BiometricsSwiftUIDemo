//
//  LocalAuthenticationTests.swift
//  BiometricsDemoTests
//
//  Created by Julio Rico on 11/1/23.
//
import LocalAuthentication
import XCTest
@testable import BiometricsDemo

final class LocalAuthenticationTests: XCTestCase {
    
    func testSuccessfulAuthentication() {
        let localAuthenticationManager = LocalAuthenticatorManager(authenticationContext: LocalAuthenticatorManager.StubLocalAuthentication())
        
        XCTAssertTrue(localAuthenticationManager.biometricAvailable())
        localAuthenticationManager.authenticate(reason: "some message") { success, _ in
            XCTAssertTrue(success)
        }
    }
    
    func testFailedAuthentication() {
        let localAuthenticationManager = LocalAuthenticatorManager(authenticationContext: LocalAuthenticatorManager.StubLocalAuthenticationFailure())
        
        XCTAssertTrue(localAuthenticationManager.biometricAvailable())
        localAuthenticationManager.authenticate(reason: "some message") { success, _ in
            XCTAssertFalse(success)
        }
    }
}
