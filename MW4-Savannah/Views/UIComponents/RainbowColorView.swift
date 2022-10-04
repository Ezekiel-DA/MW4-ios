//
//  TestView.swift
//  MW4-Savannah
//
//  Created by LI Yun on 9/10/22.
//

import SwiftUI

let QuickHueGradient = Gradient(colors: [
    .red, .orange, .yellow, .green, .cyan, .blue, .purple, .pink, .red
])

struct RainbowColorView: View {
    let label: String
    
    @State private var color: Double = 0
    
    @State private var animateGradient = false
    
    var body: some View {
        VStack(alignment: .leading) {

           LinearGradient(
                    gradient: QuickHueGradient,
                    startPoint: .leading,
                    endPoint: .trailing)
           .hueRotation(.degrees(animateGradient ? 180 : 0))
           .frame(height: 31.0)
           .cornerRadius(15)
           .onAppear {
                 withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                     animateGradient.toggle()
                 }
             }
   
            
        }
    }
}

struct RainbowColorView_Previews: PreviewProvider {
    static var previews: some View {
        RainbowColorView(label: "Preview")
    }
}
