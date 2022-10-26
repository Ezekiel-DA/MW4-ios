//
//  LightStripEffectChooserView.swift
//  MW4-Savannah
//
//  Created by Nicolas LEFEBVRE on 9/7/22.
//

import SwiftUI

enum ColorMode: Int, CaseIterable, Identifiable {
    case White
    case Red
    case Custom
    
    var title: String {
        switch self {
        case .White: return "White"
        case .Red: return "Red"
        case .Custom: return "Custom"
        }
    }	
    
    var id: Self { self }
}

struct LightStripEffectChooserView: View {
    @Binding var lights: LightsModelView
    
    @State private var isOn: Bool = true
    @State private var colorSelection: ColorMode
    
    init(lights: Binding<LightsModelView>) {
        _lights = lights
        
        if (lights.wrappedValue.color == .white) {
            colorSelection = .White
        } else if (lights.wrappedValue.color == .red) {
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
                            lights.color = Color.red
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
//        .onAppear {
//            if (lights.color == .white) {
//                colorSelection = .White
//            } else if (lights.color == .red) {
//                colorSelection = .Red
//            } else {
//                colorSelection = .Custom
//            }
//        }
    }
}
