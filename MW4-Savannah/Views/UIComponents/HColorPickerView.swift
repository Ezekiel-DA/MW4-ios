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
    @Binding var hue: UInt8
    let label: String
    
    var body: some View {
        VStack(alignment: .leading) {
            //Text(label)
            Slider(value: $hue.double, in: 0...255)
                .background(LinearGradient(gradient: FastLEDHueGradient, startPoint: .leading, endPoint: .trailing)).clipShape(Capsule())
        }
    }
}
//
//struct HColorPickerView_Previews: PreviewProvider {
//    static var previews: some View {
//        HColorPickerView(hue: Binding(UInt8(0)), label: "Preview")
//    }
//}
