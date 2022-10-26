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
    @Binding var color: Color
    @State var hue: Double
    
    init(color: Binding<Color>) {
        _color = color
        
        let uiColor = UIColor(color.wrappedValue)
        var h: CGFloat = 0
        var s: CGFloat = 0
        var v: CGFloat = 0
        var a: CGFloat = 0
        
        uiColor.getHue(&h, saturation: &s, brightness: &v, alpha: &a)
        
        hue = h
    }
    
//    init(_ c: Color) {
//        color = c
//        let uiC = UIColor(color)
//        var hueTemp: CGFloat = 0
//        var saturationTemp: CGFloat = 0
//        var brightnessTemp: CGFloat = 0
//        var alphaTemp: CGFloat = 0
//
//        uiC.getHue(&hueTemp, saturation: &saturationTemp, brightness: &brightnessTemp, alpha: &alphaTemp)
//
//        hue = UInt8(hue / 360 * 255)
//    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Slider(value: $hue, in: 0...1)
                .background(LinearGradient(gradient: FastLEDHueGradient, startPoint: .leading, endPoint: .trailing)).clipShape(Capsule())
                .onChange(of: hue) {newValue in
                    color = Color(hue: hue, saturation: 1.0, brightness: 1.0)
                }
        }
    }
}

struct HColorPickerView_Previews: PreviewProvider {
    static var previews: some View {
        HColorPickerView(color: .constant(.white))
    }
}
