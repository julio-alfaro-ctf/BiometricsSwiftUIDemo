//
//  PrivateHomeView.swift
//  BiometricsDemo
//
//  Created by Julio Rico on 10/1/23.
//

import SwiftUI

struct PrivateHomeView: View {
    @Binding var activeSection: Sections
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Secure Area. Only authenticated users.")
            Button("Logout") {
                activeSection = .login
            }
            .buttonStyle(.bordered)
        }
    }
}

struct PrivateHomeView_Previews: PreviewProvider {
    static var previews: some View {
        PrivateHomeView(activeSection: .constant(.login))
    }
}
