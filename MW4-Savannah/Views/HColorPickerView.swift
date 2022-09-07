//
//  HColorPickerView.swift
//  MW4-Savannah
//
//  Created by Nicolas LEFEBVRE on 9/7/22.
//

import SwiftUI

let FastLEDHueGradient = Gradient(colors: [
    .red, .orange, .yellow, .green, .cyan, .blue, .purple, .pink, .red
])

struct HColorPickerView: View {
    @State private var color: Double = 0
    
    var body: some View {
        Slider(value: $color, in: 0...255)
            .background(LinearGradient(gradient: FastLEDHueGradient, startPoint: .leading, endPoint: .trailing)).clipShape(Capsule())
    }
}

struct HColorPickerView_Previews: PreviewProvider {
    static var previews: some View {
        HColorPickerView()
    }
}
