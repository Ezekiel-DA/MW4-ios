//
//  LightStripEffectChooserView.swift
//  MW4-Savannah
//
//  Created by Nicolas LEFEBVRE on 9/7/22.
//

import SwiftUI

enum LightModes: Int, CaseIterable {
    case Steady
    case Pulse
    case RainbowCycle
    case RainbowWave
        
    var title: String {
        switch self {
        case .Steady: return "Steady"
        case .Pulse: return "Pulse"
        case .RainbowCycle: return "Cycle"
        case .RainbowWave: return "Wave"
        }
    }
}

enum ColorModes: Int, CaseIterable {
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
}

struct LightStripEffectChooserView: View {
    @ObservedObject var device: LightDeviceService
    
    let isButtonSection: Bool
    @State private var isOn: Bool = true
    @State private var colorSelection: Int = 0
    
    var body: some View {
        VStack(alignment: .leading) {
            if (isButtonSection) {
//                Toggle(isOn: $isOn) { Text("Button Trigger").fontWeight(.heavy) }
                HStack {
                    Text("On button press:").fontWeight(.heavy)
                    Text("for 60 seconds").font(/*@START_MENU_TOKEN@*/.subheadline/*@END_MENU_TOKEN@*/).fontWeight(.light)
                }
                
            }
            else{
                //Text("Default:").fontWeight(.heavy)
            }
            //Only show additional UI if the toggle is On
            if (isOn){
                Text("Mode")
                Picker(selection: isButtonSection ? Binding($device.modeAlt)! : Binding($device.mode)!, label: Text("Or")) {
                    ForEach(LightModes.allCases, id: \.rawValue) { item in
                        
                            Text(item.title).tag(UInt8(item.rawValue))
                        
                    }
                }.pickerStyle(SegmentedPickerStyle())
                
                Text("Color")
                Picker(selection: $colorSelection, label: Text("Or")) {
                    ForEach(ColorModes.allCases, id: \.rawValue) { item in
                        VStack{
                            Text(item.title).tag(item.rawValue)
                        }
                    }
                }.pickerStyle(SegmentedPickerStyle()).disabled(device.mode ?? 0 > 1)
                
                if (colorSelection == 2){
                    HColorPickerView(hue: isButtonSection ?
                                     device.hueAlt != nil ? Binding($device.hueAlt)! : Binding.constant(0) :
                                     device.hue != nil ? Binding($device.hue)! : Binding.constant(0), label: "Color")
                }
            }
        }
    }
}

struct LightStripEffectChooserView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()
            LightStripEffectChooserView(device: LightDeviceService(), isButtonSection: false)
            Spacer()
            Divider()
            Spacer()
            LightStripEffectChooserView(device: LightDeviceService(), isButtonSection: true)
            Spacer()
        }
    }
}
