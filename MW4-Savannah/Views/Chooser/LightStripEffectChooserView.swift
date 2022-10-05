//
//  LightStripEffectChooserView.swift
//  MW4-Savannah
//
//  Created by Nicolas LEFEBVRE on 9/7/22.
//

import SwiftUI

enum LightModes: Int, CaseIterable {
    case White
    case Red
    case Rainbow
    case Custom
    
    
    
    var title: String {
        switch self {
        case .White: return "White"
        case .Red: return "Red"
        case .Rainbow: return "Rainbow"
        case .Custom: return "Custom"
        }
    }
}

enum RainbowModes: Int, CaseIterable {
    case Wave
    case Cycle
    
    
    
    var title: String {
        switch self {
        case .Wave: return "Wave"
        case .Cycle: return "Cycle"
        }
    }
}

struct LightStripEffectChooserView: View {
    let isButtonSection: Bool
    @State private var isOn: Bool = true
    @State private var colorPicked: Int = 0
    @State private var rainbowModePicked: Int = 0
    
    var body: some View {
        VStack(alignment: .leading) {
            if (isButtonSection) {
                Toggle(isOn: $isOn) { Text("Button Trigger").fontWeight(.heavy) }
                Text("Pulse desired color for 3s")
                    .padding(.bottom)
            }
            else{
                Text("Default Status").fontWeight(.heavy)
            }
            //Only show additional UI if the toggle is On
            if (isOn){
                Text("Color")
                Picker(selection: $colorPicked, label: Text("Or")) {
                    ForEach(LightModes.allCases, id: \.rawValue) { item in
                        VStack{

                            Text(item.title).tag(item.rawValue)
                        }
                           
                        
                       
                    }
                }.pickerStyle(SegmentedPickerStyle())
                
                Divider()
                if (colorPicked == 2) {
                    HStack{
                        Text("Rainbow Mode")
                        Spacer()
                        Picker(selection: $rainbowModePicked, label: Text("Or")) {
                            ForEach(RainbowModes.allCases, id: \.rawValue) { item in
                                VStack{
                                    Text(item.title).tag(item.rawValue)
                                }
                            }
                        }.pickerStyle(.menu)
                    }
                   
                }
                if (colorPicked == 3){
                    HColorPickerView(label: "Color")
                    
                }
            }
     

        }
    }
}

struct LightStripEffectChooserView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()
            LightStripEffectChooserView(isButtonSection: false)
            Spacer()
            Divider()
            Spacer()
            LightStripEffectChooserView(isButtonSection: true)
            Spacer()
        }
    }
}
