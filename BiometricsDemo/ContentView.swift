//
//  ContentView.swift
//  BiometricsDemo
//
//  Created by Julio Rico on 10/1/23.
//
import LocalAuthentication
import SwiftUI

enum K {
    static let userDefaultsStorageID = "BiometricsEnabled"
    static let userDefaultsUserName = "LocalUserName"
    static let userDefaultsPassword = "LocalPassword"
    static let dummyUserName = "john.doe"
    static let dummyPassword = "password"
}

enum Sections {
    case login, homePrivate
}

struct ContentView: View {
    
    
    @StateObject var viewModel = ViewModel(
        manager: LocalAuthenticatorManager(authenticationContext: LAContext()),
        localStoreManager: StoreManager()
    )
    
    
    var body: some View {
        VStack {
            if viewModel.activeSection == .login {
                TextField("Username", text: $viewModel.userName)
                    .padding()
                    .textInputAutocapitalization(.never)
                
                SecureField("Password", text: $viewModel.password)
                    .padding()
                
                if viewModel.localAuthenticationManager.biometricAvailable() {
                    Toggle("Use FaceID", isOn: $viewModel.useBiometrics)
                        .padding()
                }
                
                Button("Sign in") {
                    viewModel.login(
                        usingBiometrics: viewModel.useBiometrics,
                        formUserName: viewModel.userName,
                        formPassword: viewModel.password,
                        handleResult: viewModel.handleResultForLocalAuthentication
                    )
                }
                .buttonStyle(.bordered)
            } else {
                PrivateHomeView(activeSection: $viewModel.activeSection)
            }
        }
        .padding()
        .alert(viewModel.messageToDisplay, isPresented: $viewModel.showAlert) {
            Button("Ok") {
                viewModel.showAlert.toggle()
            }
        }
    }
    
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
