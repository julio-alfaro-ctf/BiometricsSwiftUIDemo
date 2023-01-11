//
//  LoginWithLocalAuthenticationTests.swift
//  BiometricsDemoTests
//
//  Created by Julio Rico on 11/1/23.
//

import XCTest
@testable import BiometricsDemo

final class LoginWithLocalAuthenticationTests: XCTestCase {
    final class LocalStorageStub: LocalStoreProtocol {
        var userName: String? = nil
        var password: String? = nil
        
        func save<T>(value: T, for key: String) {
            if key == K.userDefaultsPassword {
                password = value as? String
            } else {
                userName = value as? String
            }
        }
        
        func get<T>(for key: String) -> T? {
            if key == K.userDefaultsPassword {
                return password as? T
            } else {
                return userName as? T
            }
        }
        
        func remove(for key: String) {
            if key == K.userDefaultsPassword {
                password = nil
            } else {
                userName = nil
            }
        }
    }
    
    
    func testLoginWithNoBiometricsInDevice() {
        let localStorageStub = LocalStorageStub()
        let sut = ContentView.ViewModel(
            manager: LocalAuthenticatorManager(authenticationContext: LocalAuthenticatorManager.StubLocalAuthenticationNoBiometrics()),
            localStoreManager: localStorageStub)
        sut.userName = K.dummyUserName
        sut.password = K.dummyPassword
        sut.login(usingBiometrics: false, formUserName:sut.userName, formPassword: sut.password, handleResult: { _, _, _, _, _ in })
        
        XCTAssertEqual(sut.activeSection, .homePrivate)
        let localUserName: String? = localStorageStub.get(for: K.userDefaultsUserName)
        let localPassword: String? = localStorageStub.get(for: K.userDefaultsPassword)
        XCTAssertNil(localUserName)
        XCTAssertNil(localPassword)
    }
    
    func testLoginFailureWithBiometricsEnabledButFailureWhileEvaluatingLAPolicy() {
        let localStorageStub = LocalStorageStub()
        let sut = ContentView.ViewModel(
            manager: LocalAuthenticatorManager(authenticationContext: LocalAuthenticatorManager.StubLocalAuthenticationFailure()),
            localStoreManager: localStorageStub)
        sut.userName = K.dummyUserName
        sut.password = K.dummyPassword
        sut.login(usingBiometrics: true, formUserName:sut.userName, formPassword: sut.password, handleResult: { _, _, _, _, _ in })
        
        XCTAssertEqual(sut.activeSection, .login)
        let localUserName: String? = localStorageStub.get(for: K.userDefaultsUserName)
        let localPassword: String? = localStorageStub.get(for: K.userDefaultsPassword)
        XCTAssertNil(localUserName)
        XCTAssertNil(localPassword)
        
    }
    
    func testLoginWithBiometricsEnabledAndLAPolicySuccessful() {
        let exp = expectation(description: "biometrics expectation")
        let localStorageStub = LocalStorageStub()
        let sut = ContentView.ViewModel(
            manager: LocalAuthenticatorManager(authenticationContext: LocalAuthenticatorManager.StubLocalAuthentication()),
            localStoreManager: localStorageStub)
        sut.userName = K.dummyUserName
        sut.password = K.dummyPassword
        
        sut.login(usingBiometrics: true, formUserName: sut.userName, formPassword: sut.password, handleResult: { biometricsStatus, biometricError, _, _, _ in
            sut.handleResultForLocalAuthentication(success: biometricsStatus, error: biometricError, localStorage: localStorageStub, formUserName: sut.userName, formPassword: sut.password)
            exp.fulfill()
        })
        
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(sut.activeSection, .homePrivate)
        let localUserName: String? = localStorageStub.get(for: K.userDefaultsUserName)
        let localPassword: String? = localStorageStub.get(for: K.userDefaultsPassword)
        
        XCTAssertNotNil(localUserName)
        XCTAssertNotNil(localPassword)
        XCTAssertEqual(localUserName, K.dummyUserName)
        XCTAssertEqual(localPassword, K.dummyPassword)
    }
}
