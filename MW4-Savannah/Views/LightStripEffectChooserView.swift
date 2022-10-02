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
    
    var title: String {
        switch self {
        case .White: return "White"
        case .Red: return "Red"
        case .Rainbow: return "Rainbow"
        }
    }
}

struct LightStripEffectChooserView: View {
    let name: String
    
    @State private var isOn: Bool = true
    @State private var picked: Int = 0
    
    var body: some View {
        VStack {
            if (name != "") {
                Toggle(isOn: $isOn) { Text(name).fontWeight(.heavy) }
            }
            HColorPickerView(label: "Color")
            Divider()
            
            Picker(selection: $picked, label: Text("Or")) {
                ForEach(LightModes.allCases, id: \.rawValue) { item in
                    Text(item.title).tag(item.rawValue)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
    }
}

struct LightStripEffectChooserView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()
            LightStripEffectChooserView(name: "")
            Spacer()
            Divider()
            Spacer()
            LightStripEffectChooserView(name: "Button Trigger")
            Spacer()
        }
    }
}
