//
//  ContentViewModel.swift
//  BiometricsDemo
//
//  Created by Julio Rico on 11/1/23.
//

import Foundation

extension ContentView {
    final class ViewModel: ObservableObject {
        @Published var userName = ""
        @Published var password = ""
        @Published var useBiometrics = false
        @Published var showAlert = false
        @Published var messageToDisplay = ""
        @Published var activeSection: Sections = .login

        let localAuthenticationManager: LocalAuthenticatorManager
        let localStoreManager: LocalStoreProtocol
        
        init(manager: LocalAuthenticatorManager, localStoreManager: LocalStoreProtocol) {
            self.localAuthenticationManager = manager
            self.localStoreManager = localStoreManager
        }
        
        
        
        func login(usingBiometrics: Bool, formUserName: String, formPassword: String, handleResult: @escaping (Bool, Error?, LocalStoreProtocol, String, String) -> Void) {
            if usingBiometrics {
                // check if there is a previous session saved
                localAuthenticationManager.authenticate(reason: "Please Login in with FaceID") { success, error in
                    DispatchQueue.main.async {
                        handleResult(success, error, self.localStoreManager, formUserName, formPassword)
                    }
                }
            } else {
                guard validateForm() else { return }
                if validate(userName: formUserName, password: formPassword) {
                    activeSection = .homePrivate
                }
            }
        }
        
        
        private func validateForm() -> Bool {
            guard !userName.isEmpty && !password.isEmpty else {
                messageToDisplay = "Missing Fields"
                showAlert = true
                return false
            }
            return true
        }
        
        func handleResultForLocalAuthentication(success: Bool, error: Error?, localStorage: LocalStoreProtocol, formUserName: String, formPassword: String) {
            if success {
                let localUserName: String? = localStorage.get(for: K.userDefaultsUserName)
                let localPassword: String? = localStorage.get(for: K.userDefaultsPassword)
                if let localPassword,
                   let localUserName {
                    if validate(userName: localUserName, password: localPassword) {
                        activeSection = .homePrivate
                    } else {
                        // remove user defaults
                        localStorage.remove(for: K.userDefaultsPassword)
                        localStorage.remove(for: K.userDefaultsUserName)
                    }
                } else {
                    guard validateForm() else { return }
                    if validate(userName: formUserName, password: formPassword) {
                        localStorage.save(value: formUserName, for: K.userDefaultsUserName)
                        localStorage.save(value: formPassword, for: K.userDefaultsPassword)
                        activeSection = .homePrivate
                    }
                }
            } else {
                self.messageToDisplay = "Error \(String(describing: error?.localizedDescription))"
                self.showAlert = true
            }
        }
        
        private func validate(userName: String, password: String) -> Bool {
            if userName == K.dummyUserName && password == K.dummyPassword {
                return true
            } else {
                messageToDisplay = "Invalid credentials"
                showAlert = true
                
                return false
            }
        }
    }
}
