//
//  Logo.swift
//  KilimaniHackathon
//
//  Created by Muktar Aisak on 02/08/2024.
//

import SwiftUI

struct Logo: View {
    var body: some View {
        HStack(alignment: .center) {
            Image("Image")
                .renderingMode(.template)
                .resizable()
                .foregroundColor(Color.blue)
                .frame(width: 40, height: 40)
            
            Text("Kilimani Hood")
                .font(.title2.bold())
                .foregroundStyle(.blue)
        }
    }
}

#Preview {
    Logo()
}
