//
//  DemoModeBackground.swift
//  MW4-Savannah
//
//  Created by Nicolas LEFEBVRE on 10/25/22.
//

import SwiftUI

struct DemoModeBackground: View {
    var body: some View {
        VStack {
            ForEach((1...3), id: \.self) {_ in
                Spacer()
                Text("DEMO MODE")
                    .font(.largeTitle)
                    .fontWeight(/*@START_MENU_TOKEN@*/.heavy/*@END_MENU_TOKEN@*/)
                    .foregroundColor(.gray)
                    .rotationEffect(Angle(degrees: 45))
                    .scaleEffect(2)
                    .opacity(0.25)
                Spacer()
            }
        }
    }
}

struct DemoModeBackground_Previews: PreviewProvider {
    static var previews: some View {
        DemoModeBackground()
    }
}
