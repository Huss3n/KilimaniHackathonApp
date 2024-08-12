//
//  AuthButton.swift
//  KilimaniHackathon
//
//  Created by Muktar Aisak on 02/08/2024.
//

import SwiftUI

struct AuthButton: View {
    var title: String
    var action: () -> ()

    var body: some View {
        Button(action: {
            action()
        }, label: {
            Text(title)
                .font(.headline)
                .foregroundStyle(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(.blue)
                .cornerRadius(25)
        })
    }
}

#Preview {
    AuthButton(title: "Login", action: {})
}
