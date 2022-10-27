//
//  LightStripEffectChooserView.swift
//  MW4-Savannah
//
//  Created by Nicolas LEFEBVRE on 9/7/22.
//

import SwiftUI

func printColor(_ color: Color) {
    let uiColor = UIColor(color)
    
    var r: CGFloat = 0
    var g: CGFloat = 0
    var b: CGFloat = 0
    var a: CGFloat = 0
    
    var h: CGFloat = 0
    var s: CGFloat = 0
    var v: CGFloat = 0
    var a2: CGFloat = 0
    
    uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)
    uiColor.getHue(&h, saturation: &s, brightness: &v, alpha: &a2)
    print("RGB", r, g, b, a, separator: ";")
    print("HSV", h, s, v, a2, separator: ";")
}

struct LightStripEffectChooserView: View {
    @Binding var lights: LightsModelView
    
    @State private var isOn: Bool = true
    @State private var colorSelection: ColorMode
    
    init(lights: Binding<LightsModelView>) {
        _lights = lights
                
        if (lights.wrappedValue.color == .white) {
            colorSelection = .White
        } else if (lights.wrappedValue.color == .fullRed) {
            colorSelection = .Red
        } else {
            colorSelection = .Custom
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            //Only show additional UI if the toggle is On
            if (isOn){
                HStack {
                    Text("Mode")
                    Picker(selection: $lights.mode, label: Text("Or")) {
                        ForEach(LightMode.allCases) { item in
                            Text(item.title)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                }
                
                HStack {
                    Text("Color")
                    Picker(selection: $colorSelection, label: Text("Or")) {
                        ForEach(ColorMode.allCases) { item in
                            VStack{
                                Text(item.title)
                            }
                        }
                    }.pickerStyle(SegmentedPickerStyle()).disabled(lights.mode.rawValue > 1)
                    .onChange(of: colorSelection) { newValue in
                        switch newValue {
                        case .White:
                            lights.color = Color.white
                        case .Red:
                            lights.color = Color.fullRed
                        case .Custom:
                            break
                        }
                    }
                }
                if (colorSelection == .Custom && lights.mode != .cycle && lights.mode != .wave){
                    HColorPickerView(color: $lights.color)
                }
            }
        }
    }
}
